# 🚀 PostgreSQL 17 + Monitoreo Completo - Guía Definitiva

Implementa PostgreSQL 17 con **Prometheus + Grafana** en las 4 modalidades: Development, Testing, Production y Analytics.

---

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#-requisitos-previos)
2. [Modalidades Disponibles](#-modalidades-disponibles)
3. [Inicio Rápido](#-inicio-rápido)
4. [Acceso a Servicios](#-acceso-a-servicios)
5. [Paneles de Grafana](#-paneles-de-grafana)
6. [Verificación y Testing](#-verificación-y-testing)
7. [Gestión de Servicios](#-gestión-de-servicios)
8. [Solución de Problemas](#-solución-de-problemas)

---

## ✅ Requisitos Previos

- **Docker Desktop** instalado y funcionando
- **Docker Compose** (incluido en Docker Desktop)
- **Recursos mínimos**:
  - Development: 1GB RAM
  - Testing: 512MB RAM
  - Production: 4GB RAM
  - Analytics: 2GB RAM

---

## 🎯 Modalidades Disponibles

### 1. Development (Desarrollo Local)
```yaml
RAM: 512MB - 1GB
Shared Buffers: 128MB
Conexiones: 20
Logging: Completo (todas las queries)
Persistencia: ✅ Datos permanentes
Reinicio: Automático
Puerto: 5432
```
**Ideal para**: Desarrollo local, pruebas rápidas, debugging

### 2. Testing (CI/CD)
```yaml
RAM: 256MB - 512MB
Shared Buffers: 64MB
Conexiones: 10
Logging: Desactivado
Persistencia: ❌ Memoria temporal (tmpfs)
Reinicio: No
Puerto: 5432
```
**Ideal para**: Tests automatizados, pipelines CI/CD, testing de integración

### 3. Production (Producción)
```yaml
RAM: 4GB - 8GB+
Shared Buffers: 2GB
Conexiones: 200
Logging: Solo errores y queries lentas
Persistencia: ✅ Datos permanentes + archivos de config
Reinicio: Siempre
Puerto: 5432
```
**Ideal para**: Ambientes de producción, alta carga, transacciones críticas

### 4. Analytics (Análisis/BI)
```yaml
RAM: 2GB - 4GB
Shared Buffers: 1GB
Work Memory: 128MB (para queries complejas)
Conexiones: 50
Logging: Queries > 5 segundos
Persistencia: ✅ Datos permanentes
Reinicio: Automático
Puerto: 5432
```
**Ideal para**: Data warehouse, queries complejas, análisis de datos, reportería

---

## 🚀 Inicio Rápido

### Paso 1: Navegar al directorio

```powershell
cd D:\DB-Motores\postgres
```

### Paso 2: Levantar la modalidad deseada

#### Development
```powershell
docker-compose -f templates/development.yml up -d
```

#### Testing
```powershell
docker-compose -f templates/testing.yml up -d
```

#### Production
```powershell
# Primero configurar variables de entorno (crear archivo .env)
# Ver sección de configuración de producción abajo
docker-compose -f templates/production.yml up -d
```

#### Analytics
```powershell
docker-compose -f templates/analytics.yml up -d
```

### Paso 3: Verificar que los servicios están corriendo

```powershell
# Ver estado de los contenedores
docker-compose -f templates/development.yml ps

# Ver logs en tiempo real
docker-compose -f templates/development.yml logs -f
```

---

## 🌐 Acceso a Servicios

### 🔵 Development

| Servicio | URL/Puerto | Usuario | Contraseña |
|----------|------------|---------|------------|
| **PostgreSQL** | `localhost:5432` | `dev_user` | `dev_pass_123` |
| **Grafana** | http://localhost:3000 | `admin` | `dev_admin_123` |
| **Prometheus** | http://localhost:9090 | - | - |
| **Exporter** | http://localhost:9187/metrics | - | - |

**Base de datos**: `dev_database`

### 🟡 Testing

| Servicio | URL/Puerto | Usuario | Contraseña |
|----------|------------|---------|------------|
| **PostgreSQL** | `localhost:5432` | `test_user` | `test_pass` |
| **Grafana** | http://localhost:3001 | `admin` | `admin` |
| **Prometheus** | http://localhost:9090 | - | - |
| **Exporter** | http://localhost:9187/metrics | - | - |

**Base de datos**: `test_db`

### 🟢 Production

| Servicio | URL/Puerto | Usuario | Contraseña |
|----------|------------|---------|------------|
| **PostgreSQL** | `localhost:5432` | `${POSTGRES_USER}` | `${POSTGRES_PASSWORD}` |
| **Grafana** | http://localhost:3000 | `${GF_ADMIN_USER}` | `${GF_ADMIN_PASSWORD}` |
| **Prometheus** | http://localhost:9090 | - | - |
| **Exporter** | http://localhost:9187/metrics | - | - |

**Crear archivo `.env` con**:
```bash
POSTGRES_USER=prod_user
POSTGRES_PASSWORD=secure_password_here
POSTGRES_DB=production_db
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=secure_grafana_password
```

### 🟣 Analytics

| Servicio | URL/Puerto | Usuario | Contraseña |
|----------|------------|---------|------------|
| **PostgreSQL** | `localhost:5432` | `analytics_user` | `analytics_pass_456` |
| **Grafana** | http://localhost:3000 | `admin` | `analytics_admin_789` |
| **Prometheus** | http://localhost:9090 | - | - |
| **Exporter** | http://localhost:9187/metrics | - | - |

**Base de datos**: `analytics_db`

---

## 📊 Paneles de Grafana

Una vez que accedas a Grafana, encontrarás **6 paneles preconfigurados**:

### 1. **PostgreSQL Overview** 📈
- Visión general del sistema
- Conexiones activas
- Transacciones por segundo
- Cache hit ratio
- Uso de CPU/Memoria

### 2. **PostgreSQL Checkpoints** 🔄
- Tasa de checkpoints
- Checkpoints programados vs solicitados
- Tiempo de escritura y sincronización
- Buffers escritos

### 3. **PostgreSQL Configuration** ⚙️
- Parámetros de configuración actuales
- Shared buffers
- Work memory
- Max connections
- Configuraciones críticas

### 4. **PostgreSQL Performance I/O** 💾
- I/O de lectura/escritura
- Bloques leídos del cache
- Bloques escritos a disco
- WAL writes
- Background writer stats

### 5. **PostgreSQL Queries & Locks** 🔒
- Queries activas
- Queries lentas (> 5 segundos)
- Locks activos
- Deadlocks
- Bloqueos por tabla

### 6. **PostgreSQL Tables & Indexes** 🗂️
- Tablas más grandes
- Índices no utilizados
- Sequential scans vs Index scans
- Dead tuples (VACUUM needed)
- Estadísticas por tabla

---

## ✅ Verificación y Testing

### 1. Verificar Salud de PostgreSQL

```powershell
# Verificar que PostgreSQL responde
docker exec postgres_dev pg_isready -U dev_user

# Ver versión de PostgreSQL
docker exec postgres_dev psql -U dev_user -d dev_database -c "SELECT version();"

# Ver extensiones instaladas
docker exec postgres_dev psql -U dev_user -d dev_database -c "\dx"
```

### 2. Verificar Métricas del Exporter

```powershell
# Ver todas las métricas disponibles
curl http://localhost:9187/metrics | Select-String "pg_"

# Ver métricas de conexiones
curl http://localhost:9187/metrics | Select-String "pg_stat_database_numbackends"

# Ver métricas de checkpoints
curl http://localhost:9187/metrics | Select-String "pg_checkpointer"
```

### 3. Probar Conexión a PostgreSQL

```powershell
# Desde PowerShell (requiere psql instalado)
psql -h localhost -p 5432 -U dev_user -d dev_database

# Con Docker
docker exec -it postgres_dev psql -U dev_user -d dev_database

# Query de prueba
SELECT 
  datname as database,
  count(*) as connections
FROM pg_stat_activity 
GROUP BY datname;
```

### 4. Verificar Prometheus

```powershell
# Abrir en navegador
start http://localhost:9090

# Verificar targets en Prometheus
start http://localhost:9090/targets
```

### 5. Verificar Grafana

```powershell
# Abrir Grafana
start http://localhost:3000

# Login con credenciales de tu modalidad
# Navegar a: Dashboards → Browse → PostgreSQL Dashboards
```

---

## 🎮 Gestión de Servicios

### Iniciar Servicios

```powershell
docker-compose -f templates/development.yml up -d
```

### Detener Servicios (mantiene datos)

```powershell
docker-compose -f templates/development.yml stop
```

### Reiniciar Servicios

```powershell
docker-compose -f templates/development.yml restart
```

### Detener y Eliminar Contenedores (mantiene volúmenes)

```powershell
docker-compose -f templates/development.yml down
```

### Eliminar TODO (incluye datos)

```powershell
# ⚠️ CUIDADO: Esto elimina los datos permanentemente
docker-compose -f templates/development.yml down -v
```

### Ver Logs

```powershell
# Todos los servicios
docker-compose -f templates/development.yml logs -f

# Solo PostgreSQL
docker-compose -f templates/development.yml logs -f postgres

# Solo Grafana
docker-compose -f templates/development.yml logs -f grafana

# Últimas 100 líneas
docker-compose -f templates/development.yml logs --tail=100
```

### Ver Recursos Utilizados

```powershell
# CPU y memoria de cada contenedor
docker stats

# Espacio en disco de volúmenes
docker volume ls
docker volume inspect postgres_dev_data
```

---

## 🔧 Solución de Problemas

### Problema 1: Puerto 5432 ya está en uso

```powershell
# Ver qué proceso usa el puerto
netstat -ano | findstr :5432

# Opción 1: Detener el servicio PostgreSQL local de Windows
Stop-Service postgresql-x64-17

# Opción 2: Cambiar el puerto en el docker-compose
# Editar el archivo y cambiar "5432:5432" por "5433:5432"
```

### Problema 2: Grafana no muestra datos

```powershell
# Verificar que Prometheus esté funcionando
curl http://localhost:9090/api/v1/targets

# Verificar que el exporter tenga métricas
curl http://localhost:9187/metrics

# Reiniciar Grafana
docker-compose -f templates/development.yml restart grafana
```

### Problema 3: "No space left on device"

```powershell
# Limpiar imágenes no usadas
docker image prune -a

# Limpiar volúmenes no usados
docker volume prune

# Limpiar todo el sistema
docker system prune -a --volumes
```

### Problema 4: Contenedor se reinicia constantemente

```powershell
# Ver logs para identificar el error
docker-compose -f templates/development.yml logs postgres

# Verificar salud del contenedor
docker inspect postgres_dev | Select-String "Health"

# Errores comunes:
# - Archivo postgresql.conf con sintaxis incorrecta
# - Permisos incorrectos en volúmenes
# - Memoria insuficiente
```

### Problema 5: Conexión rechazada desde aplicación externa

```powershell
# Verificar que el contenedor escucha en 0.0.0.0
docker exec postgres_dev netstat -tulpn | findstr 5432

# Verificar pg_hba.conf permite conexiones
docker exec postgres_dev cat /var/lib/postgresql/data/pg_hba.conf

# Agregar entrada si es necesario:
# host    all    all    0.0.0.0/0    scram-sha-256
```

### Problema 6: Paneles de Grafana vacíos

```powershell
# Verificar que pg_stat_statements esté habilitado
docker exec postgres_dev psql -U dev_user -d dev_database -c "SELECT * FROM pg_extension WHERE extname='pg_stat_statements';"

# Si no está, crearla manualmente
docker exec postgres_dev psql -U dev_user -d dev_database -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"

# Reiniciar PostgreSQL
docker-compose -f templates/development.yml restart postgres
```

---

## 📚 Recursos Adicionales

### Archivos de Configuración

- **Queries Personalizadas**: [`config/queries/postgres-queries.yaml`](config/queries/postgres-queries.yaml)
- **Config Prometheus Dev**: [`config/prometheus/dev.yml`](config/prometheus/dev.yml)
- **Config Prometheus Prod**: [`config/prometheus/prod.yml`](config/prometheus/prod.yml)
- **Config Prometheus Test**: [`config/prometheus/test.yml`](config/prometheus/test.yml)
- **Config Prometheus Analytics**: [`config/prometheus/analytics.yml`](config/prometheus/analytics.yml)
- **Scripts de Inicialización**: [`init-scripts/`](init-scripts/)

### Documentación

- [PostgreSQL 17 Documentation](https://www.postgresql.org/docs/17/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Postgres Exporter](https://github.com/prometheus-community/postgres_exporter)

### Scripts útiles

Ver [templates/README.md](templates/README.md) para más detalles sobre cada modalidad.

---

## 🎯 Siguientes Pasos

1. ✅ **Levantar tu modalidad preferida**
2. ✅ **Acceder a Grafana y explorar los dashboards**
3. ✅ **Conectar tu aplicación a PostgreSQL**
4. 📊 **Crear tus propios paneles personalizados**
5. 🔔 **Configurar alertas en Prometheus**
6. 💾 **Configurar backups automáticos**

---

## 📞 Soporte

Para más información o problemas específicos:
- Ver: [STRUCTURE.md](STRUCTURE.md) - Estructura completa del proyecto
- Ver: [CONFIGURACION-VOLUMENES.md](CONFIGURACION-VOLUMENES.md) - Configuración de volúmenes
- Ver: [SOLUCION-AMBIENTES.md](SOLUCION-AMBIENTES.md) - Soluciones por ambiente

---

**¡Disfruta de tu PostgreSQL con monitoreo completo! 🚀**
