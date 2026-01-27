# 📂 Estructura del Proyecto PostgreSQL 17.7

```
postgres/
│
├── 📄 README.md                          # Documentación principal completa
├── 📄 QUICK-START.md                     # Guía de inicio rápido (5 minutos)
├── 📄 STRUCTURE.md                       # Este archivo - Arquitectura del proyecto
├── 📄 .gitignore                         # Ignorar .env y datos locales
│
├── 📂 templates/                         # ⭐ PLANTILLAS DOCKER COMPOSE
│   ├── 📄 README.md                      # Documentación completa de plantillas
│   ├── 📄 .env.example                   # Ejemplo de variables de entorno
│   ├── 📄 development.yml                # Desarrollo local (128MB shared_buffers)
│   ├── 📄 production.yml                 # Producción (1GB shared_buffers + config files)
│   ├── 📄 testing.yml                    # CI/CD y testing (64MB shared_buffers, fsync off)
│   ├── 📄 analytics.yml                  # Data warehouse (1GB + 128MB work_mem)
│   └── 📄 activity-10min.ps1             # 🔄 Generador de actividad para testing
│
├── 📂 grafana/                           # Configuración de Grafana
│   ├── 📄 README.md                      # Guía de dashboards
│   └── 📂 provisioning/
│       ├── 📂 datasources/
│       │   └── prometheus-datasource.yml # Auto-configuración de Prometheus
│       └── 📂 dashboards/
│           ├── dashboard-provider.yml
│           ├── postgresql-overview.json           # Dashboard 1: Vista General
│           ├── postgresql-config.json             # Dashboard 2: Configuración
│           ├── postgresql-performance-io.json     # Dashboard 3: Performance e I/O
│           ├── postgresql-queries-locks.json      # Dashboard 4: Queries y Locks
│           ├── postgresql-tables-indexes.json     # Dashboard 5: Tablas e Índices
│           └── postgresql-checkpoints.json        # Dashboard 6: Checkpoints (PG 17)
│
├── 📂 config/                            # ⭐ CONFIGURACIÓN CENTRALIZADA
│   ├── 📄 README.md                      # Documentación de configuración
│   ├── 📂 prometheus/                    # Configs de Prometheus por entorno
│   ├── 📄 postgres-queries.yaml          # Custom queries para postgres_exporter (351 líneas)
│   ├── 📄 pg_hba.conf.example            # Ejemplo de control de acceso
│   ├── 📄 pg_hba.conf                    # Control de acceso (usado por production)
│   ├── 📄 postgresql.conf.example        # Ejemplo de configuración completa
│   └── 📄 postgresql.conf                # Configuración completa (usado por production)
│
├── 📂 init-scripts/                      # Scripts SQL de inicialización
│   ├── 📄 README.md                      # Guía de scripts de inicio
│   ├── 📄 00-create-exporter-user.sql    # Crear usuario para postgres_exporter
│   ├── 📄 01-init.sql.example            # Ejemplo: Crear esquemas y tablas
│   ├── 📄 02-functions.sql.example       # Ejemplo: Funciones y triggers
│   └── 📄 03-setup.sh.example            # Ejemplo: Script bash de setup
│
└── 📄 postgres-queries.yaml              # (Deprecated - movido a config/)
    📄 prometheus.yml                     # (Deprecated - movido a config/)

```

---

## 📖 Descripción de Archivos

### 📄 Archivos Raíz

#### README.md
Documentación principal del proyecto. Incluye:
- ✨ Características (PostgreSQL 17.7, 350+ métricas, 5 dashboards, 4 plantillas)
- 🚀 Quick Start con PowerShell
- 📊 Estructura del proyecto
- 🎨 Dashboards de Grafana con métricas detalladas
- 📈 Catálogo de métricas (350+ del exporter)
- 🔧 Uso avanzado y personalización
- 🔄 **Generador de actividad para testing** (activity-10min.ps1)
- 🐛 Troubleshooting completo
- 🔒 Checklist de seguridad

#### QUICK-START.md
Guía ultra-rápida para empezar en 5 minutos:
- 3 pasos para levantar el stack
- Credenciales por plantilla
- Comandos básicos de Docker
- Acceso a dashboards
- Troubleshooting rápido

