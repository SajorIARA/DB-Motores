# 📂 Estructura del Proyecto

```
postgres/
│
├── 📄 README.md                          # Documentación principal del proyecto
├── 📄 QUICK-START.md                     # Guía de inicio rápido (5 minutos)
├── 📄 .gitignore                         # Ignorar .env y datos locales
│
├── 📂 templates/                         # ⭐ PLANTILLAS DOCKER COMPOSE
│   ├── 📄 README.md                      # Documentación completa de plantillas
│   ├── 📄 .env.example                   # Ejemplo de variables de entorno
│   ├── 📄 base.yml                       # Plantilla base (configuración actual)
│   ├── 📄 development.yml                # Desarrollo local (512MB-1GB RAM)
│   ├── 📄 production.yml                 # Producción (4GB-8GB RAM)
│   ├── 📄 testing.yml                    # CI/CD y testing (256MB-512MB RAM)
│   └── 📄 analytics.yml                  # Data warehouse (2GB-4GB RAM)
│
├── 📂 grafana/                           # Configuración de Grafana
│   ├── 📄 README.md                      # Guía de Grafana
│   └── 📂 provisioning/
│       ├── 📂 datasources/
│       │   └── prometheus.yml            # Auto-configuración de Prometheus
│       └── 📂 dashboards/
│           ├── dashboard-provider.yml
│           ├── postgresql-overview.json          # Dashboard: Vista General
│           ├── postgresql-config.json            # Dashboard: Configuración
│           ├── postgresql-queries-locks.json     # Dashboard: Queries y Locks
│           ├── postgresql-tables-indexes.json    # Dashboard: Tablas e Índices
│           └── postgresql-performance-io.json    # Dashboard: Performance e I/O
│
├── 📂 config/                            # Configuración avanzada de PostgreSQL
│   ├── 📄 README.md                      # Documentación de configuración
│   ├── pg_hba.conf.example               # Ejemplo de control de acceso
│   └── postgresql.conf.example           # Ejemplo de configuración completa
│
├── 📂 init-scripts/                      # Scripts SQL de inicialización
│   ├── 📄 README.md                      # Guía de scripts de inicio
│   ├── 01-init.sql.example               # Ejemplo: Crear esquemas y tablas
│   ├── 02-functions.sql.example          # Ejemplo: Funciones y triggers
│   └── 03-setup.sh.example               # Ejemplo: Script bash de setup
│
├── 📄 postgres-queries.yaml              # ⭐ Métricas custom (13 categorías)
├── 📄 prometheus.yml                     # Configuración de Prometheus
└── 📄 STRUCTURE.md                       # Este archivo

```

---

## 📖 Descripción de Archivos

### 📄 Archivos Raíz

#### README.md
Documentación principal del proyecto. Incluye:
- Inicio rápido
- Comparativa de plantillas
- Dashboards incluidos
- Personalización
- Troubleshooting
- Enlaces a recursos

#### QUICK-START.md
Guía ultra-rápida para empezar en 5 minutos sin leer mucha documentación.

#### .gitignore
Previene commitear archivos sensibles:
- `.env` (credenciales)
- Datos de volúmenes locales
- Logs temporales

---

### 📂 templates/ - Plantillas Docker Compose

#### README.md
Documentación completa de las 4 plantillas:
- Comparativa técnica
- Variables disponibles
- Casos de uso
- Ejemplos de uso
- Migración entre entornos

#### .env.example
Plantilla de variables de entorno con:
- Todas las variables disponibles documentadas
- Valores por defecto
- Recomendaciones por entorno
- Cálculos de RAM

#### base.yml
La plantilla Docker Compose actual/original. Sirve como referencia del setup que estás usando actualmente.

#### development.yml
**Configuración ligera para desarrollo:**
- 128MB shared_buffers
- 20 conexiones máximas
- Logging completo
- Reinicio automático
- Red: `dev_network`
- Contenedores: `postgres_dev`, `prometheus_dev`, `grafana_dev`

#### production.yml
**Configuración optimizada para producción:**
- 2GB shared_buffers
- 200 conexiones máximas
- Optimizado para SSD
- Seguridad reforzada
- Límites de recursos
- Red: `prod_network`
- Contenedores: `postgres_prod`, `prometheus_prod`, `grafana_prod`

#### testing.yml
**Configuración mínima para CI/CD:**
- 64MB shared_buffers
- 10 conexiones máximas
- Sin persistencia (tmpfs)
- FSYNC OFF (velocidad)
- Sin reinicio automático
- Red: `test_network`
- Contenedores: `postgres_test`, `prometheus_test`, `grafana_test`

#### analytics.yml
**Configuración para análisis de datos:**
- 1GB shared_buffers
- 128MB work_mem (alto para queries complejas)
- Paralelización habilitada (8 workers)
- Statistics target alto (500)
- Sin timeout de queries
- Red: `analytics_network`
- Contenedores: `postgres_analytics`, `prometheus_analytics`, `grafana_analytics`

---

### 📂 grafana/ - Configuración de Grafana

#### README.md
Guía completa de Grafana:
- Acceso y credenciales
- Descripción de dashboards
- Dashboards recomendados de la comunidad
- Configuración de alertas
- Queries PromQL útiles
- Troubleshooting

#### provisioning/datasources/prometheus-datasource.yml
Auto-configura Prometheus como datasource en Grafana sin intervención manual.

#### provisioning/dashboards/dashboard-provider.yml
Define dónde Grafana busca archivos JSON de dashboards.

#### provisioning/dashboards/*.json
5 dashboards pre-configurados:

1. **postgresql-overview.json** - Vista General
   - Estado del servidor
   - Conexiones activas
   - Cache hit ratio
   - Transacciones por segundo
   - Operaciones DML

