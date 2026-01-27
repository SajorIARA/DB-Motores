# 🚀 MySQL + Monitoreo - Guía de Inicio Rápido

Levanta MySQL con Prometheus y Grafana en **menos de 5 minutos**.

---

## 📋 Requisitos Previos

- Docker instalado ([Descarga aquí](https://www.docker.com/products/docker-desktop))
- Docker Compose instalado (incluido en Docker Desktop)

---

## ⚡ Inicio Rápido (3 comandos)

### 1️⃣ Elegir tu escenario

```bash
# Desde la raíz del repositorio DB-Motores
cd mysql

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
| **MySQL** | `localhost:3306` | Ver credenciales abajo |
| **Grafana** | http://localhost:3000 | Ver credenciales abajo |
| **Prometheus** | http://localhost:9090 | (sin autenticación) |

---

## 🔑 Credenciales por Defecto

### Development (`development.yml`)
- **MySQL Root:** `dev_root_pass_123`
- **MySQL User:** `dev_user` / `dev_pass_123`
- **MySQL Database:** `dev_database`
- **MySQL Exporter:** `exporter` / `exporter_password_123` (interno)
- **Grafana:** `admin` / `dev_admin_123`

### Production (`production.yml`)
- **MySQL Root:** `${MYSQL_ROOT_PASSWORD}` (definir en `.env`)
- **MySQL User:** `${MYSQL_USER}` / `${MYSQL_PASSWORD}` (definir en `.env`)
- **MySQL Database:** `${MYSQL_DATABASE}` (definir en `.env`)
- **MySQL Exporter:** `exporter` / `exporter_password_123` (interno)
- **Grafana:** `admin` / `${GF_ADMIN_PASSWORD}` (definir en `.env`)

### Testing (`testing.yml`)
- **MySQL Root:** `test_root_pass`
- **MySQL User:** `test_user` / `test_pass`
- **MySQL Database:** `test_database`
- **MySQL Exporter:** `exporter` / `exporter_password_123` (interno)
- **Grafana:** `admin` / `admin`

### Analytics (`analytics.yml`)
- **MySQL Root:** `analytics_root_pass_456`
- **MySQL User:** `analytics_user` / `analytics_pass_456`
- **MySQL Database:** `analytics_database`
- **MySQL Exporter:** `exporter` / `exporter_password_123` (interno)
- **Grafana:** `admin` / `analytics_admin_789`

---

## 🎯 ¿Qué Obtengo?

✅ **MySQL 8.0** funcionando en contenedor  
✅ **mysqld_exporter** recolectando 100+ métricas  
✅ **Prometheus** scrapeando métricas cada 10 segundos  
✅ **Grafana** con 5 dashboards pre-configurados:
- MySQL Overview
- MySQL Connections  
- MySQL InnoDB
- MySQL Query Performance
- MySQL System Metrics

✅ **Usuario exporter** creado automáticamente con permisos correctos  
✅ **Datasource Prometheus** provisionado automáticamente en Grafana

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
   MYSQL_ROOT_PASSWORD=SecureRootPass123!
   MYSQL_USER=myuser
   MYSQL_PASSWORD=SecurePass123!
   MYSQL_DATABASE=mydatabase
   MYSQL_PORT=3306
   ```

3. **Levantar con variables:**
   ```bash
   docker-compose -f templates/production.yml --env-file .env up -d
   ```

---

## 🔌 Conectar a MySQL

### Desde línea de comandos

```bash
# Conectar como root
docker exec -it mysql_dev mysql -u root -p
# Password: dev_root_pass_123

# Conectar como usuario de aplicación
docker exec -it mysql_dev mysql -u dev_user -p dev_database
# Password: dev_pass_123
```

### Desde aplicación (Node.js ejemplo)

```javascript
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  port: 3306,
  user: 'dev_user',
  password: 'dev_pass_123',
  database: 'dev_database'
});

connection.connect();
```

### Desde aplicación (Python ejemplo)

```python
import mysql.connector

connection = mysql.connector.connect(
    host='localhost',
    port=3306,
    user='dev_user',
    password='dev_pass_123',
    database='dev_database'
)
```

### Desde herramientas GUI

- **MySQL Workbench**
- **DBeaver**
- **HeidiSQL**
- **phpMyAdmin** (puede agregarse como contenedor)

**Configuración:**
- Host: `localhost`
- Puerto: `3306`
- Usuario: Ver credenciales arriba
- Password: Ver credenciales arriba

---

## 📊 Ver Dashboards

1. **Abrir Grafana:** http://localhost:3000
2. **Login** con credenciales de la plantilla
3. **Ir a Dashboards** (icono de cuadros)
4. **Carpeta MySQL** → Explora los 5 dashboards

---

## 🛠️ Comandos Útiles

```bash
# Ver logs en tiempo real
docker-compose -f templates/development.yml logs -f

# Ver solo logs de MySQL
docker-compose -f templates/development.yml logs -f mysql

# Detener servicios
docker-compose -f templates/development.yml stop

# Iniciar servicios detenidos
docker-compose -f templates/development.yml start

# Reiniciar servicios
docker-compose -f templates/development.yml restart

# Detener y eliminar (mantiene datos en volúmenes)
docker-compose -f templates/development.yml down

# Detener y eliminar TODO incluyendo datos (⚠️ CUIDADO)
docker-compose -f templates/development.yml down -v
```

---

## 🔍 Verificar Estado

```bash
# Ver contenedores corriendo
docker ps

# Verificar logs de MySQL
docker logs mysql_dev

# Verificar logs del exporter
docker logs mysqld_exporter_dev

# Ver salud de MySQL
docker exec mysql_dev mysqladmin -u root -pdev_root_pass_123 ping
# Output esperado: mysqld is alive

# Verificar que el exporter esté funcionando
curl http://localhost:9104/metrics | grep "mysql_up"
# Output esperado: mysql_up 1

# Verificar targets de Prometheus
curl http://localhost:9090/api/v1/targets | grep mysql
# Output esperado: "health":"up"

# Ver conexiones activas en MySQL
docker exec mysql_dev mysql -u root -pdev_root_pass_123 -e "SHOW PROCESSLIST;"

# Verificar usuario exporter
docker exec mysql_dev mysql -u root -pdev_root_pass_123 -e "SELECT User, Host FROM mysql.user WHERE User='exporter';"
```

---

## 💾 Backup y Restauración

### Backup

```bash
# Backup de todas las bases de datos
docker exec mysql_dev mysqldump -u root -p --all-databases > backup_all.sql

# Backup de una base de datos específica
docker exec mysql_dev mysqldump -u root -p dev_database > backup_dev.sql

# Backup comprimido
docker exec mysql_dev mysqldump -u root -p dev_database | gzip > backup_dev.sql.gz
```

### Restauración

```bash
# Restaurar
docker exec -i mysql_dev mysql -u root -p dev_database < backup_dev.sql

# Restaurar desde comprimido
gunzip < backup_dev.sql.gz | docker exec -i mysql_dev mysql -u root -p dev_database
```

---

## 🐛 Problemas Comunes

### Puerto 3306 ya en uso

```bash
# Ver qué está usando el puerto
netstat -ano | findstr :3306  # Windows
lsof -i :3306                 # Linux/macOS

# Solución: Cambiar puerto
# Edita .env: MYSQL_PORT=3307
```

### Contenedor no inicia

```bash
# Ver logs de error
docker logs mysql_dev

# Problemas comunes:
# - Falta MYSQL_ROOT_PASSWORD
# - Volumen corrupto (eliminar y recrear)
# - Memoria insuficiente
```

### Olvidé la contraseña de root

```bash
# Detener contenedor
docker-compose -f templates/development.yml down

# Eliminar volumen (⚠️ borra datos)
docker volume rm mysql_dev_data

# Recrear
docker-compose -f templates/development.yml up -d
```

---

## 📚 Siguientes Pasos

- **Lee el [README.md](README.md)** para configuración avanzada
- **Explora [templates/README.md](templates/README.md)** para comparar plantillas
- **Consulta [STRUCTURE.md](STRUCTURE.md)** para entender la estructura
- **Configura [init-scripts](init-scripts/)** para crear tablas automáticamente
- **Personaliza [config/my.cnf](config/)** para ajustes específicos

---

## 🆘 Ayuda

¿Problemas? Consulta:
1. [README.md](README.md) - Documentación completa
2. [Troubleshooting](#-problemas-comunes) - Problemas comunes
3. Logs: `docker-compose logs -f`

---

**¡Listo para desarrollar! 🚀**