#### STRUCTURE.md (este archivo)
Arquitectura técnica del proyecto:
- Estructura de directorios
- Descripción detallada de cada archivo
- Flujo de datos entre componentes
- Explicación de configuraciones

#### .gitignore
Previene commitear archivos sensibles:
- `.env` (credenciales)
- `templates/data/` (datos de contenedores)
- Logs temporales

---

### 📂 templates/ - Plantillas Docker Compose

#### README.md
Documentación completa de las 4 plantillas:
- Comparativa técnica (RAM, CPU, conexiones)
- Variables disponibles
- Casos de uso específicos
- Ejemplos de configuración
- Migración entre entornos

#### .env.example
Plantilla de variables de entorno con:
- Todas las variables disponibles documentadas
- Valores por defecto recomendados
- Configuración por entorno
- Cálculos de memoria

#### development.yml
**Configuración para desarrollo local:**
- **Recursos:** 128MB shared_buffers, 4MB work_mem, 20 max_connections
- **Logging:** Queries lentas > 1 segundo
- **Configuración:** Inline `-c` commands en Docker Compose
- **Queries:** postgres-queries-safe.yaml
- **Persistencia:** Volúmenes (postgres_dev_data, prometheus_dev_data, grafana_dev_data)
- Red: `dev_network`
- Contenedores: `postgres_dev`, `prometheus_dev`, `grafana_dev`


#### production.yml
**Configuración optimizada para producción:**
- **Recursos:** 1GB shared_buffers, 16MB work_mem, 100 max_connections
- **Configuración:** Archivos montados (`config/postgresql.conf` y `config/pg_hba.conf`)
- **Queries:** postgres-queries-safe.yaml
- **Persistencia:** Volúmenes (postgres_prod_data, prometheus_prod_data, grafana_prod_data)
- **Seguridad:** pg_hba.conf restrictivo, scram-sha-256
- **Red:** `prod_network`
- **Contenedores:** `postgres_prod`, `postgres_exporter_prod`, `prometheus_prod`, `grafana_prod`

#### testing.yml
**Configuración mínima para CI/CD:**
- **Recursos:** 64MB shared_buffers, 2MB work_mem, 10 max_connections
- **Optimización:** fsync=off (velocidad, ⚠️ solo testing)
- **Configuración:** Inline `-c` commands en Docker Compose
- **Queries:** postgres-queries-safe.yaml
- **Métricas:** Settings metrics habilitadas (PG_EXPORTER_DISABLE_SETTINGS_METRICS=false)
- **Persistencia:** tmpfs (sin persistencia entre reinicios)
- **Red:** `test_network`
- **Contenedores:** `postgres_test`, `postgres_exporter_test`, `prometheus_test`, `grafana_test`

#### analytics.yml
**Configuración para análisis de datos:**
- **Recursos:** 1GB shared_buffers, **128MB work_mem** (queries complejas), 50 max_connections
- **Optimización:** effective_cache_size=2GB, maintenance_work_mem=256MB
- **Configuración:** Inline `-c` commands en Docker Compose (12 parámetros)
- **Queries:** postgres-queries-safe.yaml
- **Persistencia:** Volúmenes (postgres_analytics_data, prometheus_analytics_data, grafana_analytics_data)
- **Red:** `analytics_network`
- **Contenedores:** `postgres_analytics`, `postgres_exporter_analytics`, `prometheus_analytics`, `grafana_analytics`

---

### 📂 grafana/ - Configuración de Grafana

#### README.md
Guía completa de Grafana:
- Acceso y credenciales
- Descripción detallada de los 5 dashboards
- Métricas utilizadas en cada dashboard
- Configuración de alertas
- Queries PromQL útiles
- Troubleshooting específico

#### provisioning/datasources/prometheus-datasource.yml
Auto-configura Prometheus como datasource en Grafana sin intervención manual. Configuración:
- URL: `http://prometheus:9090`
- Access: `proxy` (a través del servidor Grafana)
- Default: `true`

