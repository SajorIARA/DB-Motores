# 📦 PLANTILLAS DE MYSQL + MONITOREO

Esta carpeta contiene **4 plantillas pre-configuradas** de Docker Compose con MySQL + Prometheus + Grafana, optimizadas para diferentes escenarios de uso.

---

## 🎯 Plantillas Disponibles

| Plantilla | Caso de Uso | Configuración | RAM Recomendada |
|-----------|-------------|---------------|-----------------|
| `development.yml` | Desarrollo local, testing rápido | Ligera, logging completo | 512MB - 1GB |
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
MYSQL_ROOT_PASSWORD=MiRootPassword123!
MYSQL_USER=miusuario
MYSQL_PASSWORD=mipassword123
MYSQL_DATABASE=mibasedatos
MYSQL_PORT=3306
GRAFANA_PORT=3000
PROMETHEUS_PORT=9090
```

### 3️⃣ Usar Variables en Plantilla

```bash
docker-compose -f templates/production.yml --env-file .env up -d
```

---

## 📋 Comparativa de Configuraciones

### 🔧 Parámetros de MySQL por Plantilla

| Parámetro | Development | Production | Testing | Analytics |
|-----------|-------------|------------|---------|-----------|
| **innodb_buffer_pool_size** | 128MB | 2GB | 64MB | 1GB |
| **max_connections** | 50 | 500 | 20 | 100 |
| **innodb_log_file_size** | 48MB | 512MB | 24MB | 256MB |
| **innodb_log_buffer_size** | 8MB | 64MB | 4MB | 32MB |
| **sort_buffer_size** | 2MB | 4MB | 1MB | 8MB |
| **read_buffer_size** | 1MB | 2MB | 512KB | 4MB |
| **join_buffer_size** | 2MB | 4MB | 1MB | 8MB |
| **tmp_table_size** | 16MB | 64MB | 8MB | 256MB |
| **innodb_io_capacity** | 200 | 2000 | 200 | 1000 |
| **query_cache_size** | 16MB | 0 (OFF) | 0 (OFF) | 0 (OFF) |

### 🌐 Configuración de Redes

Cada plantilla usa una red diferente para evitar conflictos:

- **development.yml**: red `mysql_dev_network`
- **production.yml**: red `mysql_prod_network`
- **testing.yml**: red `mysql_test_network`
- **analytics.yml**: red `mysql_analytics_network`

### 📦 Nombres de Contenedores

Cada plantilla usa nombres únicos:

- **development.yml**: `mysql_dev`, `mysqld_exporter_dev`, `prometheus_mysql_dev`, `grafana_mysql_dev`
- **production.yml**: `mysql_prod`, `mysqld_exporter_prod`, `prometheus_mysql_prod`, `grafana_mysql_prod`
- **testing.yml**: `mysql_test`, `mysqld_exporter_test`, `prometheus_mysql_test`, `grafana_mysql_test`
- **analytics.yml**: `mysql_analytics`, `mysqld_exporter_analytics`, `prometheus_mysql_analytics`, `grafana_mysql_analytics`

---

## 🔐 Variables de Entorno Disponibles

### MySQL

| Variable | Descripción | Default | Requerida |
|----------|-------------|---------|-----------|
| `MYSQL_ROOT_PASSWORD` | Contraseña del usuario root | - | ✅ |
| `MYSQL_USER` | Usuario de aplicación | - | ❌ |
| `MYSQL_PASSWORD` | Contraseña del usuario | - | ❌ (si MYSQL_USER) |
| `MYSQL_DATABASE` | Base de datos inicial | - | ❌ |
| `MYSQL_PORT` | Puerto de MySQL | `3306` | ❌ |

### Configuración de Performance

#### Development
```yaml
MYSQL_INNODB_BUFFER_POOL_SIZE: "128M"
MYSQL_MAX_CONNECTIONS: "50"
MYSQL_INNODB_LOG_FILE_SIZE: "48M"
MYSQL_QUERY_CACHE_SIZE: "16M"
MYSQL_GENERAL_LOG: "1"
MYSQL_SLOW_QUERY_LOG: "1"
MYSQL_LONG_QUERY_TIME: "2"
```

#### Production
```yaml
MYSQL_INNODB_BUFFER_POOL_SIZE: "2G"
MYSQL_INNODB_BUFFER_POOL_INSTANCES: "8"
MYSQL_MAX_CONNECTIONS: "500"
MYSQL_INNODB_LOG_FILE_SIZE: "512M"
MYSQL_INNODB_LOG_BUFFER_SIZE: "64M"
MYSQL_INNODB_FLUSH_METHOD: "O_DIRECT"
MYSQL_INNODB_IO_CAPACITY: "2000"
MYSQL_INNODB_IO_CAPACITY_MAX: "4000"
MYSQL_QUERY_CACHE_SIZE: "0"  # Query cache deshabilitado (mejor performance en MySQL 8.0)
```

#### Testing
```yaml
MYSQL_INNODB_BUFFER_POOL_SIZE: "64M"
MYSQL_MAX_CONNECTIONS: "20"
MYSQL_INNODB_FLUSH_LOG_AT_TRX_COMMIT: "0"  # ⚠️ NO usar en producción
MYSQL_INNODB_DOUBLEWRITE: "0"  # ⚠️ NO usar en producción
MYSQL_SYNC_BINLOG: "0"  # ⚠️ NO usar en producción
```

#### Analytics
```yaml
MYSQL_INNODB_BUFFER_POOL_SIZE: "1G"
MYSQL_MAX_CONNECTIONS: "100"
MYSQL_SORT_BUFFER_SIZE: "8M"  # Alto para queries complejos
MYSQL_READ_BUFFER_SIZE: "4M"
MYSQL_JOIN_BUFFER_SIZE: "8M"
MYSQL_TMP_TABLE_SIZE: "256M"  # Tablas temporales grandes
MYSQL_MAX_EXECUTION_TIME: "300000"  # 5 minutos timeout
```

### Grafana

| Variable | Descripción | Default |
|----------|-------------|---------|
| `GF_ADMIN_USER` | Usuario admin de Grafana | `admin` |
| `GF_ADMIN_PASSWORD` | Password admin | (ver plantilla) |
| `GRAFANA_PORT` | Puerto de Grafana | `3000` |

### Prometheus

| Variable | Descripción | Default |
|----------|-------------|---------|
| `PROMETHEUS_PORT` | Puerto de Prometheus | `9090` |

---

## 💡 Guía de Selección de Plantilla

### ¿Cuál plantilla debo usar?

#### 🔧 Development
**Úsala si:**
- Estás desarrollando localmente
- Necesitas ver todos los logs
- Quieres queries lentas registradas (> 2 segundos)
- No te importa el rendimiento máximo

**No la uses si:**
- Necesitas simular producción
- Vas a hacer pruebas de carga

#### 🚀 Production
**Úsala si:**
- Tu aplicación está en producción
- Tienes tráfico real de usuarios
- Necesitas alta disponibilidad
- Tu servidor tiene al menos 8GB RAM

**No la uses si:**
- Estás en desarrollo
- Tu servidor tiene poca RAM

#### 🧪 Testing
**Úsala si:**
- Estás en un pipeline de CI/CD
- Ejecutas tests automatizados
- No necesitas persistencia de datos
- Quieres velocidad máxima de inicio

**No la uses si:**
- Necesitas guardar datos entre ejecuciones
- Vas a hacer pruebas de rendimiento realistas

#### 📊 Analytics
**Úsala si:**
- Ejecutas reportes complejos
- Haces análisis de datos (BI)
- Tienes queries con muchos JOINs
- Usas MySQL como data warehouse

**No la uses si:**
- Tu aplicación es OLTP (transaccional)
- Prioridad es velocidad de escritura

---

## 🔄 Migración Entre Plantillas

### De Development a Production

1. **Backup de datos:**
   ```bash
   docker exec mysql_dev mysqldump -u root -p --all-databases > backup.sql
   ```

2. **Configurar .env para producción:**
   ```bash
   cp templates/.env.example .env
   # Editar .env con credenciales seguras
   ```

3. **Detener development:**
   ```bash
   docker-compose -f templates/development.yml down
   ```

4. **Levantar production:**
   ```bash
   docker-compose -f templates/production.yml --env-file .env up -d
   ```

5. **Restaurar datos:**
   ```bash
   docker exec -i mysql_prod mysql -u root -p < backup.sql
   ```

### Ejecutar Múltiples Plantillas Simultáneamente

Es posible ejecutar varias plantillas al mismo tiempo:

```bash
# Development en un puerto
MYSQL_PORT=3306 docker-compose -f templates/development.yml up -d

