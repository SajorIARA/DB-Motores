# ✅ Lista de Verificación - PostgreSQL + Monitoreo

Este documento te guía para verificar que **TODO** funciona correctamente.

---

## 🎯 Test Rápido (5 minutos)

### 1. Iniciar Development

```powershell
cd D:\DB-Motores\postgres
.\start-development.ps1
```

**Esperar:** Los scripts muestran mensajes de estado

**Verificar:**
- ✅ Mensaje "Servicios iniciados correctamente"
- ✅ 4 contenedores en estado "Up"

---

### 2. Verificar PostgreSQL

```powershell
# Test 1: PostgreSQL responde
docker exec postgres_dev pg_isready -U dev_user

# Resultado esperado: "postgres_dev:5432 - accepting connections"

# Test 2: Ver versión
docker exec postgres_dev psql -U dev_user -d dev_database -c "SELECT version();"

# Resultado esperado: "PostgreSQL 17..."

# Test 3: Ver extensiones instaladas
docker exec postgres_dev psql -U dev_user -d dev_database -c "\dx"

# Resultado esperado: 
# - pg_stat_statements ✅
# - pg_trgm ✅
# - btree_gin ✅
# - btree_gist ✅
```

**✅ PASS:** PostgreSQL funciona y extensiones instaladas

---

### 3. Verificar Métricas del Exporter

```powershell
# Test 1: Exporter responde
curl http://localhost:9187/metrics

# Resultado esperado: Cientos de líneas con métricas

# Test 2: Verificar métricas específicas
curl http://localhost:9187/metrics | Select-String "pg_stat_database_numbackends"

# Resultado esperado: Líneas con "pg_stat_database_numbackends"

# Test 3: Contar métricas disponibles
(curl http://localhost:9187/metrics | Select-String "^pg_").Count

# Resultado esperado: > 100 métricas
```

**✅ PASS:** Exporter recolectando métricas correctamente

---

### 4. Verificar Prometheus

```powershell
# Abrir Prometheus
start http://localhost:9090

# En la interfaz web:
# 1. Ir a "Status" → "Targets"
# 2. Verificar que "postgresql" está "UP"
# 3. Ir a "Graph"
# 4. Escribir: pg_stat_activity_count
# 5. Click "Execute"
```

**Resultado esperado:**
- ✅ Target "postgresql" en estado UP
- ✅ Query muestra datos numéricos
- ✅ Gráfica se dibuja correctamente

**✅ PASS:** Prometheus recolectando de postgres-exporter

---

### 5. Verificar Grafana - CRÍTICO ⭐

```powershell
# Abrir Grafana
start http://localhost:3000
```

#### Login
- Usuario: `admin`
- Password: `dev_admin_123`

#### Verificar Datasource
1. Ir a: **Configuration** → **Data Sources**
2. Verificar que existe **Prometheus**
3. Click en **Prometheus**
4. Scroll down y click **Save & Test**

**Resultado esperado:**
- ✅ Mensaje verde: "Data source is working"

#### Verificar Dashboards (LO MÁS IMPORTANTE)
1. Ir a: **Dashboards** → **Browse**
2. Deberías ver una carpeta o sección "PostgreSQL Dashboards"

**Resultado esperado: 6 dashboards**
1. ✅ postgresql-checkpoints
2. ✅ postgresql-config
3. ✅ postgresql-overview
4. ✅ postgresql-performance-io
5. ✅ postgresql-queries-locks
6. ✅ postgresql-tables-indexes

#### Verificar Datos en Dashboard
1. Click en **postgresql-overview**
2. Esperar 5 segundos a que carguen los paneles

**Verificar que se muestran datos en:**
- ✅ Conexiones activas (número > 0)
- ✅ Cache hit ratio (porcentaje cerca de 100%)
- ✅ Transacciones (gráfica con líneas)
- ✅ Checkpoints (números o gráfica)

**✅ PASS:** Grafana muestra datos de PostgreSQL en los paneles

---

## 🎯 Test Completo (15 minutos)

### Test 1: Queries Personalizadas

```powershell
# Verificar que las queries personalizadas funcionan
curl http://localhost:9187/metrics | Select-String "pg_connections_by_state"
curl http://localhost:9187/metrics | Select-String "pg_slow_queries"
curl http://localhost:9187/metrics | Select-String "pg_database_size"
curl http://localhost:9187/metrics | Select-String "pg_table_sizes"
```