2. **postgresql-config.json** - Configuración
   - Parámetros de memoria
   - Configuración de conexiones
   - Tabla completa de pg_settings

3. **postgresql-queries-locks.json** - Queries y Locks
   - Locks por tipo y modo
   - Queries lentas (> 5 seg)
   - Wait events
   - Duración de queries

4. **postgresql-tables-indexes.json** - Tablas e Índices
   - Sequential scans (necesitan índices)
   - Tuplas muertas (necesitan VACUUM)
   - Uso de índices
   - Tamaños de tablas

5. **postgresql-performance-io.json** - Performance e I/O
   - I/O disco vs caché
   - Checkpoints
   - WAL statistics
   - Background writer

---

### 📂 config/ - Configuración Avanzada de PostgreSQL

#### README.md
Guía de configuración avanzada:
- Cómo personalizar postgresql.conf
- Control de acceso con pg_hba.conf
- Optimización por tipo de carga
- Seguridad

#### pg_hba.conf.example
Ejemplo de configuración de control de acceso:
- Métodos de autenticación
- Restricciones por IP
- SSL/TLS

#### postgresql.conf.example
Ejemplo de configuración completa de PostgreSQL con todos los parámetros comentados y explicados.

---

### 📂 init-scripts/ - Scripts de Inicialización

#### README.md
Guía de scripts de inicialización:
- Orden de ejecución
- Tipos de scripts soportados (.sql, .sh)
- Ejemplos de uso
- Troubleshooting

#### 01-init.sql.example
Ejemplo de script SQL para crear:
- Esquemas
- Tablas
- Índices iniciales

#### 02-functions.sql.example
Ejemplo de script para:
- Funciones
- Triggers
- Stored procedures

#### 03-setup.sh.example
Ejemplo de script bash para:
- Configuración dinámica
- Instalación de extensiones
- Tareas de setup complejas

---

### 📄 Archivos de Configuración

#### postgres-queries.yaml
**13 categorías de métricas custom para postgres_exporter:**

1. `pg_settings` - Configuración de PostgreSQL
2. `pg_database_stats` - Estadísticas por BD
3. `pg_active_queries` - Queries activas
4. `pg_table_stats` - Estadísticas de tablas
5. `pg_index_stats` - Uso de índices
6. `pg_locks_detail` - Locks y bloqueos
7. `pg_database_sizes` - Tamaños de BDs
8. `pg_table_sizes` - Tamaños de tablas
9. `pg_replication_status` - Estado de réplicas
10. `pg_wal_stats` - WAL statistics
11. `pg_bgwriter` - Background writer
12. `pg_slow_queries` - Queries lentas
13. `pg_vacuum_progress` - Progreso de VACUUM

#### prometheus.yml
Configuración de Prometheus:
- Targets de scraping (postgres-exporter, prometheus)
- Intervalos de scraping
- Relabel configs
- Global settings

---

## 🎯 Flujo de Uso Típico

### Desarrollo Local
```bash
1. Elegir plantilla: templates/development.yml
2. Opcional: Personalizar con .env
3. Levantar: docker-compose up -d
4. Acceder a Grafana: http://localhost:3000
5. Desarrollar y testear
6. Detener: docker-compose down
```

### Producción
```bash
1. Copiar .env.example a .env
2. Configurar credenciales fuertes
3. Ajustar parámetros de RAM
4. Levantar: docker-compose -f templates/production.yml --env-file .env up -d
5. Configurar backups
6. Configurar alertas en Grafana
7. Monitorear dashboards
```

### CI/CD
```bash
1. En pipeline usar templates/testing.yml
2. Levantar con docker-compose up -d
3. Esperar a que esté healthy
4. Ejecutar tests
5. Limpiar con docker-compose down -v
```

### Analytics
```bash
1. Usar templates/analytics.yml
2. Configurar work_mem alto si queries muy grandes
3. Habilitar extensiones (pg_stat_statements)
4. Crear índices apropiados
5. Monitorear queries lentas en Grafana
```

---

## 🔗 Enlaces Entre Archivos

```
README.md (principal)
    ├─→ QUICK-START.md (inicio rápido)
    ├─→ templates/README.md (plantillas detalladas)
    ├─→ grafana/README.md (dashboards)
    └─→ Archivos de configuración
    
templates/README.md
    ├─→ .env.example (variables)
    ├─→ *.yml (4 plantillas)
    └─→ ../postgres-queries.yaml (métricas)
    
grafana/README.md
    ├─→ provisioning/datasources/ (Prometheus)
    ├─→ provisioning/dashboards/ (5 dashboards)
    └─→ Dashboards públicos recomendados
    
config/README.md
    ├─→ pg_hba.conf.example
    └─→ postgresql.conf.example
    
init-scripts/README.md
    ├─→ *.sql.example (scripts SQL)
    └─→ *.sh.example (scripts bash)
```

---

## 📦 Dependencias Entre Servicios

```
PostgreSQL (puerto 5432)
    ↓ (depends_on: service_healthy)
postgres-exporter (puerto 9187)
    ↓ (depends_on)
Prometheus (puerto 9090)
    ↓ (depends_on)
Grafana (puerto 3000)
```

---

## 🎓 Para Aprender

**Principiantes:**
1. Leer QUICK-START.md
2. Probar templates/development.yml
3. Explorar dashboards en Grafana

**Intermedios:**
1. Leer README.md completo
2. Entender templates/README.md
3. Personalizar con .env
4. Explorar postgres-queries.yaml

**Avanzados:**
1. Estudiar todas las plantillas
2. Customizar postgresql.conf
3. Crear métricas custom en postgres-queries.yaml
4. Crear dashboards propios
5. Configurar alertas

---

**Documentación completa y actualizada**  
**Última actualización:** 2026-01-12