# Testing en otro puerto
MYSQL_PORT=3307 GRAFANA_PORT=3001 PROMETHEUS_PORT=9091 \
  docker-compose -f templates/testing.yml up -d
```

Cada una usa su propia red y volúmenes, por lo que no hay conflictos.

---

## 📊 Cálculo de Recursos

### Buffer Pool Size (Regla General)

- **Servidor dedicado:** 70-80% de RAM total
- **Servidor compartido:** 50% de RAM total
- **Desarrollo:** 128MB - 512MB
- **Producción pequeña:** 1GB - 2GB
- **Producción media:** 4GB - 8GB
- **Producción grande:** 16GB+

### Conexiones Máximas

**Fórmula aproximada:**
```
RAM (MB) = max_connections × (sort_buffer + read_buffer + binlog_cache)
```

**Ejemplos:**
- 1GB RAM → ~50-100 conexiones
- 4GB RAM → ~200-400 conexiones
- 8GB RAM → ~500-1000 conexiones

---

## 🐛 Troubleshooting Común por Plantilla

### Development

**Problema:** MySQL usa mucha memoria
- **Causa:** Logging completo habilitado
- **Solución:** Normal para desarrollo, reduce `MYSQL_GENERAL_LOG` si necesitas

### Production

**Problema:** MySQL no inicia, error de memoria
- **Causa:** `innodb_buffer_pool_size` muy grande para RAM disponible
- **Solución:** Reduce el valor en .env o aumenta RAM del servidor

### Testing

**Problema:** Datos se pierden al reiniciar
- **Causa:** Usa `tmpfs`, es esperado
- **Solución:** Normal para testing, usa otra plantilla si necesitas persistencia

### Analytics

**Problema:** Queries muy lentos
- **Causa:** Puede necesitar más `tmp_table_size` o índices
- **Solución:** Aumenta memoria temporal o revisa queries con EXPLAIN

---

## 📚 Referencias

- [MySQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [InnoDB Configuration](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html)
- [MySQL Calculator](https://www.mysqlcalculator.com/)

---

**Última actualización:** Enero 2026