**Resultado esperado:**
- ✅ Cada query devuelve métricas

---

### Test 2: Generar Carga y Ver en Grafana

```powershell
# Conectar a PostgreSQL
docker exec -it postgres_dev psql -U dev_user -d dev_database

# Dentro de psql, ejecutar:
```

```sql
-- Crear tabla de prueba
CREATE TABLE test_monitoring (
    id SERIAL PRIMARY KEY,
    data TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insertar 10,000 registros
INSERT INTO test_monitoring (data)
SELECT 'Test data ' || generate_series(1, 10000);

-- Ver estadísticas
SELECT 
    schemaname,
    relname as table_name,
    n_live_tup as live_rows,
    n_dead_tup as dead_rows
FROM pg_stat_user_tables
WHERE relname = 'test_monitoring';

-- Query lenta intencional (>5 segundos)
SELECT pg_sleep(6);

-- Salir
\q
```

**Ahora en Grafana:**
1. Ir a dashboard **postgresql-tables-indexes**
2. Deberías ver la tabla `test_monitoring`
3. Ir a dashboard **postgresql-queries-locks**
4. Deberías haber visto la query lenta (si refrescaste rápido)

**✅ PASS:** Los cambios en PostgreSQL se reflejan en Grafana

---

### Test 3: Probar Todas las Modalidades

#### Testing
```powershell
# Iniciar Testing
.\start-testing.ps1

# Esperar 10 segundos

# Verificar
docker ps | Select-String "postgres_test"
curl http://localhost:9187/metrics | Select-String "pg_stat_database"

# Detener
docker-compose -f templates/testing.yml down

# ✅ PASS si funciona
```

#### Production
```powershell
# Crear archivo .env primero
Copy-Item .env.example .env

# Editar .env y cambiar las contraseñas (opcional para test)

# Iniciar Production
.\start-production.ps1

# Esperar 15 segundos

# Verificar
docker ps | Select-String "postgres_prod"
start http://localhost:3000

# Detener
docker-compose -f templates/production.yml down

# ✅ PASS si funciona
```

#### Analytics
```powershell
# Iniciar Analytics
.\start-analytics.ps1

# Esperar 10 segundos

# Verificar
docker ps | Select-String "postgres_analytics"
curl http://localhost:9187/metrics | Select-String "pg_stat_database"

# Detener
docker-compose -f templates/analytics.yml down

# ✅ PASS si funciona
```

---

### Test 4: Gestor Interactivo

```powershell
# Ejecutar gestor
.\postgres-manager.ps1
```

**Probar:**
1. ✅ Opción 1: Iniciar Development
2. ✅ Opción 5: Ver estado de todos los ambientes
3. ✅ Opción 6: Detener todos los ambientes
4. ✅ Opción 8: Ver ayuda
5. ✅ Opción 9: Salir

**✅ PASS:** Gestor funciona correctamente

---

## 📊 Checklist de Verificación Final

### PostgreSQL
- [ ] PostgreSQL responde a `pg_isready`
- [ ] Versión es PostgreSQL 17
- [ ] Extensiones instaladas: pg_stat_statements, pg_trgm, btree_gin, btree_gist
- [ ] Se pueden crear tablas y insertar datos
- [ ] Logs se ven correctamente con `docker logs`

### Exporter
- [ ] http://localhost:9187/metrics responde
- [ ] Muestra métricas con prefijo `pg_`
- [ ] Queries personalizadas funcionan (pg_connections_by_state, etc.)
- [ ] Muestra > 100 métricas diferentes

### Prometheus
- [ ] http://localhost:9090 abre correctamente
- [ ] Target "postgresql" está UP
- [ ] Query `pg_stat_activity_count` devuelve datos
- [ ] Query `pg_stat_database_numbackends` devuelve datos
- [ ] Gráficas se dibujan correctamente

### Grafana - CRÍTICO
- [ ] http://localhost:3000 abre correctamente
- [ ] Login funciona con credenciales
- [ ] Datasource "Prometheus" está configurado y funciona
- [ ] Se ven 6 dashboards en "Browse"
- [ ] Dashboard "postgresql-overview" muestra datos
- [ ] Dashboard "postgresql-checkpoints" muestra datos
- [ ] Dashboard "postgresql-config" muestra configuraciones
- [ ] Dashboard "postgresql-performance-io" muestra métricas I/O
- [ ] Dashboard "postgresql-queries-locks" muestra queries activas
- [ ] Dashboard "postgresql-tables-indexes" muestra tablas

