# 🐘 PostgreSQL + Prometheus + Grafana - Stack Completo de Monitoreo

Sistema completo de PostgreSQL con monitoreo avanzado mediante Prometheus y visualización en Grafana. Incluye 4 plantillas pre-configuradas para diferentes escenarios de uso.

---

## 🚀 Inicio Rápido (5 minutos)

### 1️⃣ Elegir Plantilla

```bash
# Desde la raíz del repositorio
cd postgres

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
| **PostgreSQL** | `localhost:5432` | Ver plantilla elegida |
| **Grafana** | http://localhost:3000 | admin / (ver plantilla) |
| **Prometheus** | http://localhost:9090 | - |
| **Exporter** | http://localhost:9187/metrics | - |

### 3️⃣ Ver Dashboards en Grafana

1. Abre http://localhost:3000
2. Login con credenciales de la plantilla
3. Ve a **Dashboards** → Carpeta **PostgreSQL**
4. Explora los 5 dashboards pre-configurados

---

## 📁 Estructura del Proyecto

```
postgres/
├── 📄 README.md                    # Este archivo
├── 📄 QUICK-START.md               # Guía rápida de uso
├── 📄 STRUCTURE.md                 # Documentación de estructura
│
├── 📂 templates/                   # ⭐ PLANTILLAS PRE-CONFIGURADAS
│   ├── 📄 README.md                # Documentación completa de plantillas
│   ├── 📄 .env.example             # Ejemplo de variables de entorno
│   ├── 📄 base.yml                 # Plantilla actual (configuración base)
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
├── 📂 config/                      # Configuración avanzada de PostgreSQL
│   ├── 📄 README.md
│   ├── pg_hba.conf.example
│   └── postgresql.conf.example
│
├── 📂 init-scripts/                # Scripts SQL de inicialización
│   ├── 📄 README.md
│   ├── 01-init.sql.example
│   ├── 02-functions.sql.example
│   └── 03-setup.sh.example
│
├── 📄 postgres-queries.yaml        # ⭐ 13 categorías de métricas custom
├── 📄 prometheus.yml               # Configuración de scraping
└── 📄 .gitignore                   # Ignorar .env y datos
```

Ver [STRUCTURE.md](STRUCTURE.md) para documentación detallada de cada archivo.

---

## 🎯 Plantillas Disponibles

### Comparativa Rápida

| Plantilla | RAM | Conexiones | Uso | Persistencia |
|-----------|-----|------------|-----|--------------|
| **development.yml** | 512MB-1GB | 20 | Desarrollo local | ✅ Volúmenes |
| **production.yml** | 4GB-8GB | 200 | Producción | ✅ Volúmenes |
| **testing.yml** | 256MB-512MB | 10 | CI/CD, tests | ❌ Temporal |
| **analytics.yml** | 2GB-4GB | 50 | Data warehouse | ✅ Volúmenes |

Ver [templates/README.md](templates/README.md) para comparativa detallada.

---

## 📊 Dashboards de Grafana Incluidos

### 1. PostgreSQL - Vista General
- Estado del servidor (UP/DOWN)
- Conexiones activas
- Cache hit ratio (gauge)
- Tamaño de base de datos
- Transacciones por segundo
- Operaciones DML

### 2. PostgreSQL - Configuración
- Parámetros de memoria (shared_buffers, work_mem, etc.)
- Configuración de conexiones
- Tabla completa de pg_settings

### 3. PostgreSQL - Queries y Locks
- Locks por tipo y modo
- Queries lentas (> 5 segundos)
- Wait events activos
- Duración de queries

### 4. PostgreSQL - Tablas e Índices
- Tablas con sequential scans (necesitan índices)
- Tuplas muertas (necesitan VACUUM)
- Uso de índices
- Tamaños de tablas

### 5. PostgreSQL - Performance e I/O
- I/O de disco vs caché
- Checkpoints
- WAL statistics
- Background writer
- Archivos temporales

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
   POSTGRES_USER=myuser
   POSTGRES_PASSWORD=SecurePass123!
   POSTGRES_DB=mydatabase
   POSTGRES_SHARED_BUFFERS=2GB
   POSTGRES_MAX_CONNECTIONS=150
   ```

3. **Levantar con variables:**
   ```bash
   docker-compose -f templates/production.yml --env-file .env up -d
   ```

