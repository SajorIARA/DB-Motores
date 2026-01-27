# 🐘 PostgreSQL 17 + Prometheus + Grafana - Stack Completo de Monitoreo

Sistema completo de PostgreSQL 17 con monitoreo avanzado mediante Prometheus y visualización en Grafana. Incluye **4 modalidades pre-configuradas** (Development, Testing, Production, Analytics) con **6 dashboards profesionales** y **scripts de inicio automatizados**.

---

## ✨ Características Principales

- ✅ **PostgreSQL 17 Alpine** - Última versión estable
- ✅ **4 Modalidades** - Development, Testing, Production, Analytics
- ✅ **6 Dashboards Grafana** - Listos para usar
- ✅ **350+ Métricas** vía postgres_exporter
- ✅ **Auto-configuración** - pg_stat_statements y extensiones automáticas
- ✅ **Scripts PowerShell** - Inicio con un click
- ✅ **Compatible Windows/Linux/Mac** - 100% Docker

---

## 🎯 Modalidades Disponibles

### 🔵 Development (Desarrollo Local)
- **RAM**: 512MB - 1GB
- **Propósito**: Desarrollo local y testing rápido
- **Logging**: Completo (todas las queries)
- **Persistencia**: ✅ Datos permanentes

### 🟡 Testing (CI/CD)
- **RAM**: 256MB - 512MB
- **Propósito**: Tests automatizados, pipelines CI/CD
- **Logging**: Desactivado (performance)
- **Persistencia**: ❌ Todo en memoria (tmpfs)

### 🟢 Production (Producción)
- **RAM**: 4GB - 8GB+
- **Propósito**: Alta carga, performance máxima
- **Logging**: Solo errores y queries lentas
- **Persistencia**: ✅ Datos permanentes + config files

### 🟣 Analytics (Análisis/BI)
- **RAM**: 2GB - 4GB
- **Propósito**: Queries complejas, data warehouse
- **Logging**: Queries > 5 segundos
- **Persistencia**: ✅ Datos permanentes

---

## 🚀 Inicio Rápido (2 Formas)

### Opción 1: Script Interactivo (Recomendado)

```powershell
# Ejecutar el gestor interactivo
.\postgres-manager.ps1
```

El script te permite:
- ✅ Elegir modalidad con menú visual
- ✅ Ver estado de todos los ambientes
- ✅ Detener/Iniciar servicios fácilmente
- ✅ Acceso a ayuda y documentación

### Opción 2: Scripts Individuales

```powershell
# Development
.\start-development.ps1

# Testing
.\start-testing.ps1

# Production
.\start-production.ps1

# Analytics
.\start-analytics.ps1
```

### Opción 3: Docker Compose Manual

```powershell
# Navegar al directorio
cd d:\DB-Motores\postgres

# Levantar la modalidad deseada
docker-compose -f templates/development.yml up -d
docker-compose -f templates/testing.yml up -d
docker-compose -f templates/production.yml up -d
docker-compose -f templates/analytics.yml up -d
```

---

## 🌐 Acceso a Servicios

### Development
| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| PostgreSQL | `localhost:5432` | `dev_user` | `dev_pass_123` |
| Grafana | http://localhost:3000 | `admin` | `dev_admin_123` |
| Prometheus | http://localhost:9090 | - | - |

### Testing
| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| PostgreSQL | `localhost:5432` | `test_user` | `test_pass` |
| Grafana | http://localhost:3001 | `admin` | `admin` |
| Prometheus | http://localhost:9090 | - | - |

### Production
| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| PostgreSQL | `localhost:5432` | Ver `.env` | Ver `.env` |
| Grafana | http://localhost:3000 | Ver `.env` | Ver `.env` |
| Prometheus | http://localhost:9090 | - | - |

### Analytics
| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| PostgreSQL | `localhost:5432` | `analytics_user` | `analytics_pass_456` |
| Grafana | http://localhost:3000 | `admin` | `analytics_admin_789` |
| Prometheus | http://localhost:9090 | - | - |

---

## 📊 Dashboards de Grafana (6 Paneles)

