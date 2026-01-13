# 📦 PLANTILLAS DE POSTGRESQL + MONITOREO

Esta carpeta contiene **4 plantillas pre-configuradas** de Docker Compose con PostgreSQL + Prometheus + Grafana, optimizadas para diferentes escenarios de uso.

---

## 🎯 Plantillas Disponibles

| Plantilla | Caso de Uso | Configuración | RAM Recomendada |
|-----------|-------------|---------------|-----------------|
| `development.yml` | Desarrollo local, testing rápido | Ligera, sin persistencia crítica | 512MB - 1GB |
| `production.yml` | Producción, alta carga | Optimizada para performance | 4GB - 8GB+ |
| `testing.yml` | CI/CD, tests automatizados | Temporal, mínima persistencia | 256MB - 512MB |
| `analytics.yml` | Data warehouse, reportes | Optimizada para lecturas complejas | 2GB - 4GB |

---

## 🚀 Uso Rápido

### 1️⃣ Elegir Plantilla

```bash
# Desarrollo
docker-compose -f templates/development.yml up -d

# Producción
docker-compose -f templates/production.yml up -d

# Testing
docker-compose -f templates/testing.yml up -d

# Analytics
docker-compose -f templates/analytics.yml up -d
```

### 2️⃣ Personalizar Variables

Crea un archivo `.env` en la raíz del proyecto:

```bash
# .env
POSTGRES_USER=miusuario
POSTGRES_PASSWORD=mipassword123
POSTGRES_DB=mibasedatos
POSTGRES_PORT=5432
GRAFANA_PORT=3000
PROMETHEUS_PORT=9090
```

### 3️⃣ Usar Variables en Plantilla

```bash
docker-compose -f templates/production.yml --env-file .env up -d
```

---

## 📋 Comparativa de Configuraciones

### 🔧 Parámetros de PostgreSQL por Plantilla

| Parámetro | Development | Production | Testing | Analytics |
|-----------|-------------|------------|---------|-----------|
| **shared_buffers** | 128MB | 2GB | 64MB | 1GB |
| **effective_cache_size** | 512MB | 6GB | 256MB | 3GB |
| **work_mem** | 4MB | 64MB | 2MB | 128MB |
| **maintenance_work_mem** | 64MB | 512MB | 32MB | 256MB |
| **max_connections** | 20 | 200 | 10 | 50 |
| **checkpoint_timeout** | 5min | 15min | 3min | 10min |
| **max_wal_size** | 512MB | 4GB | 256MB | 2GB |
| **random_page_cost** | 4.0 | 1.1 (SSD) | 4.0 | 1.1 (SSD) |

### 🌐 Configuración de Redes

Cada plantilla usa una red diferente para evitar conflictos:

- **development.yml**: red `dev_network`
- **production.yml**: red `prod_network`
- **testing.yml**: red `test_network`
- **analytics.yml**: red `analytics_network`

### 📦 Nombres de Contenedores

Cada plantilla usa nombres únicos:

- **development.yml**: `postgres_dev`, `prometheus_dev`, `grafana_dev`
- **production.yml**: `postgres_prod`, `prometheus_prod`, `grafana_prod`
- **testing.yml**: `postgres_test`, `prometheus_test`, `grafana_test`
- **analytics.yml**: `postgres_analytics`, `prometheus_analytics`, `grafana_analytics`

---

## 🔐 Variables de Entorno Disponibles

### PostgreSQL

| Variable | Descripción | Default | Requerida |
|----------|-------------|---------|-----------|
| `POSTGRES_USER` | Usuario de la base de datos | `postgres` | ❌ |
| `POSTGRES_PASSWORD` | Contraseña del usuario | - | ✅ |
| `POSTGRES_DB` | Nombre de la base de datos | `postgres` | ❌ |
| `POSTGRES_PORT` | Puerto de PostgreSQL | `5432` | ❌ |
| `POSTGRES_INITDB_ARGS` | Argumentos de inicialización | - | ❌ |
| `POSTGRES_INITDB_WALDIR` | Directorio WAL separado | - | ❌ |
| `POSTGRES_HOST_AUTH_METHOD` | Método de autenticación | `scram-sha-256` | ❌ |

### Configuración de Performance (Development)

