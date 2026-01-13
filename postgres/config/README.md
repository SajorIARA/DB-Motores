# 🔧 Scripts y Configuraciones PostgreSQL

Esta carpeta contiene archivos de configuración personalizados para PostgreSQL.

## 📁 Archivos Disponibles

### `postgresql.conf.example`
Archivo de configuración principal de PostgreSQL con valores optimizados y comentarios detallados.

**Para usar:**
```bash
# 1. Copia el ejemplo
cp config/postgresql.conf.example config/postgresql.conf

# 2. Ajusta valores según tu servidor

# 3. Edita tu plantilla (ej: templates/production.yml) y monta el archivo:
volumes:
  - ./config/postgresql.conf:/etc/postgresql/postgresql.conf:ro

# 4. Modifica el comando para usar el archivo:
command: postgres -c config_file=/etc/postgresql/postgresql.conf
```

**Secciones incluidas:**
- Conexiones y autenticación
- Recursos de memoria
- Write-Ahead Log (WAL)
- Replicación
- Query planner
- Checkpoints
- Logging
- Autovacuum
- Monitoring

---

### `pg_hba.conf.example`
Archivo de control de acceso y autenticación de clientes.

**Para usar:**
```bash
# 1. Copia el ejemplo
cp config/pg_hba.conf.example config/pg_hba.conf

# 2. Ajusta reglas de acceso

# 3. Edita tu plantilla y monta el archivo:
volumes:
  - ./config/pg_hba.conf:/etc/postgresql/pg_hba.conf:ro
```

**Configuraciones incluidas:**
- Desarrollo (localhost)
- Producción (redes específicas)
- SSL/TLS
- Replicación
- Roles específicos

---

## 🎯 Casos de Uso

### Desarrollo Local
```bash
# Usa templates/development.yml
# Sin archivos personalizados - usa defaults
# Configuración mediante variables de entorno
docker-compose -f templates/development.yml up -d
```

### Producción Simple
```bash
# Usa templates/production.yml
# Configuración optimizada pre-definida en la plantilla
docker-compose -f templates/production.yml up -d
```

### Producción Avanzada
```bash
# Edita templates/production.yml para usar archivos personalizados:
# volumes:
#   - ./config/postgresql.conf:/etc/postgresql/postgresql.conf:ro
#   - ./config/pg_hba.conf:/etc/postgresql/pg_hba.conf:ro
# command: postgres -c config_file=/etc/postgresql/postgresql.conf

docker-compose -f templates/production.yml up -d
```

---

## 🔄 Recargar Configuración

Algunos cambios se pueden aplicar sin reiniciar:

```bash
# Recargar configuración (sin downtime)
# Usa el nombre del contenedor según tu plantilla:
# postgres_dev, postgres_prod, postgres_test, o postgres_analytics
docker exec postgres_dev psql -U postgres -c "SELECT pg_reload_conf();"

# Verificar parámetros actuales
docker exec postgres_dev psql -U postgres -c "SHOW shared_buffers;"
docker exec postgres_conection_test psql -U postgres -c "SHOW max_connections;"
```

**Requieren reinicio:**
- `shared_buffers`
- `max_connections`
- `wal_level`
- `max_wal_senders`

**No requieren reinicio:**
- `work_mem`
- `maintenance_work_mem`
- `effective_cache_size`
- `log_statement`
- La mayoría de parámetros de logging

---

## 🛠️ Herramientas de Configuración

### PGTune
Genera configuración optimizada según tu hardware:

🔗 https://pgtune.leopard.in.ua/

**Inputs:**
- Versión de PostgreSQL
- OS
- Tipo de aplicación (Web, OLTP, Data warehouse, Desktop, Mixed)
- RAM total
- CPUs
- Número de conexiones
- Tipo de disco (SSD/HDD)

**Output:** Valores optimizados para `postgresql.conf`

---

## 📚 Referencias

- [PostgreSQL Runtime Configuration](https://www.postgresql.org/docs/current/runtime-config.html)
- [Client Authentication (pg_hba.conf)](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html)
- [Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)