#### provisioning/dashboards/dashboard-provider.yml
Define dónde Grafana busca archivos JSON de dashboards:
- Carpeta: `/etc/grafana/provisioning/dashboards`
- Auto-importación al iniciar Grafana
- Actualización automática al modificar JSON

#### provisioning/dashboards/*.json
**5 dashboards pre-configurados (TODOS CORREGIDOS):**

1. **postgresql-overview.json** - Vista General
   - **Métricas:** pg_stat_database_numbackends, pg_stat_database_xact_commit/rollback
   - Cache hit ratio calculado con pg_stat_database_blks_hit/read
   - Tuplas procesadas: inserted/updated/deleted/returned/fetched
   - Deadlocks, temp files, max transaction duration

2. **postgresql-config.json** - Configuración del Servidor
   - **Métricas:** pg_settings_* (shared_buffers_bytes, work_mem_bytes, max_connections)
   - Tabla completa de configuraciones activas
   - Todos los parámetros visibles en panel de tabla

3. **postgresql-performance-io.json** - Performance e I/O
   - **Métricas:** pg_stat_database_blks_read/hit (disk vs cache)
   - WAL segments: pg_wal_segments, pg_wal_size_bytes
   - BGWriter: pg_stat_bgwriter_buffers_clean_total/alloc_total
   - Checkpoints: pg_stat_bgwriter_checkpoints_req/timed

4. **postgresql-queries-locks.json** - Estados de Conexiones
   - **Métricas:** pg_stat_activity_count (por estado: active, idle, idle in transaction)
   - Duración máxima: pg_stat_activity_max_tx_duration
   - Deadlocks: pg_stat_database_deadlocks

5. **postgresql-tables-indexes.json** - Operaciones sobre Tablas
   - **Métricas:** pg_stat_database_tup_inserted/updated/deleted
   - Tuplas leídas: pg_stat_database_tup_returned/fetched
   - Archivos temporales: pg_stat_database_temp_bytes/temp_files

6. **postgresql-checkpoints.json** - Estadísticas de Checkpoints (PostgreSQL 17)
   - **Métricas:** pg_checkpointer_checkpoints_scheduled/requested
   - Timing: pg_checkpointer_write_time_ms/sync_time_ms
   - Buffers: pg_checkpointer_buffers_written
   - Efficiency gauge: % de checkpoints scheduled vs requested

**🔑 Todos los dashboards usan:**
- Labels correctos: `server="postgres:5432"`, `datname="mydatabase"`
- Métricas por defecto del exporter (no custom queries)
- PromQL compatible con PostgreSQL 17


---

### 📂 config/ - Configuración Centralizada ⭐

#### README.md
Guía completa de configuración centralizada:
- **prometheus.yml:** Configuración genérica con variables de entorno
- **postgres-queries.yaml:** Custom queries para métricas avanzadas (351 líneas)
- **postgresql.conf / pg_hba.conf:** Configuración de PostgreSQL para production

#### prometheus.yml - GENÉRICO
Configuración de Prometheus que funciona con **todas las plantillas**:
- ✅ Usa variables de entorno: `${POSTGRES_INSTANCE}`, `${POSTGRES_DATABASE}`, `${ENVIRONMENT}`
- ✅ Scrape interval: 10 segundos para PostgreSQL, 30 segundos para Prometheus self-monitoring
- ✅ Las variables se definen en cada plantilla docker-compose

#### postgres-queries.yaml - CUSTOM METRICS  
**351 líneas de queries personalizadas compatibles con PostgreSQL 17:**

**13 Categorías incluidas:**
1. Database Statistics
2. Table & Index Statistics
3. Bloat Analysis
4. Locks & Blocking Queries
5. Replication Status
6. Cache Hit Ratios
7. WAL Statistics
8. Background Writer
9. **Checkpointer (PostgreSQL 17)** - Usa `pg_stat_checkpointer`
10. Autovacuum Progress
11. Connection Pooling
12. Query Performance
13. System Information

**🔑 Montado automáticamente en las 4 plantillas**