Una vez en Grafana (http://localhost:3000), encontrarás:

### 1. **PostgreSQL Overview** 📈
Visión general del sistema: conexiones, transacciones, cache hit ratio, uso de recursos

### 2. **PostgreSQL Checkpoints** 🔄
Checkpoints programados vs solicitados, timing, buffers escritos, WAL

### 3. **PostgreSQL Configuration** ⚙️
Configuración actual: shared_buffers, work_mem, max_connections, parámetros críticos

### 4. **PostgreSQL Performance I/O** 💾
I/O de lectura/escritura, bloques del cache, escrituras a disco, background writer

### 5. **PostgreSQL Queries & Locks** 🔒
Queries activas, queries lentas (>5s), locks, deadlocks, bloqueos por tabla

### 6. **PostgreSQL Tables & Indexes** 🗂️
Tablas más grandes, índices no usados, scans secuenciales vs índices, dead tuples

---

## 📁 Estructura del Proyecto

```
postgres/
├── 📄 README.md                        # Este archivo - Documentación principal
├── 📄 QUICK-START.md                   # Guía rápida de inicio
├── 📄 STRUCTURE.md                     # Documentación técnica detallada
├── 📄 METRICAS-DISPONIBLES.md          # Catálogo de 350+ métricas
│
├── 📂 templates/                       # ⭐ PLANTILLAS PRE-CONFIGURADAS
│   ├── 📄 README.md                    # Comparativa de plantillas
│   ├── 📄 .env                         # Variables de entorno (NO commitear)
│   ├── 📄 .env.example                 # Ejemplo de configuración
│   ├── 📄 development.yml              # Desarrollo local (128MB shared_buffers)
│   ├── 📄 production.yml               # Producción (1GB shared_buffers)
│   ├── 📄 testing.yml                  # CI/CD (64MB, sin persistencia)
│   └── 📄 analytics.yml                # Analytics (1GB, 128MB work_mem)
│
├── 📂 grafana/                         # Configuración de Grafana
│   ├── 📄 README.md                    # Guía de uso de dashboards
│   └── 📂 provisioning/
│       ├── 📂 datasources/             # Auto-configuración de Prometheus
│       │   └── prometheus-datasource.yml
│       └── 📂 dashboards/              # 5 dashboards funcionales
│           ├── dashboard-provider.yml
│           ├── postgresql-overview.json
│           ├── postgresql-config.json
│           ├── postgresql-performance-io.json
│           ├── postgresql-queries-locks.json
│           └── postgresql-tables-indexes.json
│
├── 📂 config/                          # Configuración de PostgreSQL
│   ├── 📄 README.md                    # Guía de configuración
│   ├── 📄 postgresql.conf              # Config actual (production)
│   ├── 📄 pg_hba.conf                  # Autenticación (production)
│   ├── 📄 postgresql.conf.example      # Template con documentación
│   └── 📄 pg_hba.conf.example          # Template de autenticación
│
├── 📂 init-scripts/                    # Scripts de inicialización SQL
│   ├── 📄 README.md
│   ├── 00-create-exporter-user.sql     # Usuario para postgres_exporter
│   ├── 01-init.sql.example             # Schemas y tablas iniciales
│   ├── 02-functions.sql.example        # Funciones personalizadas
│   └── 03-setup.sh.example             # Script de setup automatizado
│
├── 📄 postgres-queries-safe.yaml       # ⭐ Custom queries (PostgreSQL 17)
├── 📄 prometheus.yml                   # Configuración de Prometheus
└── 📄 .gitignore                       # Ignorar .env, data/, logs/
```

Ver [STRUCTURE.md](STRUCTURE.md) para documentación técnica completa.

---

## 🎯 Plantillas Disponibles

### Comparativa Rápida

| Plantilla | RAM | shared_buffers | work_mem | Conexiones | Uso Principal |
|-----------|-----|----------------|----------|------------|---------------|
| **development.yml** | 512MB-1GB | 128MB | 4MB | 20 | Desarrollo local, debugging |
| **production.yml** | 2GB-8GB | 1GB | 16MB | 100 | Producción, alta carga |
| **testing.yml** | 256MB-512MB | 64MB | 2MB | 10 | CI/CD, tests automatizados |
| **analytics.yml** | 2GB-4GB | 1GB | 128MB | 50 | Data warehouse, BI, queries complejas |

**Persistencia:**
- ✅ `development.yml`, `production.yml`, `analytics.yml` - Datos en volúmenes Docker
- ⚠️ `testing.yml` - Todo en memoria (tmpfs), se pierde al eliminar contenedor

Ver [templates/README.md](templates/README.md) para configuración detallada de cada plantilla.

---

## 📊 Dashboards de Grafana

Todos los dashboards están **pre-configurados** y muestran datos en tiempo real.

### 1. 📊 PostgreSQL - Vista General
**Métricas principales del servidor**
- Estado del servidor (pg_up)
- Conexiones activas por estado
- Cache Hit Ratio (debe estar > 95%)
- Tamaño total de base de datos
- Transacciones/s (commits + rollbacks)
- Operaciones DML (INSERT, UPDATE, DELETE)
- Archivos temporales (indica falta de work_mem)

### 2. ⚙️ PostgreSQL - Configuración
**Visualización de parámetros de PostgreSQL**
- **Memoria:** shared_buffers, work_mem, maintenance_work_mem, effective_cache_size
- **Conexiones:** max_connections, checkpoint_timeout
- **WAL:** max_wal_size, min_wal_size
- **Costos:** random_page_cost, effective_io_concurrency
- **Tabla completa:** Todos los parámetros de pg_settings

### 3. 💾 PostgreSQL - Performance e I/O
**Monitoreo de disco y rendimiento**
- Bloques leídos: Disco vs Caché
- Tiempo de I/O (lectura/escritura en ms)
- Archivos temporales (count + bytes)
- Deadlocks totales
- Background Writer: Buffers limpiados
- WAL: Segmentos activos y tamaño total

### 4. 🔒 PostgreSQL - Queries y Locks
**Análisis de conexiones y bloqueos**
- Conexiones por estado (active, idle, idle in transaction)
- Duración máxima de transacciones activas
- Deadlocks histórico
- Estados de conexiones en tiempo real

### 5. 📋 PostgreSQL - Tablas e Índices
**Métricas a nivel de base de datos**
- Operaciones DML por segundo
- Lectura de tuplas (returned vs fetched)
- Cache Hit Ratio (gauge visual)
- Archivos temporales (alerta si > 0)
- Deadlocks

### 6. 🔄 PostgreSQL - Checkpoints
**Monitoreo de checkpoints (PostgreSQL 17)**
- Checkpoint Rate: Scheduled vs Requested
- Checkpoint Timing: Write Time & Sync Time
- Total Checkpoints: Scheduled y Requested
- Buffers Written by Checkpointer
- Checkpoint Efficiency (gauge: >90% = óptimo)

> **Checkpoint Efficiency:** Si está <50%, considera aumentar `checkpoint_timeout` o `max_wal_size`

> **Todos los dashboards usan métricas default del postgres_exporter** - No requieren custom queries.

---

## 📈 Métricas Disponibles

El proyecto expone **350+ métricas** vía postgres_exporter:

### Categorías Principales

| Categoría | Ejemplos | Cantidad |
|-----------|----------|----------|
| **Configuración** | `pg_settings_shared_buffers_bytes`, `pg_settings_max_connections` | 200+ |
| **Base de Datos** | `pg_stat_database_*` (blks_hit, xact_commit, tup_inserted) | 30+ |
| **Conexiones** | `pg_stat_activity_count`, `pg_stat_activity_max_tx_duration` | 10+ |
| **Cache/I/O** | `pg_stat_database_blks_hit`, `pg_stat_database_blks_read` | 15+ |
| **WAL** | `pg_wal_segments`, `pg_wal_size_bytes` | 5+ |
| **Checkpoints** | `pg_stat_bgwriter_*` | 10+ |
| **Replicación** | `pg_stat_replication_*` (si aplicable) | 20+ |
| **Sistema** | `pg_up`, `process_cpu_seconds_total`, `process_resident_memory_bytes` | 10+ |

**Ver catálogo completo:** [METRICAS-DISPONIBLES.md](METRICAS-DISPONIBLES.md)

### Ejemplos de Queries PromQL

```promql
# Cache Hit Ratio (%)
(sum(rate(pg_stat_database_blks_hit{datname="mydatabase"}[5m])) / 
(sum(rate(pg_stat_database_blks_hit{datname="mydatabase"}[5m])) + 
sum(rate(pg_stat_database_blks_read{datname="mydatabase"}[5m])))) * 100

# Conexiones activas
pg_stat_database_numbackends{datname="mydatabase"}

# Transacciones por segundo
rate(pg_stat_database_xact_commit{datname="mydatabase"}[1m]) + 
rate(pg_stat_database_xact_rollback{datname="mydatabase"}[1m])

# Shared Buffers configurado
pg_settings_shared_buffers_bytes{server="postgres:5432"}
```
---

## 🔧 Uso Avanzado

### 📝 Personalizar Configuración

#### Opción 1: Variables de Entorno

```powershell
# Copiar plantilla de ejemplo
Copy-Item templates\.env.example templates\.env

# Editar templates\.env con tus valores
POSTGRES_USER=myuser
POSTGRES_PASSWORD=SecurePass123!
POSTGRES_DB=mydatabase
POSTGRES_SHARED_BUFFERS=2GB
POSTGRES_MAX_CONNECTIONS=150

# Levantar con configuración personalizada
docker-compose -f templates/production.yml up -d
```

#### Opción 2: Archivos de Configuración (Production)

```powershell
# Editar archivos de configuración
notepad config\postgresql.conf
notepad config\pg_hba.conf

# Los cambios se aplicarán al reiniciar
docker-compose -f templates/production.yml restart postgres
```

### 🗄️ Scripts de Inicialización

```powershell
# 1. Copiar templates
Copy-Item init-scripts\01-init.sql.example init-scripts\01-init.sql

# 2. Editar con tus schemas/tablas
notepad init-scripts\01-init.sql

# 3. Los scripts se ejecutan al crear el contenedor
docker-compose -f templates/production.yml up -d
```

### 🔐 Seguridad en Producción

**⚠️ CHECKLIST ANTES DE PRODUCCIÓN:**

- [ ] Cambiar `POSTGRES_PASSWORD` por contraseña fuerte (16+ caracteres)
- [ ] Cambiar credenciales de Grafana (`GF_SECURITY_ADMIN_PASSWORD`)
- [ ] Revisar `pg_hba.conf` para restringir IPs permitidas
- [ ] Habilitar SSL/TLS en PostgreSQL
- [ ] No exponer puertos `5432`, `9090`, `3000` públicamente
- [ ] Configurar backups automáticos
- [ ] Configurar alertas en Grafana para métricas críticas
- [ ] Configurar retención de logs (`log_rotation_age`)

---

## 🛠️ Comandos Útiles

### Gestión de Contenedores

```powershell
# Ver estado de todos los servicios
docker-compose -f templates/production.yml ps

# Ver logs en tiempo real
docker-compose -f templates/production.yml logs -f

# Ver logs de un servicio específico
docker logs postgres_prod -f
docker logs prometheus_prod -f
docker logs grafana_prod -f

# Reiniciar servicios
docker-compose -f templates/production.yml restart

# Detener servicios (mantiene datos)
docker-compose -f templates/production.yml stop

# Eliminar servicios (⚠️ mantiene volúmenes)
docker-compose -f templates/production.yml down

# Eliminar TODO incluyendo datos (⚠️⚠️⚠️ DESTRUCTIVO)
docker-compose -f templates/production.yml down -v
```

### Gestión de PostgreSQL

```powershell
# Conectar a PostgreSQL desde CLI
docker exec -it postgres_prod psql -U myuser -d mydatabase

# Ejecutar query desde PowerShell
docker exec postgres_prod psql -U myuser -d mydatabase -c "SELECT version();"

# Ver configuración actual
docker exec postgres_prod psql -U myuser -d mydatabase -c "SHOW shared_buffers;"

# Backup completo
docker exec postgres_prod pg_dump -U myuser mydatabase > backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql

# Restaurar backup
Get-Content backup_20260113_143000.sql | docker exec -i postgres_prod psql -U myuser mydatabase

# Vacuuming manual
docker exec postgres_prod psql -U myuser -d mydatabase -c "VACUUM ANALYZE;"
```

### Monitoreo y Debugging

```powershell
# Ver métricas raw del exporter
Invoke-WebRequest http://localhost:9187/metrics

# Ver solo métricas de PostgreSQL
Invoke-WebRequest http://localhost:9187/metrics | Select-String "pg_"

# Verificar estado del exporter
Invoke-WebRequest http://localhost:9187/metrics | Select-String "pg_up"

# Ver targets en Prometheus
Start-Process http://localhost:9090/targets

# Verificar que Grafana esté conectado a Prometheus
Start-Process http://localhost:3000/datasources
```

### 🔄 Generador de Actividad para Testing

Para probar los dashboards con datos realistas, usa el generador de actividad:

```powershell
# Generar actividad durante 10 minutos
.\templates\activity-10min.ps1

# El script genera automáticamente:
# - 15 INSERTs cada 10 segundos
# - 5 UPDATEs cada 10 segundos
# - 3 DELETEs cada 10 segundos
# - Progreso mostrado en consola con estadísticas
```

**Características:**
- ✅ Crea tabla `pedidos` automáticamente si no existe
- ✅ Genera datos de prueba realistas (órdenes con totales)
- ✅ Muestra progreso en tiempo real
- ✅ Duración: 10 minutos (60 iteraciones × 10s)
- ✅ Ideal para validar dashboards de Tablas e Índices

**Resultados esperados:**
```
Iteración 60/60 completada
Total de inserts: ~900
Total de updates: ~300
Total de deletes: ~180
Tabla final: ~720 registros
```

**Ver actividad en Grafana:**
- Dashboard: **02 - PostgreSQL Tablas e Índices**
- Paneles: Sequential Scans, Inserts/s, Updates/s, Deletes/s
- Refresh: 10 segundos

---

## 🐛 Troubleshooting

### ❌ PostgreSQL no inicia

```powershell
# Ver logs del contenedor
docker logs postgres_prod

# Problemas comunes y soluciones:
```

**Problema:** `database system was not properly shut down`  
**Solución:** Reiniciar el contenedor: `docker restart postgres_prod`

**Problema:** `port 5432 is already allocated`  
**Solución:** Cambiar puerto en `.env`: `POSTGRES_PORT=5433`

**Problema:** `FATAL: password authentication failed`  
**Solución:** Verificar `POSTGRES_PASSWORD` en `.env` o recrear contenedor

**Problema:** `shared_buffers too large`  
**Solución:** Reducir `POSTGRES_SHARED_BUFFERS` o aumentar RAM del sistema

### ❌ Grafana muestra "No data"

**1. Verificar que Prometheus esté funcionando:**
```powershell
Invoke-WebRequest http://localhost:9090/-/healthy
# Debe responder: "Prometheus is Healthy."
```

**2. Verificar que postgres_exporter esté UP:**
```powershell
# Ir a http://localhost:9090/targets
# "postgres-exporter" debe estar State: UP
```

**3. Verificar métricas disponibles:**
```powershell
Invoke-WebRequest http://localhost:9187/metrics | Select-String "pg_up"
# Debe mostrar: pg_up 1
```

**4. Verificar datasource en Grafana:**
- Ir a: `Configuration → Data Sources → Prometheus`
- Click **"Test"** → Debe mostrar "Data source is working"

**5. Reiniciar Grafana:**
```powershell
docker-compose -f templates/production.yml restart grafana
```

### ❌ Métricas de configuración no aparecen

**Solución:** Verificar que `PG_EXPORTER_DISABLE_SETTINGS_METRICS=false`

```powershell
# Ver variables del exporter
docker exec postgres_exporter_prod env | Select-String "PG_EXPORTER"
```

---

## 📚 Documentación Adicional

- [QUICK-START.md](QUICK-START.md) - Guía rápida de inicio
- [STRUCTURE.md](STRUCTURE.md) - Documentación técnica detallada
- [METRICAS-DISPONIBLES.md](METRICAS-DISPONIBLES.md) - Catálogo de 350+ métricas
- [templates/README.md](templates/README.md) - Comparativa de plantillas
- [config/README.md](config/README.md) - Guía de configuración de PostgreSQL
- [grafana/README.md](grafana/README.md) - Guía de dashboards
- [init-scripts/README.md](init-scripts/README.md) - Scripts de inicialización

---

## 🤝 Contribuir

Mejoras y sugerencias son bienvenidas:

1. Fork del proyecto
2. Crear rama feature: `git checkout -b feature/mejora`
3. Commit cambios: `git commit -m 'Add: nueva funcionalidad'`
4. Push a la rama: `git push origin feature/mejora`
5. Abrir Pull Request

---

## 📄 Licencia

Este proyecto está bajo licencia MIT. Ver archivo [LICENCE](../LICENCE) para más detalles.

---

## 🙋 Soporte

- **Documentación:** Revisa los archivos `.md` en cada carpeta
- **Issues:** Reporta problemas en GitHub Issues
- **PostgreSQL Docs:** https://www.postgresql.org/docs/17/
- **Prometheus Docs:** https://prometheus.io/docs/
- **Grafana Docs:** https://grafana.com/docs/
GRAFANA_PORT=3001

# Solución 2: Detener otros contenedores
docker ps  # Ver qué usa el puerto
docker stop <container-id>
```

---

## 📚 Documentación Adicional

### En este proyecto:
- [QUICK-START.md](QUICK-START.md) - Guía rápida de inicio
- [STRUCTURE.md](STRUCTURE.md) - Documentación de estructura del proyecto
- [templates/README.md](templates/README.md) - Documentación completa de plantillas
- [grafana/README.md](grafana/README.md) - Guía de Grafana y dashboards
- [config/README.md](config/README.md) - Configuración avanzada de PostgreSQL
- [init-scripts/README.md](init-scripts/README.md) - Scripts de inicialización

### Recursos externos:
- **PostgreSQL:** https://www.postgresql.org/docs/
- **Docker Hub Postgres:** https://hub.docker.com/_/postgres
- **Prometheus:** https://prometheus.io/docs/
- **Grafana:** https://grafana.com/docs/
- **postgres_exporter:** https://github.com/prometheus-community/postgres_exporter
- **PGTune (calculadora):** https://pgtune.leopard.in.ua/

---

## 🎓 Conceptos Clave

### shared_buffers
Memoria dedicada al caché de PostgreSQL. **Regla:** 25% de RAM disponible (máx 40%).

### effective_cache_size
Estimación de memoria disponible para caché del SO + PostgreSQL. **Regla:** 50-75% de RAM total.

### work_mem
Memoria por operación de sort/hash. **Cuidado:** Multiplicado por conexiones activas.

### max_connections
Número máximo de conexiones simultáneas. **Trade-off:** Más conexiones = menos RAM por conexión.

### Cache Hit Ratio
Porcentaje de bloques leídos desde memoria vs disco. **Objetivo:** > 95%.

### Sequential Scans
Lecturas completas de tabla. **Alto valor** = probablemente faltan índices.

### Dead Tuples
Registros marcados para eliminar. **Alto valor** = necesita VACUUM.

---

## 📝 Changelog

### v2.0.0 - 2026-01-13
- ✨ Agregadas 4 plantillas pre-configuradas
- ✨ 6 dashboards de Grafana incluidos (+ Checkpoints para PG 17)
- ✨ 13 categorías de métricas custom
- ✨ Documentación completa reestructurada
- ✨ Soporte completo para variables de entorno
- ✨ Configuración organizada en carpetas (config/)
- 🔧 Reestructuración completa del proyecto
- 🗑️ Eliminados archivos duplicados

### v1.0.0 - Inicial
- ✅ PostgreSQL + Prometheus + Grafana básico

---

## 🎉 ¡Listo para Usar!

```bash
# Elige tu plantilla y ¡lanza!
docker-compose -f templates/development.yml up -d

# Accede a Grafana
# http://localhost:3000

# ¡Disfruta monitoreando PostgreSQL! 🚀
```

**¿Dudas?** Revisa [QUICK-START.md](QUICK-START.md) o la documentación en [templates/README.md](templates/README.md)
