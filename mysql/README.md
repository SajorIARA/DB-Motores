# 🐬 MySQL + Prometheus + Grafana - Stack Completo de Monitoreo

Sistema completo de MySQL con monitoreo avanzado mediante Prometheus y visualización en Grafana. Incluye 4 plantillas pre-configuradas para diferentes escenarios de uso.

---

## 🚀 Inicio Rápido (5 minutos)

### 1️⃣ Elegir Plantilla

```bash
# Desde la raíz del repositorio
cd mysql

# Desarrollo (configuración ligera)
docker-compose -f templates/development.yml up -d

# Producción (configuración optimizada)
docker-compose -f templates/production.yml up -d

# Testing/CI-CD (sin persistencia)
docker-compose -f templates/testing.yml up -d

# Analytics (optimizado para queries complejas)
docker-compose -f templates/analytics.yml up -d
```

### 2️⃣ Acceder a los Servicios

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| **MySQL** | `localhost:3306` | Ver plantilla elegida |
| **Grafana** | http://localhost:3000 | admin / (ver plantilla) |
| **Prometheus** | http://localhost:9090 | - |
| **Exporter** | http://localhost:9104/metrics | - |

### 3️⃣ Ver Dashboards en Grafana

1. Abre http://localhost:3000
2. Login con credenciales de la plantilla
3. Ve a **Dashboards** → Carpeta **MySQL**
4. Explora los 5 dashboards pre-configurados

---

## 📁 Estructura del Proyecto

```
mysql/
├── 📄 README.md                    # Este archivo
├── 📄 QUICK-START.md               # Guía rápida de uso
├── 📄 STRUCTURE.md                 # Documentación de estructura
│
├── 📂 templates/                   # ⭐ PLANTILLAS PRE-CONFIGURADAS
│   ├── 📄 README.md                # Documentación completa de plantillas
│   ├── 📄 .env.example             # Ejemplo de variables de entorno
│   ├── 📄 base.yml                 # Plantilla base
│   ├── 📄 development.yml          # Desarrollo local
│   ├── 📄 production.yml           # Producción (alta carga)
│   ├── 📄 testing.yml              # CI/CD y testing
│   └── 📄 analytics.yml            # Data warehouse y BI
│
├── 📂 grafana/                     # Configuración de Grafana
│   ├── 📄 README.md                # Guía de Grafana
│   └── 📂 provisioning/
│       ├── 📂 datasources/         # Auto-configuración de Prometheus
│       └── 📂 dashboards/          # 5 dashboards incluidos
│
├── 📂 config/                      # Configuración avanzada de MySQL
│   ├── 📄 README.md
│   └── my.cnf.example
│
├── 📂 init-scripts/                # Scripts SQL de inicialización
│   ├── 📄 README.md
│   ├── 01-init.sql.example
│   ├── 02-functions.sql.example
│   └── 03-setup.sh.example
│
├── 📄 mysqld-exporter.cnf          # Configuración del exporter
├── 📄 prometheus.yml               # Configuración de scraping
└── 📄 .gitignore                   # Ignorar .env y datos
```

Ver [STRUCTURE.md](STRUCTURE.md) para documentación detallada de cada archivo.

---

## 🎯 Plantillas Disponibles

### Comparativa Rápida

| Plantilla | RAM | Conexiones | Uso | Persistencia |
|-----------|-----|------------|-----|--------------|
| **development.yml** | 512MB-1GB | 50 | Desarrollo local | ✅ Volúmenes |
| **production.yml** | 4GB-8GB | 500 | Producción | ✅ Volúmenes |
| **testing.yml** | 256MB-512MB | 20 | CI/CD, tests | ❌ Temporal |
| **analytics.yml** | 2GB-4GB | 100 | Data warehouse | ✅ Volúmenes |

Ver [templates/README.md](templates/README.md) para comparativa detallada.

---

## 📊 Dashboards de Grafana Incluidos

### 1. MySQL Overview (Vista General)
- Estado del servidor (UP/DOWN) y uptime
- Conexiones activas y disponibles
- Queries por segundo (QPS)
- Operaciones DML (INSERT/UPDATE/DELETE)
- Throughput y latencia
- Tamaño de bases de datos

### 2. MySQL Connections (Conexiones)
- Conexiones activas vs máximo
- Threads conectados, corriendo y cacheados
- Ratio de abortadas
- Historial de conexiones
- Estados de threads

### 3. MySQL InnoDB (Motor de Almacenamiento)
- Buffer pool utilization y hit ratio
- I/O de disco vs caché
- Log files y checkpoints
- Row operations (reads/writes/updates)
- Lock waits y deadlocks

### 4. MySQL Query Performance (Rendimiento de Queries)
- Queries lentas (slow queries)
- Queries ejecutándose actualmente
- Sorts y joins sin índices
- Full table scans
- Query cache hit ratio

### 5. MySQL System Metrics (Métricas del Sistema)
- CPU y memoria del contenedor
- Disk I/O y throughput
- Network traffic
- Tabla/índice top por uso