#### postgresql.conf + pg_hba.conf
Archivos de configuración avanzada de PostgreSQL:
- **postgresql.conf.example:** Configuración completa con parámetros optimizados
- **postgresql.conf:** Configuración activa (usado por production.yml)
- **pg_hba.conf.example:** Control de acceso y autenticación
- **pg_hba.conf:** Reglas de acceso activas (usado por production.yml)

**📌 Nota:** Solo `production.yml` monta postgresql.conf y pg_hba.conf. Las otras plantillas usan comandos inline `-c`.

---

### 📂 init-scripts/ - Scripts de Inicialización

#### README.md
Guía de scripts de inicialización:
- Orden de ejecución (alfabético: 00-*, 01-*, 02-*, 03-*)
- Tipos de scripts soportados (.sql, .sh, .sql.gz)
- Cómo se ejecutan automáticamente
- Variables disponibles (POSTGRES_USER, POSTGRES_DB, etc.)
- Troubleshooting de scripts fallidos

#### 00-create-exporter-user.sql
Script obligatorio que crea el usuario para postgres_exporter:
- Crea usuario `postgres_exporter` con permisos de solo lectura
- Necesario para que el exporter pueda conectarse y recolectar métricas

#### 01-init.sql.example
Ejemplo de script SQL para inicialización:
- Crear esquemas personalizados
- Crear tablas iniciales
- Crear índices básicos
- Poblar datos de prueba

#### 02-functions.sql.example
Ejemplo de script para objetos avanzados:
- Funciones PL/pgSQL
- Triggers
- Stored procedures
- Tipos personalizados

#### 03-setup.sh.example
Ejemplo de script bash para setup avanzado:
- Instalación de extensiones (pg_stat_statements, etc.)
- Configuración dinámica
- Tareas complejas de inicialización

**📌 Nota:** Para usar estos scripts, eliminar `.example` del nombre.

---

### 📄 activity-10min.ps1 - Generador de Actividad 🔄

**Script PowerShell para generar actividad de prueba en PostgreSQL**

**Ubicación:** `templates/activity-10min.ps1`

**Características:**
- ✅ Duración: 10 minutos (60 iteraciones × 10 segundos)
- ✅ Crea tabla `pedidos` automáticamente si no existe
- ✅ Genera **15 INSERTs + 5 UPDATEs + 3 DELETEs** cada 10 segundos
- ✅ Muestra progreso en tiempo real con estadísticas
- ✅ Datos realistas (pedidos con totales entre $100-$1000)

**Uso:**
```powershell
cd D:\DB-Motores\postgres\templates
.\activity-10min.ps1
```

**Resultados esperados después de 10 minutos:**
- Total inserts: ~900
- Total updates: ~300
- Total deletes: ~180
- Registros finales en tabla: ~720

**Ideal para validar:**
- Dashboard "05 - PostgreSQL Tablas e Índices"
- Paneles: Sequential Scans, Inserts/s, Updates/s, Deletes/s
- Métricas en tiempo real con refresh de 10 segundos en Grafana

---

### 📄 Archivos Deprecados (Reorganización v2.0)

Los siguientes archivos fueron **movidos a `config/`** para centralizar la configuración:

- ~~`postgres-queries-safe.yaml`~~ → **`config/postgres-queries.yaml`**
- ~~`prometheus.yml`~~ → **`config/prometheus.yml`**
- ~~`templates/prometheus-dev.yml`~~ → **`config/prometheus.yml`** (consolidado)

**Ventajas de la reorganización:**
- ✅ Un solo archivo prometheus.yml genérico con variables de entorno
- ✅ Todas las queries centralizadas en config/
- ✅ Más fácil de mantener y escalar
- ✅ Consistencia entre todas las plantillas

---

## 🎯 Flujo de Uso Típico

### 🛠️ Desarrollo Local
```powershell
1. Navegar: cd D:\DB-Motores\postgres
2. Levantar: docker-compose -f templates/development.yml up -d
3. Esperar 10-30 segundos
4. Acceder a Grafana: http://localhost:3000 (admin/admin)
5. Desarrollar y testear
6. Ver logs: docker logs postgres_dev -f
7. Detener: docker-compose -f templates/development.yml down
```

