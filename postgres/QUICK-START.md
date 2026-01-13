# 🚀 PostgreSQL + Monitoreo - Guía de Inicio Rápido

Levanta PostgreSQL con Prometheus y Grafana en **menos de 5 minutos**.

---

## 📋 Requisitos Previos

- Docker instalado ([Descarga aquí](https://www.docker.com/products/docker-desktop))
- Docker Compose instalado (incluido en Docker Desktop)

---

## ⚡ Inicio Rápido (3 comandos)

### 1️⃣ Elegir tu escenario

```bash
# Desde la raíz del repositorio DB-Motores
cd postgres

# OPCIÓN A: Desarrollo local
docker-compose -f templates/development.yml up -d

# OPCIÓN B: Producción
docker-compose -f templates/production.yml up -d

# OPCIÓN C: Testing/CI-CD
docker-compose -f templates/testing.yml up -d

# OPCIÓN D: Analytics/BI
docker-compose -f templates/analytics.yml up -d
```

### 2️⃣ Esperar a que inicien (10-30 segundos)

```bash
docker-compose -f templates/development.yml ps
```

### 3️⃣ ¡Listo! Acceder a los servicios

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| **PostgreSQL** | `localhost:5432` | Ver credenciales abajo |
| **Grafana** | http://localhost:3000 | Ver credenciales abajo |
| **Prometheus** | http://localhost:9090 | (sin autenticación) |

---

## 🔑 Credenciales por Defecto

### Development (`development.yml`)
- **PostgreSQL:** `dev_user` / `dev_pass_123`
- **Grafana:** `admin` / `dev_admin_123`

### Production (`production.yml`)
- **PostgreSQL:** Definir en `.env` (obligatorio)
- **Grafana:** Definir en `.env` (obligatorio)

### Testing (`testing.yml`)
- **PostgreSQL:** `test_user` / `test_pass`
- **Grafana:** `admin` / `admin` (acceso anónimo habilitado)

### Analytics (`analytics.yml`)
- **PostgreSQL:** `analytics_user` / `analytics_pass_456`
- **Grafana:** `admin` / `analytics_admin_789`

---

## 🎯 ¿Qué Obtengo?

✅ **PostgreSQL 17-alpine** funcionando en contenedor
✅ **Prometheus** recolectando métricas cada 10 segundos
✅ **Grafana** con 5 dashboards pre-configurados:
- Vista General
- Configuración
- Queries y Locks
- Tablas e Índices
- Performance e I/O

✅ **13 categorías de métricas** monitoreadas automáticamente

---

## 🔧 Personalización Rápida

### Usar Variables de Entorno

1. **Copiar plantilla:**
   ```bash
   cp templates/.env.example .env
   ```

2. **Editar variables:**
   ```bash
   # .env
   POSTGRES_USER=myuser
   POSTGRES_PASSWORD=SecurePass123!
   POSTGRES_DB=mydatabase
   POSTGRES_PORT=5432
   GRAFANA_PORT=3000
   ```

3. **Levantar con variables:**
   ```bash
   docker-compose -f templates/development.yml --env-file .env up -d
   ```

### Cambiar Puertos (sin .env)

```bash
# Usar variables inline
POSTGRES_PORT=5433 GRAFANA_PORT=3001 docker-compose -f templates/development.yml up -d
```

---

## 🛠️ Comandos Básicos

### Ver logs

```bash
# Todos los servicios
docker-compose -f templates/development.yml logs -f

# Solo PostgreSQL
docker-compose -f templates/development.yml logs -f postgres

# Solo Grafana
docker-compose -f templates/development.yml logs -f grafana
```

### Conectar a PostgreSQL

```bash
# Desde terminal
docker exec -it postgres_dev psql -U dev_user -d dev_database

# Desde aplicación externa
Host: localhost
Port: 5432
User: dev_user
Password: dev_pass_123
Database: dev_database
```

### Ver estado

```bash
docker-compose -f templates/development.yml ps
```

### Reiniciar

```bash
# Un servicio
docker-compose -f templates/development.yml restart postgres

# Todos
docker-compose -f templates/development.yml restart
```

### Detener

```bash
# Detener (mantiene datos)
docker-compose -f templates/development.yml stop

# Detener y eliminar (mantiene volúmenes)
docker-compose -f templates/development.yml down

# Detener y eliminar TODO (⚠️ borra datos)
docker-compose -f templates/development.yml down -v
```

---

## 📊 Acceder a Dashboards

### 1. Abrir Grafana

```
http://localhost:3000
```

### 2. Login

Usar credenciales de la plantilla elegida.

### 3. Ver Dashboards

1. Click en el ícono de dashboards (cuadrícula)
2. Entrar a la carpeta **PostgreSQL**
3. Seleccionar dashboard:
   - **Vista General** - Métricas principales
   - **Configuración** - Parámetros de PostgreSQL
   - **Queries y Locks** - Queries activas y bloqueos
   - **Tablas e Índices** - Estadísticas de tablas
   - **Performance e I/O** - Rendimiento de disco

---

## 🐛 Problemas Comunes

### Puerto ya en uso

```bash
# Error: Bind for 0.0.0.0:5432 failed: port is already allocated

# Solución: Cambiar puerto
POSTGRES_PORT=5433 docker-compose -f templates/development.yml up -d
```

### Grafana no muestra datos

```bash
# 1. Verificar que Prometheus está UP
curl http://localhost:9090/-/healthy

# 2. Verificar targets en Prometheus
# Ir a: http://localhost:9090/targets
# El exporter debe estar UP (verde)

# 3. Verificar métricas
curl http://localhost:9187/metrics | grep pg_up
# Debe mostrar: pg_up 1
```

### Contenedor no inicia

```bash
# Ver logs para diagnóstico
docker logs postgres_dev

# Problemas comunes:
# - POSTGRES_PASSWORD no definida
# - shared_buffers muy alto para RAM disponible
# - Permisos de volúmenes
```

---

## 📚 Siguiente Paso

### Aprender Más

- **Documentación completa:** [README.md](README.md)
- **Plantillas detalladas:** [templates/README.md](templates/README.md)
- **Estructura del proyecto:** [STRUCTURE.md](STRUCTURE.md)
- **Guía de Grafana:** [grafana/README.md](grafana/README.md)

### Personalizar

1. Revisar [templates/.env.example](templates/.env.example)
2. Explorar las 4 plantillas diferentes
3. Ajustar parámetros de memoria
4. Configurar scripts de inicialización en `init-scripts/`

### Producción

Antes de usar en producción, revisa:
- [ ] Cambiar todas las contraseñas
- [ ] Configurar SSL/TLS
- [ ] Configurar backups
- [ ] Revisar límites de recursos
- [ ] Configurar alertas en Grafana

Ver [README.md - Seguridad](README.md#-seguridad)

---

## 🎉 ¡Listo!

Ya tienes PostgreSQL con monitoreo completo funcionando.

```bash
# Desarrollo
docker-compose -f templates/development.yml up -d

# Grafana
http://localhost:3000

# ¡A desarrollar! 🚀
```

**¿Dudas?** Revisa [README.md](README.md) o [templates/README.md](templates/README.md)