Ver [grafana/README.md](grafana/README.md) para guía completa de dashboards.

---

## 🔧 Personalización Avanzada

### Usar Variables de Entorno

1. **Copiar plantilla de ejemplo:**
   ```bash
   cp templates/.env.example .env
   ```

2. **Editar variables:**
   ```bash
   # .env
   MYSQL_ROOT_PASSWORD=SecureRootPass123!
   MYSQL_USER=myuser
   MYSQL_PASSWORD=SecurePass123!
   MYSQL_DATABASE=mydatabase
   MYSQL_INNODB_BUFFER_POOL_SIZE=2G
   MYSQL_MAX_CONNECTIONS=500
   ```

3. **Levantar con variables:**
   ```bash
   docker-compose -f templates/production.yml --env-file .env up -d
   ```

### Variables Principales

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `MYSQL_ROOT_PASSWORD` | Contraseña root ⚠️ Requerida | `SecureRoot123!` |
| `MYSQL_USER` | Usuario de aplicación | `myuser` |
| `MYSQL_PASSWORD` | Contraseña de usuario | `SecurePass123!` |
| `MYSQL_DATABASE` | Base de datos inicial | `mydatabase` |
| `MYSQL_INNODB_BUFFER_POOL_SIZE` | Memoria buffer pool | `2G` |
| `MYSQL_MAX_CONNECTIONS` | Conexiones máximas | `500` |
| `GF_ADMIN_USER` | Usuario Grafana | `admin` |
| `GF_ADMIN_PASSWORD` | Password Grafana | `admin123` |

Ver [templates/.env.example](templates/.env.example) para lista completa.

---

## 📈 Métricas Monitoreadas

El sistema incluye métricas completas configuradas en `mysqld_exporter`:

### Categorías de Métricas

1. **Server Status** - Estado general del servidor
2. **Connection Metrics** - Conexiones y threads
3. **Query Metrics** - Queries, selects, inserts, updates, deletes
4. **InnoDB Metrics** - Buffer pool, log, row operations
5. **Table Statistics** - Estadísticas por tabla
6. **Replication** - Estado de réplicas
7. **Performance Schema** - Métricas avanzadas de performance
8. **Slow Queries** - Queries lentas
9. **Table Locks** - Bloqueos de tablas
10. **Binary Logs** - Logs binarios

---

## 🔒 Seguridad

### ⚠️ Antes de Producción

- [ ] **Cambiar contraseñas por defecto**
- [ ] **Usar contraseñas fuertes** (16+ caracteres)
- [ ] **Deshabilitar root remoto**
- [ ] **No exponer puertos públicamente** (usar VPN/proxy)
- [ ] **Habilitar SSL/TLS en MySQL**
- [ ] **Configurar usuarios con privilegios mínimos**
- [ ] **Usar Docker secrets en lugar de .env**
- [ ] **Configurar backups automáticos**
- [ ] **Configurar alertas en Grafana**
- [ ] **Revisar logs regularmente**

### Ejemplo de Secrets

```yaml
secrets:
  mysql_root_password:
    external: true
  mysql_password:
    external: true

services:
  mysql:
    secrets:
      - mysql_root_password
      - mysql_password
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql_root_password
      MYSQL_PASSWORD_FILE: /run/secrets/mysql_password
```

---

## 🛠️ Comandos Útiles

### Gestión de Contenedores

```bash
# Ver logs
docker-compose -f templates/production.yml logs -f

# Ver logs de MySQL específicamente
docker-compose -f templates/production.yml logs -f mysql

# Reiniciar servicios
docker-compose -f templates/production.yml restart

# Detener servicios
docker-compose -f templates/production.yml stop

# Eliminar todo (⚠️ borra volúmenes)
docker-compose -f templates/production.yml down -v
```

### MySQL

```bash
# Conectar a MySQL
docker exec -it mysql_prod mysql -u root -p

# Conectar con usuario específico
docker exec -it mysql_prod mysql -u myuser -p mydatabase

# Backup
docker exec mysql_prod mysqldump -u root -p mydatabase > backup.sql

# Restaurar
docker exec -i mysql_prod mysql -u root -p mydatabase < backup.sql

# Ver variables del sistema
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES;"

# Ver estado del servidor
docker exec mysql_prod mysql -u root -p -e "SHOW STATUS;"

# Ver procesos activos
docker exec mysql_prod mysql -u root -p -e "SHOW PROCESSLIST;"

# Verificar usuario exporter
docker exec mysql_prod mysql -u root -p -e "SELECT User, Host FROM mysql.user WHERE User='exporter';"
```

### Monitoreo

```bash
# Ver métricas raw del exporter
curl http://localhost:9104/metrics | grep mysql_

# Verificar que MySQL esté UP desde exporter
curl http://localhost:9104/metrics | grep mysql_up
# Output esperado: mysql_up 1

# Ver targets de Prometheus
curl http://localhost:9090/api/v1/targets | jq

# Reload Prometheus (sin reiniciar)
curl -X POST http://localhost:9090/-/reload
```

