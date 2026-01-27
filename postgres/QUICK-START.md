# 🚀 PostgreSQL + Monitoreo - Guía de Inicio Rápido

Levanta PostgreSQL con Prometheus y Grafana en **menos de 5 minutos**.

# 🚀 PostgreSQL 17.7 Alpine + Monitoreo - Guía de Inicio Rápido

Levanta PostgreSQL 17.7 con Prometheus + Grafana en **menos de 5 minutos**.

---

## 📋 Requisitos Previos

- ✅ **Docker Desktop** instalado ([Descarga aquí](https://www.docker.com/products/docker-desktop))
- ✅ **Docker Compose** incluido en Docker Desktop
- ✅ **4GB RAM** disponible (mínimo para development)

---

## ⚡ Inicio Rápido (3 pasos)

### 1️⃣ Elegir tu plantilla

```powershell
# Navegar al directorio postgres
cd D:\DB-Motores\postgres

# OPCIÓN A: Desarrollo local (script)
scripts/start-development.ps1

# OPCIÓN B: Producción (script)
scripts/start-production.ps1

# OPCIÓN C: Testing/CI-CD (script)
scripts/start-testing.ps1

# OPCIÓN D: Analytics/BI (script)
scripts/start-analytics.ps1
```

### 2️⃣ Esperar a que inicien (10-30 segundos)

```powershell
# Verificar estado
docker-compose -f templates/development.yml ps
```

### 3️⃣ ¡Listo! Acceder a los servicios

| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| **PostgreSQL** | `localhost:5432` | `myuser` | `mypassword` |
| **Grafana** | http://localhost:3000 | `admin` | `admin` |
| **Prometheus** | http://localhost:9090 | - | - |
| **Exporter** | http://localhost:9187/metrics | - | - |

---

## 🔑 Credenciales por Plantilla

### 🛠️ Development (`development.yml`)
- **PostgreSQL:** `myuser` / `mypassword` / `mydatabase`
- **Grafana:** `admin` / `admin`
- **Recursos:** 128MB shared_buffers, 20 conexiones
- **Logging:** Activado (queries lentas > 1s)

### 🚀 Production (`production.yml`)
- **PostgreSQL:** `myuser` / `mypassword` / `mydatabase`
- **Grafana:** `admin` / `admin` (⚠️ **CAMBIAR EN PRODUCCIÓN**)
- **Recursos:** 1GB shared_buffers, 100 conexiones
- **Config:** Usa archivos `config/postgresql.conf` y `pg_hba.conf`

### 🧪 Testing (`testing.yml`)
- **PostgreSQL:** `myuser` / `mypassword` / `mydatabase`
- **Grafana:** `admin` / `admin`
- **Recursos:** 64MB shared_buffers, 10 conexiones
- **Optimización:** fsync=off (velocidad máxima, no para producción)

### 📊 Analytics (`analytics.yml`)
- **PostgreSQL:** `myuser` / `mypassword` / `mydatabase`
- **Grafana:** `admin` / `admin`
- **Recursos:** 1GB shared_buffers, **128MB work_mem** (queries complejas), 50 conexiones


---

## 🎯 ¿Qué Incluye?

✅ **PostgreSQL 17.7 Alpine** - Última versión estable y optimizada  
✅ **postgres_exporter** - 350+ métricas automáticas  
✅ **Prometheus** - Scraping cada 10 segundos  
✅ **Grafana** - 5 dashboards pre-configurados:

### 📊 Dashboards Disponibles

1. **PostgreSQL - Overview** - Visión general del sistema
   - Conexiones activas, commits, rollbacks
   - Cache hit ratio, tuplas procesadas
   - Deadlocks, temp files, duración máxima de transacciones

2. **PostgreSQL - Configuration** - Parámetros del servidor
   - shared_buffers, work_mem, max_connections
   - Todas las configuraciones de postgresql.conf

3. **PostgreSQL - Performance e I/O** - Rendimiento de disco
   - Disk reads vs cache hits
   - WAL segments, WAL size, checkpoints
   - Background writer statistics

4. **PostgreSQL - Queries y Locks** - Estados de conexiones
   - Conexiones por estado (active, idle, idle in transaction)
   - Duración máxima de transacciones
   - Deadlocks

5. **PostgreSQL - Tables e Indexes** - Operaciones DML
   - Tuplas insertadas/actualizadas/eliminadas
   - Tuplas leídas/retornadas
   - Archivos temporales generados

✅ **Queries compatibles con PostgreSQL 17** - Usa `postgres-queries-safe.yaml`  
✅ **Métricas por defecto del exporter** - Sin custom queries problemáticas  

---

## 🔧 Personalización Rápida

### Cambiar Puertos (sin .env)

```powershell
# Usar variables inline (Windows PowerShell)
$env:POSTGRES_PORT=5433; $env:GRAFANA_PORT=3001; docker-compose -f templates/development.yml up -d
```

### Usar Variables de Entorno

1. **Copiar plantilla:**
   ```powershell
   Copy-Item templates\.env.example .env
   ```

2. **Editar variables:**
   ```ini
   # .env
   POSTGRES_USER=myuser
   POSTGRES_PASSWORD=SecurePass123!
   POSTGRES_DB=mydatabase
   POSTGRES_PORT=5432
   GRAFANA_PORT=3000
   ```

3. **Levantar con variables:**
   ```powershell
   docker-compose -f templates/development.yml --env-file .env up -d
   ```

---

## 🛠️ Comandos Básicos

### Ver logs

```powershell
# Todos los servicios
docker-compose -f templates/development.yml logs -f

# Solo PostgreSQL
docker logs postgres_dev -f

# Solo Grafana
docker logs grafana_dev -f
```

### Conectar a PostgreSQL

```powershell
# Desde terminal
docker exec -it postgres_dev psql -U myuser -d mydatabase

# Desde aplicación externa (DBeaver, pgAdmin, etc.)
Host: localhost
Port: 5432
User: myuser
Password: mypassword
Database: mydatabase
```

### Ver estado

```powershell
docker-compose -f templates/development.yml ps
```

### Reiniciar

```powershell
# Un servicio específico
docker-compose -f templates/development.yml restart postgres

# Todos los servicios
docker-compose -f templates/development.yml restart
```

### Detener

```powershell
# Detener (mantiene datos en volúmenes)
docker-compose -f templates/development.yml stop

# Detener y eliminar contenedores (mantiene volúmenes)
docker-compose -f templates/development.yml down

# Detener y eliminar TODO (⚠️ borra datos permanentemente)
docker-compose -f templates/development.yml down -v
```

---

## 📊 Acceder a Dashboards

### 1. Abrir Grafana

```
http://localhost:3000
```

### 2. Login

- **Usuario:** `admin`
- **Contraseña:** `admin`

### 3. Ver Dashboards

1. Click en el ícono de dashboards (☰ menú lateral)
2. Buscar en **Dashboards**
3. Seleccionar uno de los 5 dashboards PostgreSQL:
   - **PostgreSQL - Overview** - Métricas principales
   - **PostgreSQL - Configuration** - Parámetros del servidor
   - **PostgreSQL - Performance e I/O** - Rendimiento de disco y WAL
   - **PostgreSQL - Queries y Locks** - Estados de conexiones
   - **PostgreSQL - Tables e Indexes** - Operaciones sobre tablas

### 4. Verificar Conexión

Si ves **"No data"** en los dashboards:

1. Ir a **Configuration → Data Sources → Prometheus**
2. Click en **"Test"** → Debe mostrar "Data source is working"
3. Ir a http://localhost:9090/targets → `postgres-exporter` debe estar **UP** (verde)

---

## 🐛 Problemas Comunes

### ❌ Puerto ya en uso

```powershell
# Error: Bind for 0.0.0.0:5432 failed: port is already allocated

# Solución: Cambiar puerto
$env:POSTGRES_PORT=5433; docker-compose -f templates/development.yml up -d
```

### ❌ Grafana no muestra datos

```powershell
# 1. Verificar que Prometheus está funcionando
Invoke-WebRequest http://localhost:9090/-/healthy

# 2. Verificar targets en Prometheus
# Ir a: http://localhost:9090/targets
# El "postgres-exporter" debe estar UP (verde)

# 3. Verificar métricas raw del exporter
Invoke-WebRequest http://localhost:9187/metrics | Select-String "pg_up"
# Debe mostrar: pg_up 1

# 4. Reiniciar Grafana
docker-compose -f templates/development.yml restart grafana
```

### ❌ PostgreSQL no inicia

```powershell
# Ver logs para diagnóstico
docker logs postgres_dev

# Problemas comunes:
# - shared_buffers muy alto para RAM disponible
# - Puerto 5432 ya en uso por otra instancia
# - Volúmenes con permisos incorrectos
```

**Solución rápida: Recrear contenedores**

```powershell
docker-compose -f templates/development.yml down -v
docker-compose -f templates/development.yml up -d
```

---

## 📚 Siguiente Paso

### ✅ Documentación Completa

- 📖 **[README.md](README.md)** - Documentación completa del proyecto
- 📂 **[STRUCTURE.md](STRUCTURE.md)** - Arquitectura técnica detallada
- 📊 **[METRICAS-DISPONIBLES.md](METRICAS-DISPONIBLES.md)** - Catálogo de 350+ métricas
- 🎨 **[grafana/README.md](grafana/README.md)** - Guía de dashboards
- ⚙️ **[templates/README.md](templates/README.md)** - Comparativa de plantillas

### 🔧 Personalizar

1. Explorar las 4 plantillas diferentes (development, production, testing, analytics)
2. Revisar queries personalizadas en `postgres-queries-safe.yaml`
3. Configurar scripts de inicialización en `init-scripts/`
4. Ajustar parámetros de PostgreSQL en archivos de configuración

### 🚀 Producción

**⚠️ CHECKLIST ANTES DE PRODUCCIÓN:**

- [ ] **Cambiar contraseña de PostgreSQL** (`POSTGRES_PASSWORD`)
- [ ] **Cambiar contraseña de Grafana** (`GF_SECURITY_ADMIN_PASSWORD`)
- [ ] **Usar SSL/TLS** en conexiones a PostgreSQL
- [ ] **Configurar backups automáticos** (pg_dump + cron)
- [ ] **No exponer puertos** públicamente (usar VPN/proxy reverso)
- [ ] **Configurar pg_hba.conf** restrictivo (solo IPs autorizadas)
- [ ] **Configurar alertas** en Grafana para métricas críticas
- [ ] **Revisar límites de recursos** (RAM, CPU, disk I/O)
- [ ] **Habilitar log_statement** para auditoría
- [ ] **Configurar retención de logs** en Prometheus

Ver: [README.md - Seguridad](README.md#-seguridad)

---

## 🎉 ¡Listo!

Ya tienes **PostgreSQL 17.7** con monitoreo completo funcionando.

```powershell
# Levantar desarrollo
docker-compose -f templates/development.yml up -d

# Acceder a Grafana
Start-Process http://localhost:3000

# Conectar a PostgreSQL
docker exec -it postgres_dev psql -U myuser -d mydatabase

# ¡A desarrollar! 🚀
```

**¿Dudas?** Revisa la documentación completa en [README.md](README.md)