```yaml
POSTGRES_SHARED_BUFFERS: "128MB"
POSTGRES_EFFECTIVE_CACHE_SIZE: "512MB"
POSTGRES_WORK_MEM: "4MB"
POSTGRES_MAINTENANCE_WORK_MEM: "64MB"
POSTGRES_MAX_CONNECTIONS: "20"
```

### Configuración de Performance (Production)

```yaml
POSTGRES_SHARED_BUFFERS: "2GB"
POSTGRES_EFFECTIVE_CACHE_SIZE: "6GB"
POSTGRES_WORK_MEM: "64MB"
POSTGRES_MAINTENANCE_WORK_MEM: "512MB"
POSTGRES_MAX_CONNECTIONS: "200"
POSTGRES_CHECKPOINT_TIMEOUT: "15min"
POSTGRES_MAX_WAL_SIZE: "4GB"
POSTGRES_RANDOM_PAGE_COST: "1.1"  # Para SSD
POSTGRES_EFFECTIVE_IO_CONCURRENCY: "200"  # Para SSD
```

### Configuración de Performance (Testing)

```yaml
POSTGRES_SHARED_BUFFERS: "64MB"
POSTGRES_EFFECTIVE_CACHE_SIZE: "256MB"
POSTGRES_WORK_MEM: "2MB"
POSTGRES_MAX_CONNECTIONS: "10"
POSTGRES_FSYNC: "off"  # ⚠️ Solo para testing, NO usar en producción
```

### Configuración de Performance (Analytics)

```yaml
POSTGRES_SHARED_BUFFERS: "1GB"
POSTGRES_EFFECTIVE_CACHE_SIZE: "3GB"
POSTGRES_WORK_MEM: "128MB"  # Alto para queries complejas
POSTGRES_MAINTENANCE_WORK_MEM: "256MB"
POSTGRES_MAX_CONNECTIONS: "50"
POSTGRES_RANDOM_PAGE_COST: "1.1"
POSTGRES_EFFECTIVE_IO_CONCURRENCY: "200"
POSTGRES_DEFAULT_STATISTICS_TARGET: "500"  # Mejor optimización de queries
```

### Grafana

| Variable | Descripción | Default |
|----------|-------------|---------|
| `GF_SECURITY_ADMIN_USER` | Usuario admin | `admin` |
| `GF_SECURITY_ADMIN_PASSWORD` | Password admin | `admin123` |
| `GF_SERVER_HTTP_PORT` | Puerto HTTP | `3000` |
| `GF_USERS_ALLOW_SIGN_UP` | Permitir registro | `false` |

### Prometheus

| Variable | Descripción | Default |
|----------|-------------|---------|
| `PROMETHEUS_PORT` | Puerto HTTP | `9090` |
| `PROMETHEUS_RETENTION_TIME` | Retención de datos | `15d` |
| `PROMETHEUS_RETENTION_SIZE` | Tamaño máximo | `10GB` |

---

## 📝 Ejemplos de Uso

### Ejemplo 1: Desarrollo Local con Variables Personalizadas

```bash
# Crear .env
cat > .env << EOF
POSTGRES_USER=developer
POSTGRES_PASSWORD=dev123
POSTGRES_DB=myapp_dev
POSTGRES_PORT=5433
GRAFANA_PORT=3001
EOF

# Levantar
docker-compose -f templates/development.yml --env-file .env up -d
```

### Ejemplo 2: Producción con Configuración Avanzada

```bash
# .env
POSTGRES_USER=app_prod
POSTGRES_PASSWORD=SecurePass123!
POSTGRES_DB=production_db
POSTGRES_SHARED_BUFFERS=4GB
POSTGRES_EFFECTIVE_CACHE_SIZE=12GB
POSTGRES_WORK_MEM=128MB
POSTGRES_MAX_CONNECTIONS=500

docker-compose -f templates/production.yml --env-file .env up -d
```

### Ejemplo 3: Testing en CI/CD

```bash
# Sin persistencia, reinicio rápido
docker-compose -f templates/testing.yml up -d
# Ejecutar tests
npm test
# Limpiar
docker-compose -f templates/testing.yml down -v
```

### Ejemplo 4: Analytics para Data Warehouse