---

## 🐛 Troubleshooting

### MySQL no inicia

```bash
# Ver logs
docker logs mysql_prod

# Problemas comunes:
# - MYSQL_ROOT_PASSWORD no definida
# - Puerto 3306 ya en uso
# - Falta de memoria (buffer pool muy alto)
# - Permisos en volúmenes
# - Archivo my.cnf con errores de sintaxis
```

### Grafana no muestra datos

```bash
# 1. Verificar que Prometheus esté UP
curl http://localhost:9090/-/healthy
# Output esperado: Prometheus is Healthy

# 2. Verificar targets en Prometheus
curl http://localhost:9090/api/v1/targets | grep mysql
# O visitar: http://localhost:9090/targets
# mysqld-exporter debe estar UP (status: up, health: up)

# 3. Verificar métricas del exporter
curl http://localhost:9104/metrics | grep mysql_up
# Output esperado: mysql_up 1

# 4. Verificar datasource en Grafana
# Configuration → Data Sources → Prometheus → Test
# Debe mostrar: "Data source is working"

# 5. Verificar usuario exporter en MySQL
docker exec mysql_dev mysql -u root -pdev_root_pass_123 -e "SELECT User, Host FROM mysql.user WHERE User='exporter';"
# Debe existir el usuario exporter

# 6. Verificar logs de Grafana
docker logs grafana_dev | grep -i error
```

### mysqld_exporter no conecta

```bash
# Ver logs del exporter
docker logs mysqld_exporter_dev  # o mysqld_exporter_prod, etc.

# Verificar métricas
curl http://localhost:9104/metrics | grep mysql_up
# Debe mostrar: mysql_up 1

# Problemas comunes:
# 1. Credenciales incorrectas en .my.cnf
#    - Verificar que password sea: exporter_password_123
#    - Verificar que coincida con docker-compose DATA_SOURCE_NAME

# 2. Usuario 'exporter' no existe en MySQL
#    - Conectar: docker exec -it mysql_dev mysql -u root -pdev_root_pass_123
#    - Crear: CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter_password_123' WITH MAX_USER_CONNECTIONS 3;
#    - Permisos: GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
#    - Aplicar: FLUSH PRIVILEGES;

# 3. MySQL no está levantado todavía
#    - Esperar unos segundos después de 'docker-compose up'
#    - Verificar: docker ps | grep mysql
```

### Conflicto de puertos

```bash
# Error: port is already allocated
# Solución 1: Cambiar puerto en .env
MYSQL_PORT=3307
GRAFANA_PORT=3001

# Solución 2: Detener otros contenedores
docker ps  # Ver qué usa el puerto
docker stop <container-id>
```

### Performance lento

```bash
# Verificar configuración de memoria
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES LIKE '%buffer%';"

# Verificar conexiones
docker exec mysql_prod mysql -u root -p -e "SHOW STATUS LIKE 'Threads%';"

# Verificar queries lentas
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES LIKE 'slow_query%';"
```

---

## 📚 Documentación Adicional

### En este proyecto:
- [QUICK-START.md](QUICK-START.md) - Guía rápida de inicio
- [STRUCTURE.md](STRUCTURE.md) - Documentación de estructura del proyecto
- [templates/README.md](templates/README.md) - Documentación completa de plantillas
- [grafana/README.md](grafana/README.md) - Guía de Grafana y dashboards
- [config/README.md](config/README.md) - Configuración avanzada de MySQL
- [init-scripts/README.md](init-scripts/README.md) - Scripts de inicialización

### Recursos externos:
- **MySQL:** https://dev.mysql.com/doc/
- **Docker Hub MySQL:** https://hub.docker.com/_/mysql
- **Prometheus:** https://prometheus.io/docs/
- **Grafana:** https://grafana.com/docs/
- **mysqld_exporter:** https://github.com/prometheus/mysqld_exporter
- **MySQL Performance Tuning:** https://dev.mysql.com/doc/refman/8.0/en/optimization.html

---

## 🔄 Diferencias con PostgreSQL

Si vienes de PostgreSQL, nota estas diferencias clave:

| Característica | PostgreSQL | MySQL |
|----------------|------------|-------|
| **Puerto por defecto** | 5432 | 3306 |
| **Usuario admin** | postgres | root |
| **Archivo config** | postgresql.conf | my.cnf |
| **Buffer principal** | shared_buffers | innodb_buffer_pool_size |
| **Motor de almacenamiento** | N/A (uno solo) | InnoDB (por defecto) |
| **Replicación** | Streaming | Binary logs |
| **Exporter** | postgres_exporter (puerto 9187) | mysqld_exporter (puerto 9104) |

---

**Mantenido por:** RAISIAR  
**Última actualización:** Enero 2026  
**Versión:** 1.0.0

---

> 💡 **Tip:** MySQL y MariaDB son compatibles. Estas configuraciones funcionan también con MariaDB con mínimos cambios.