### 🚀 Producción
```powershell
1. Editar config/postgresql.conf (parámetros optimizados)
2. Editar config/pg_hba.conf (restricciones de IP)
3. Cambiar credenciales en docker-compose o .env
4. Levantar: docker-compose -f templates/production.yml up -d
5. Configurar backups automáticos (pg_dump + cron)
6. Configurar alertas en Grafana
7. Monitorear dashboards regularmente
8. Revisar logs: docker logs postgres_prod
```

### 🧪 CI/CD Testing
```powershell
1. En pipeline usar: templates/testing.yml
2. Levantar: docker-compose -f templates/testing.yml up -d
3. Esperar health check: docker ps
4. Ejecutar tests automatizados
5. Limpiar TODO: docker-compose -f templates/testing.yml down -v
```

### 📊 Analytics/BI
```powershell
1. Levantar: docker-compose -f templates/analytics.yml up -d
2. Configurar work_mem alto (ya en 128MB por defecto)
3. Instalar extensión pg_stat_statements (en init-scripts/)
4. Crear índices apropiados para queries analíticas
5. Monitorear "Queries y Locks" dashboard para queries lentas
6. Ajustar configuraciones según carga
```

---

## 🔗 Enlaces Entre Archivos

```
📄 README.md (documentación principal)
    ├─→ QUICK-START.md (inicio en 5 minutos)
    ├─→ STRUCTURE.md (este archivo - arquitectura)
    ├─→ METRICAS-DISPONIBLES.md (catálogo de 350+ métricas)
    ├─→ templates/README.md (comparativa de plantillas)
    ├─→ grafana/README.md (guía de dashboards)
    └─→ config/README.md (configuración avanzada)
    
📂 templates/
    ├─→ development.yml → postgres-queries-safe.yaml
    ├─→ production.yml → postgres-queries-safe.yaml + config/*.conf
    ├─→ testing.yml → postgres-queries-safe.yaml
    ├─→ analytics.yml → postgres-queries-safe.yaml
    └─→ .env.example (todas las variables disponibles)
    
📂 grafana/provisioning/
    ├─→ datasources/prometheus-datasource.yml (auto-config de Prometheus)
    └─→ dashboards/*.json (5 dashboards pre-configurados)
    
📂 config/ (solo para production.yml)
    ├─→ postgresql.conf.example → copiar a postgresql.conf
    └─→ pg_hba.conf.example → copiar a pg_hba.conf
    
📂 init-scripts/ (ejecutados en orden alfabético)
    ├─→ 00-create-exporter-user.sql (obligatorio)
    ├─→ 01-init.sql.example → renombrar sin .example
    ├─→ 02-functions.sql.example → renombrar sin .example
    └─→ 03-setup.sh.example → renombrar sin .example
```

---

## 📦 Dependencias Entre Servicios

```
🐘 PostgreSQL (puerto 5432)
    ↓ (depends_on: service_healthy con pg_isready)
📊 postgres_exporter (puerto 9187)
    ↓ (depends_on: service_started)
⏱️  Prometheus (puerto 9090)
    ↓ (depends_on: service_started)
📈 Grafana (puerto 3000)
```

**Health Checks:**
- PostgreSQL: `pg_isready -U myuser -d mydatabase` cada 10s
- Otros servicios: Inician automáticamente sin health check

---

## 📊 Flujo de Datos

```
1. PostgreSQL ejecuta queries y genera estadísticas
   ↓
2. postgres_exporter se conecta a PostgreSQL vía TCP:5432
   - Ejecuta queries de postgres-queries-safe.yaml
   - Expone métricas en formato Prometheus en :9187/metrics
   ↓
3. Prometheus scrape postgres_exporter cada 10 segundos
   - Almacena time-series en TSDB local
   - Expone datos vía API en :9090
   ↓
4. Grafana consulta Prometheus cada refresh del dashboard
   - Ejecuta queries PromQL
   - Renderiza gráficos y tablas
   - Usuario ve datos en navegador :3000
```

---

## 🎓 Guías de Aprendizaje