### Variables Principales

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `POSTGRES_USER` | Usuario de PostgreSQL | `myuser` |
| `POSTGRES_PASSWORD` | Contraseña ⚠️ Requerida | `SecurePass123!` |
| `POSTGRES_DB` | Nombre de base de datos | `mydatabase` |
| `POSTGRES_SHARED_BUFFERS` | Memoria compartida | `2GB` |
| `POSTGRES_MAX_CONNECTIONS` | Conexiones máximas | `200` |
| `GF_ADMIN_USER` | Usuario Grafana | `admin` |
| `GF_ADMIN_PASSWORD` | Password Grafana | `admin123` |

Ver [templates/.env.example](templates/.env.example) para lista completa.

---

## 📈 Métricas Monitoreadas

El sistema incluye **13 categorías** de métricas personalizadas configuradas en [postgres-queries.yaml](postgres-queries.yaml):

1. **pg_settings** - Configuración completa de PostgreSQL
2. **pg_database_stats** - Estadísticas por base de datos
3. **pg_active_queries** - Queries activas y estados
4. **pg_table_stats** - Estadísticas de tablas (Top 20)
5. **pg_index_stats** - Uso de índices (Top 20)
6. **pg_locks_detail** - Locks y bloqueos
7. **pg_database_sizes** - Tamaños de bases de datos
8. **pg_table_sizes** - Tamaños de tablas
9. **pg_replication_status** - Estado de réplicas
10. **pg_wal_stats** - Write-Ahead Log
11. **pg_bgwriter** - Background writer y checkpoints
12. **pg_slow_queries** - Queries lentas (> 5 seg)
13. **pg_vacuum_progress** - Progreso de VACUUM

---

## 🔒 Seguridad

### ⚠️ Antes de Producción

- [ ] **Cambiar credenciales por defecto**
- [ ] **Usar contraseñas fuertes** (16+ caracteres)
- [ ] **No exponer puertos públicamente** (usar VPN/proxy)
- [ ] **Habilitar SSL/TLS en PostgreSQL**
- [ ] **Configurar pg_hba.conf restrictivo**
- [ ] **Usar Docker secrets en lugar de .env**
- [ ] **Configurar backups automáticos**
- [ ] **Configurar alertas en Grafana**
- [ ] **Revisar logs regularmente**

### Ejemplo de Secrets (Docker Swarm/Kubernetes)

```yaml
secrets:
  postgres_password:
    external: true

services:
  postgres:
    secrets:
      - postgres_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password
```

---

## 🛠️ Comandos Útiles

### Gestión de Contenedores

```bash
# Ver logs
docker-compose -f templates/production.yml logs -f

# Ver logs de un servicio específico
docker-compose -f templates/production.yml logs -f postgres

# Reiniciar servicios
docker-compose -f templates/production.yml restart

# Detener servicios
docker-compose -f templates/production.yml stop

# Eliminar todo (⚠️ borra volúmenes)
docker-compose -f templates/production.yml down -v
```

### PostgreSQL

```bash
# Conectar a PostgreSQL
docker exec -it postgres_prod psql -U myuser -d mydatabase

# Backup
docker exec postgres_prod pg_dump -U myuser mydatabase > backup.sql

# Restaurar
docker exec -i postgres_prod psql -U myuser mydatabase < backup.sql

# Ver configuración activa
docker exec postgres_prod psql -U myuser -d mydatabase -c "SHOW ALL;"
```

### Monitoreo

```bash
# Ver métricas raw del exporter
curl http://localhost:9187/metrics | grep pg_

# Ver targets de Prometheus
curl http://localhost:9090/api/v1/targets | jq

# Reload Prometheus (sin reiniciar)
curl -X POST http://localhost:9090/-/reload
```

---

## 🐛 Troubleshooting

### PostgreSQL no inicia

```bash
# Ver logs
docker logs postgres_prod

# Problemas comunes:
# - POSTGRES_PASSWORD no definida
# - Puerto 5432 ya en uso
# - Falta de memoria (shared_buffers muy alto)
# - Permisos en volúmenes
```

### Grafana no muestra datos

```bash
# 1. Verificar que Prometheus esté UP
curl http://localhost:9090/-/healthy

# 2. Verificar targets
# Ir a: http://localhost:9090/targets
# postgres-exporter debe estar UP

# 3. Verificar métricas
curl http://localhost:9187/metrics | grep pg_up

# 4. Verificar datasource en Grafana
# Configuration → Data Sources → Prometheus → Test
```

### Conflicto de puertos

```bash
# Error: port is already allocated
# Solución 1: Cambiar puerto en .env
POSTGRES_PORT=5433
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
- ✨ 5 dashboards de Grafana incluidos
- ✨ 13 categorías de métricas custom
- ✨ Documentación completa reestructurada
- ✨ Soporte completo para variables de entorno
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
