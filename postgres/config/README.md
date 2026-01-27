# 🔧 Configuraciones PostgreSQL

Esta carpeta contiene todas las configuraciones centralizadas del proyecto, organizadas por tipo.

## 📁 Estructura

```
config/
├── prometheus/              # Configuraciones de Prometheus por entorno
│   ├── dev.yml             # → Development
│   ├── prod.yml            # → Production
│   ├── test.yml            # → Testing/CI
│   └── analytics.yml       # → Analytics/DW
├── postgresql/              # Configuraciones de PostgreSQL
│   ├── active/             # Configs en uso (production)
│   │   ├── postgresql.conf
│   │   └── pg_hba.conf
│   └── examples/           # Templates de ejemplo
│       ├── postgresql.conf.example
│       └── pg_hba.conf.example
├── queries/                 # Custom queries para postgres_exporter
│   └── postgres-queries.yaml
└── README.md               # Este archivo
```

---

## 📂 prometheus/ - Configuraciones por Entorno

Cada plantilla docker-compose usa su propio archivo de configuración de Prometheus con valores específicos.

### dev.yml
- **Entorno:** Development
- **Instance:** postgres-dev
- **Database:** dev_database
- **Uso:** `templates/development.yml`

### prod.yml
- **Entorno:** Production
- **Instance:** postgres-prod
- **Database:** mydatabase
- **Uso:** `templates/production.yml`

### test.yml
- **Entorno:** Testing/CI
- **Instance:** postgres-test
- **Database:** test_db
- **Uso:** `templates/testing.yml`

### analytics.yml
- **Entorno:** Analytics
- **Instance:** postgres-analytics
- **Database:** analytics_db
- **Uso:** `templates/analytics.yml`

**📌 Nota:** Los archivos tienen valores hardcodeados específicos para cada entorno. No usan variables de entorno porque Prometheus no las soporta en su archivo de configuración.

---

## 📂 queries/ - Custom Metrics

### postgres-queries.yaml (351 líneas)

Queries personalizadas para postgres_exporter compatibles con PostgreSQL 17.

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

**🔑 Montado automáticamente en las 4 plantillas:**
```yaml
postgres-exporter:
  environment:
    PG_EXPORTER_EXTEND_QUERY_PATH: "/etc/postgres-exporter/queries.yaml"
  volumes:
    - ../config/queries/postgres-queries.yaml:/etc/postgres-exporter/queries.yaml:ro
```

---

## 📂 postgresql/ - Configuración de PostgreSQL

### active/ - Configuraciones Activas

Archivos de configuración de PostgreSQL en uso por la plantilla `production.yml`.

#### postgresql.conf
Configuración principal de PostgreSQL con parámetros optimizados.

#### pg_hba.conf
Control de acceso y autenticación de clientes.

**Montaje en production.yml:**
```yaml
volumes:
  - ../config/postgresql/active/postgresql.conf:/etc/postgresql/postgresql.conf:ro
  - ../config/postgresql/active/pg_hba.conf:/etc/postgresql/pg_hba.conf:ro
command:
  - "postgres"
  - "-c"
  - "config_file=/etc/postgresql/postgresql.conf"
  - "-c"
  - "hba_file=/etc/postgresql/pg_hba.conf"
```

### examples/ - Templates de Ejemplo

Ejemplos de configuración que puedes copiar y personalizar.

**Para usar:**
```powershell
# Copiar ejemplo a activo
Copy-Item config/postgresql/examples/postgresql.conf.example config/postgresql/active/postgresql.conf
Copy-Item config/postgresql/examples/pg_hba.conf.example config/postgresql/active/pg_hba.conf

# Editar según necesidades
notepad config/postgresql/active/postgresql.conf
```

**📌 Nota:** Solo `production.yml` monta estos archivos. Las otras plantillas (`development`, `testing`, `analytics`) usan configuración inline via comandos `-c`.

---

## 🎯 Casos de Uso

### Desarrollo Local
```powershell
# Usa development con dev.yml
docker-compose -f templates/development.yml up -d
# Métricas con instance: postgres-dev, database: dev_database
```

### Testing/CI
```powershell
# Usa testing con test.yml
docker-compose -f templates/testing.yml up -d
# Métricas con instance: postgres-test, database: test_db
```

### Production Simple
```powershell
# Usa production con prod.yml
docker-compose -f templates/production.yml up -d
# Métricas con instance: postgres-prod, database: mydatabase
```

### Production Avanzada
```powershell
# 1. Personalizar configuración de PostgreSQL
Copy-Item config/postgresql/examples/*.example config/postgresql/active/

# 2. Editar archivos
notepad config/postgresql/active/postgresql.conf
notepad config/postgresql/active/pg_hba.conf

# 3. Levantar con configuración personalizada
docker-compose -f templates/production.yml up -d
```

### Analytics/Data Warehouse
```powershell
# Usa analytics con analytics.yml
docker-compose -f templates/analytics.yml up -d
# Métricas con instance: postgres-analytics, database: analytics_db
```

---

## 🔄 Recargar Configuración

Algunos cambios de PostgreSQL se pueden aplicar sin reiniciar:

```powershell
# Recargar configuración (sin downtime)
docker exec postgres_prod psql -U postgres -c "SELECT pg_reload_conf();"

# Verificar parámetro
docker exec postgres_prod psql -U postgres -c "SHOW shared_buffers;"
```

Para cambios que requieren reinicio:
```powershell
docker-compose -f templates/production.yml restart postgres
```