### 🌱 Principiantes (Nunca usaste Docker + PostgreSQL)
1. ✅ Leer [QUICK-START.md](QUICK-START.md)
2. ✅ Ejecutar `templates/development.yml`
3. ✅ Explorar dashboards en Grafana (http://localhost:3000)
4. ✅ Conectarse a PostgreSQL con psql o DBeaver
5. ✅ Hacer queries de prueba y ver métricas en tiempo real

### 🌿 Intermedios (Ya conoces Docker + PostgreSQL)
1. ✅ Leer [README.md](README.md) completo
2. ✅ Entender [templates/README.md](templates/README.md) (diferencias entre plantillas)
3. ✅ Revisar queries en `postgres-queries-safe.yaml`
4. ✅ Personalizar init-scripts para tu BD
5. ✅ Configurar alertas en Grafana
6. ✅ Probar diferentes plantillas según caso de uso

### 🌳 Avanzados (Vas a producción)
1. ✅ Estudiar [STRUCTURE.md](STRUCTURE.md) (este archivo)
2. ✅ Optimizar `config/postgresql.conf` para tu hardware
3. ✅ Configurar `config/pg_hba.conf` con IPs específicas
4. ✅ Implementar backups automáticos (pg_basebackup + pg_dump)
5. ✅ Configurar replicación (master-replica)
6. ✅ Configurar High Availability con Patroni/etcd
7. ✅ Monitoreo avanzado con custom queries
8. ✅ Integración con sistemas de alertas (PagerDuty, Slack)
9. ✅ Revisar [METRICAS-DISPONIBLES.md](METRICAS-DISPONIBLES.md) para optimizaciones

---

## ✅ Checklist de Refactorización Completada

**Archivos Eliminados:**
- ❌ `postgres-queries.yaml` (deprecated, reemplazado por postgres-queries-safe.yaml)
- ❌ `DASHBOARD-CONFIGURACION.md` (obsolete, info integrada en README.md)
- ❌ `SOLUCION-DASHBOARD.md` (obsolete, info integrada en README.md)
- ❌ `templates/data/` (container runtime data)

**Dashboards Corregidos (5 archivos):**
- ✅ `postgresql-overview.json` - Usa pg_stat_database_*, labels correctos
- ✅ `postgresql-config.json` - Usa pg_settings_*, tabla funcional
- ✅ `postgresql-performance-io.json` - Usa pg_wal_*, pg_stat_bgwriter_*
- ✅ `postgresql-queries-locks.json` - Usa pg_stat_activity_*, simplificado
- ✅ `postgresql-tables-indexes.json` - Usa pg_stat_database_tup_*

**Templates Corregidos (4 archivos):**
- ✅ `development.yml` - Inline `-c` commands, postgres-queries-safe.yaml
- ✅ `production.yml` - Mounted config files, postgres-queries-safe.yaml
- ✅ `testing.yml` - Inline `-c` commands, fsync=off, settings metrics enabled
- ✅ `analytics.yml` - Inline `-c` commands, 128MB work_mem, postgres-queries-safe.yaml

**Documentación Actualizada:**
- ✅ `README.md` - Refactorizado con información correcta
- ✅ `QUICK-START.md` - Actualizado con PowerShell y credenciales correctas
- ✅ `STRUCTURE.md` - Este archivo, completamente refactorizado

**Cambios Clave:**
- ✅ Todos los dashboards usan métricas por defecto del exporter (350+ métricas)
- ✅ Labels correctos: `server="postgres:5432"`, `datname="mydatabase"`
- ✅ Compatible con PostgreSQL 17.7 Alpine
- ✅ Configuración aplicada correctamente (inline `-c` o mounted files)
- ✅ Sin custom queries problemáticas
- ✅ Todas las plantillas usan postgres-queries-safe.yaml

---

## 📞 Soporte y Recursos

- **Documentación PostgreSQL 17:** https://www.postgresql.org/docs/17/
- **postgres_exporter:** https://github.com/prometheus-community/postgres_exporter
- **Prometheus:** https://prometheus.io/docs/
- **Grafana:** https://grafana.com/docs/
- **Docker Compose:** https://docs.docker.com/compose/

---

**🎉 Proyecto completamente refactorizado y funcional para PostgreSQL 17.7 Alpine**  
**Última actualización:** 2025-01-13