### Modalidades
- [ ] Development funciona completamente
- [ ] Testing funciona completamente
- [ ] Production funciona completamente
- [ ] Analytics funciona completamente

### Scripts
- [ ] postgres-manager.ps1 funciona
- [ ] start-development.ps1 funciona
- [ ] start-testing.ps1 funciona
- [ ] start-production.ps1 funciona
- [ ] start-analytics.ps1 funciona

### Documentación
- [ ] README.md tiene información actualizada
- [ ] GUIA-COMPLETA.md es comprensible
- [ ] METRICAS-DISPONIBLES.md lista las métricas
- [ ] RESUMEN.md resume todo
- [ ] .env.example existe para producción

---

## 🐛 Problemas Comunes y Soluciones

### ❌ Grafana no muestra datos

**Síntomas:**
- Dashboards cargan pero paneles están vacíos
- Mensaje "No data"

**Solución:**
```powershell
# 1. Verificar que postgres-exporter funciona
curl http://localhost:9187/metrics

# 2. Verificar targets en Prometheus
start http://localhost:9090/targets
# Debe estar UP

# 3. Verificar en Prometheus que hay datos
# Ir a http://localhost:9090 y ejecutar:
pg_stat_activity_count

# 4. Si todo lo anterior funciona, el problema es Grafana
# Reiniciar Grafana
docker restart grafana_dev

# 5. Verificar datasource en Grafana
# Configuration → Data Sources → Prometheus → Test
```

---

### ❌ Puerto 5432 ocupado

**Síntomas:**
- Error al iniciar: "port is already allocated"

**Solución:**
```powershell
# Ver qué usa el puerto
netstat -ano | findstr :5432

# Si es PostgreSQL local, detenerlo
Stop-Service postgresql-x64-17

# O cambiar el puerto en el template
# Editar templates/development.yml
# Cambiar "5432:5432" por "5433:5432"
```

---

### ❌ Contenedor se reinicia constantemente

**Síntomas:**
- `docker ps` muestra el contenedor reiniciándose
- Status: "Restarting (1) X seconds ago"

**Solución:**
```powershell
# Ver logs para identificar el error
docker logs postgres_dev

# Errores comunes:
# 1. Memoria insuficiente → Reducir shared_buffers
# 2. Configuración incorrecta → Verificar sintaxis
# 3. Permisos de volúmenes → Verificar permisos

# Solución temporal: Ver logs y ajustar configuración
```

---

### ❌ Extensiones no instaladas

**Síntomas:**
- `\dx` no muestra pg_stat_statements

**Solución:**
```powershell
# Verificar que los scripts de init están montados
docker inspect postgres_dev | Select-String "init-scripts"

# Si no están, agregar en templates/development.yml:
# volumes:
#   - ../init-scripts/00-extensions.sql:/docker-entrypoint-initdb.d/00-extensions.sql:ro

# Recrear contenedor
docker-compose -f templates/development.yml down -v
docker-compose -f templates/development.yml up -d
```

---

## ✅ Resultado Esperado

Si **TODOS** los tests pasan:

```
✅ PostgreSQL 17 funcionando
✅ Extensiones instaladas automáticamente
✅ postgres-exporter recolectando métricas
✅ Prometheus recibiendo métricas
✅ Grafana mostrando datos en los 6 dashboards
✅ Las 4 modalidades funcionan correctamente
✅ Scripts PowerShell funcionan
✅ Gestor interactivo funciona
```

**🎉 ¡SISTEMA 100% FUNCIONAL! 🎉**

---

## 📞 Si Algo No Funciona

1. **Revisar logs:**
   ```powershell
   docker-compose -f templates/development.yml logs
   ```

2. **Reiniciar servicios:**
   ```powershell
   docker-compose -f templates/development.yml restart
   ```

3. **Recrear desde cero:**
   ```powershell
   docker-compose -f templates/development.yml down -v
   docker-compose -f templates/development.yml up -d
   ```

4. **Ver documentación:**
   - [GUIA-COMPLETA.md](GUIA-COMPLETA.md) - Solución de problemas
   - [README.md](README.md) - Documentación general

---

**¡Buena suerte con las pruebas! 🚀**