```bash
# .env
POSTGRES_USER=analyst
POSTGRES_PASSWORD=Analytics2024!
POSTGRES_DB=datawarehouse
POSTGRES_WORK_MEM=256MB  # Queries muy grandes
POSTGRES_MAINTENANCE_WORK_MEM=1GB

docker-compose -f templates/analytics.yml --env-file .env up -d
```

---

## 🔄 Migrar Entre Plantillas

### De Development a Production

1. **Hacer backup:**
   ```bash
   docker exec postgres_dev pg_dump -U myuser mydb > backup.sql
   ```

2. **Levantar producción:**
   ```bash
   docker-compose -f templates/production.yml up -d
   ```

3. **Restaurar:**
   ```bash
   docker exec -i postgres_prod psql -U myuser mydb < backup.sql
   ```

---

## 🎛️ Personalización Avanzada

### Crear Tu Propia Plantilla

1. **Copiar plantilla base:**
   ```bash
   cp templates/development.yml templates/custom.yml
   ```

2. **Modificar configuración:**
   - Cambiar nombres de contenedores
   - Ajustar parámetros de PostgreSQL
   - Modificar redes y volúmenes

3. **Probar:**
   ```bash
   docker-compose -f templates/custom.yml config  # Validar
   docker-compose -f templates/custom.yml up -d   # Ejecutar
   ```

### Agregar Scripts de Inicialización

Todas las plantillas soportan scripts SQL de inicialización:

```yaml
volumes:
  - ../init-scripts/01-schema.sql:/docker-entrypoint-initdb.d/01-schema.sql
  - ../init-scripts/02-data.sql:/docker-entrypoint-initdb.d/02-data.sql
```

---

## 🛡️ Seguridad

### Recomendaciones por Entorno

#### Development ✅
- ✅ Contraseñas simples OK
- ✅ Puerto expuesto a localhost
- ✅ Sin SSL

#### Production 🔒
- ⚠️ **SIEMPRE** usa contraseñas fuertes
- ⚠️ Configura SSL/TLS
- ⚠️ No expongas puertos públicamente
- ⚠️ Usa secrets de Docker o variables cifradas
- ⚠️ Habilita pg_hba.conf restrictivo

```yaml
environment:
  POSTGRES_HOST_AUTH_METHOD: scram-sha-256
  POSTGRES_INITDB_ARGS: "--auth-host=scram-sha-256"
volumes:
  - ./config/pg_hba.conf:/var/lib/postgresql/data/pg_hba.conf
```

---

## 📊 Dashboards de Grafana

Todas las plantillas incluyen automáticamente estos dashboards:

1. **PostgreSQL - Vista General**
2. **PostgreSQL - Configuración**
3. **PostgreSQL - Queries y Locks**
4. **PostgreSQL - Tablas e Índices**
5. **PostgreSQL - Performance e I/O**

Accede en: `http://localhost:3000` (o el puerto configurado)

---

## 🐛 Troubleshooting

### Conflicto de Puertos

```bash
# Error: port is already allocated
# Solución: Cambiar puertos en .env
POSTGRES_PORT=5433
GRAFANA_PORT=3001
PROMETHEUS_PORT=9091
```

### Conflicto de Nombres de Contenedores

```bash
# Error: container name already in use
# Solución: Detener otros contenedores
docker-compose -f templates/development.yml down
docker-compose -f templates/production.yml up -d
```

### Falta de Memoria

```bash
# Error: cannot allocate memory
# Solución: Reducir shared_buffers
POSTGRES_SHARED_BUFFERS=256MB
```

---

## 📚 Recursos Adicionales

- **Documentación PostgreSQL:** https://www.postgresql.org/docs/
- **Guía de Tuning:** https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server
- **PGTune (calculadora):** https://pgtune.leopard.in.ua/
- **Prometheus:** https://prometheus.io/docs/
- **Grafana:** https://grafana.com/docs/

---

## ✅ Checklist Pre-Producción

- [ ] Contraseñas fuertes configuradas
- [ ] Backup automático configurado
- [ ] Monitoreo de alertas activado
- [ ] SSL/TLS habilitado
- [ ] Volúmenes con persistencia
- [ ] Health checks configurados
- [ ] Logs centralizados
- [ ] Documentación del esquema
- [ ] Plan de recuperación ante desastres
- [ ] Testing de carga realizado

---

**¡Listo para desplegar PostgreSQL en cualquier entorno! 🚀**
