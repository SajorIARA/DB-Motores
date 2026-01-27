# 📊 CONFIGURACIÓN DE GRAFANA PARA MYSQL

## 🚀 Acceso Rápido

**URL:** http://localhost:3000

**Credenciales por defecto:**
- Usuario: `admin`
- Password: Ver la plantilla que estés usando

⚠️ **IMPORTANTE:** Cambia la contraseña en producción editando el archivo .env

---

## 📁 Estructura de Archivos

```
grafana/
├── provisioning/
│   ├── datasources/
│   │   └── prometheus.yml          # Auto-configura Prometheus como datasource
│   └── dashboards/
│       ├── dashboard-provider.yml  # Define dónde buscar dashboards
│       └── mysql-*.json            # Dashboards de MySQL
└── README.md
```

---

## 🎨 Dashboards Incluidos

### 1. MySQL Overview (Vista General)
Métricas clave para monitoreo general:
- **Estado de MySQL** - UP/DOWN y uptime
- **Conexiones activas** - Threads conectados y disponibles
- **Queries por segundo (QPS)** - SELECT, INSERT, UPDATE, DELETE
- **Operaciones DML** - Tasa de operaciones
- **Throughput y latencia** - Rendimiento general
- **Tamaño de bases de datos** - Espacio ocupado

### 2. MySQL Connections (Conexiones)
Análisis de conexiones:
- **Conexiones activas vs máximo** - Uso de conexiones
- **Threads** - Conectados, corriendo, cacheados
- **Ratio de abortadas** - Conexiones fallidas
- **Historial de conexiones** - Timeline de uso
- **Estados de threads** - Distribución por estado

### 3. MySQL InnoDB (Motor de Almacenamiento)
Métricas del motor InnoDB:
- **Buffer pool** - Utilization y hit ratio
- **I/O de disco vs caché** - Eficiencia de memoria
- **Log files** - Writes, waits, checkpoints
- **Row operations** - Reads, inserts, updates, deletes
- **Lock waits y deadlocks** - Problemas de concurrencia

### 4. MySQL Query Performance (Rendimiento de Queries)
Análisis de rendimiento de queries:
- **Queries lentas** - Slow queries log
- **Queries ejecutándose** - Procesos activos
- **Sorts y joins sin índices** - Optimizaciones necesarias
- **Full table scans** - Tablas sin índices adecuados
- **Query cache hit ratio** - Eficiencia de caché (si está habilitado)

### 5. MySQL System Metrics (Métricas del Sistema)
Métricas de recursos del sistema:
- **CPU y memoria** - Uso del contenedor
- **Disk I/O** - Lecturas y escrituras
- **Network traffic** - Throughput de red
- **Top tablas/índices** - Recursos más usados

---

## 🏆 Dashboards Recomendados de la Comunidad

Grafana tiene dashboards públicos excelentes para MySQL:

### Dashboard ID: 7362 - MySQL Overview
- **Autor:** Percona
- **Descripción:** Dashboard completo y detallado para MySQL
- **Compatible con:** mysqld_exporter
- **Características:** 
  - Métricas detalladas de InnoDB
  - Query performance
  - Replication lag
  - Connection stats

### Dashboard ID: 14057 - MySQL InnoDB Metrics
- **Autor:** Community
- **Descripción:** Enfocado en métricas de InnoDB
- **Incluye:** Buffer pool, transactions, locks, I/O

### Dashboard ID: 6239 - MySQL Exporter Quickstart
- **Autor:** Community
- **Descripción:** Dashboard simple y efectivo
- **Ideal para:** Comenzar rápidamente

---

## 📥 Cómo Importar Dashboards

### Opción 1: Desde la Web UI (Recomendado)

1. Ve a http://localhost:3000
2. Click en **+** → **Import** (o **Dashboards** → **Import**)
3. Ingresa el ID del dashboard (ej: `7362`)
4. Click en **Load**
5. Selecciona datasource: **Prometheus-Datasouce**
6. Click en **Import**

### Opción 2: Desde JSON File

1. Descarga el JSON del dashboard desde [Grafana.com](https://grafana.com/grafana/dashboards/)
2. Ve a **+** → **Import**
3. Click en **Upload JSON file**
4. Sube el archivo descargado
5. Configura datasource y opciones
6. Click en **Import**

### Opción 3: Desde URL

1. Ve a **+** → **Import**
2. Pega la URL del dashboard JSON
3. Click en **Load**
4. Configura y importa

---

## 🛠️ Configuración Avanzada

### Cambiar Credenciales de Admin

#### Método 1: Variables de entorno (.env)
```bash
GF_ADMIN_USER=tu_usuario
GF_ADMIN_PASSWORD=tu_password_segura
```

#### Método 2: En docker-compose.yml
```yaml
grafana:
  environment:
    GF_SECURITY_ADMIN_USER: tu_usuario
    GF_SECURITY_ADMIN_PASSWORD: tu_password_segura
```

### Configurar Alertas por Email

Edita el docker-compose.yml:

```yaml
grafana:
  environment:
    # SMTP Configuration
    GF_SMTP_ENABLED: true
    GF_SMTP_HOST: smtp.gmail.com:587
    GF_SMTP_USER: tu-email@gmail.com
    GF_SMTP_PASSWORD: tu-password-app
    GF_SMTP_FROM_ADDRESS: tu-email@gmail.com
    GF_SMTP_FROM_NAME: Grafana MySQL Monitor
```

### Habilitar Autenticación OAuth (Google, GitHub, etc.)

```yaml
grafana:
  environment:
    # Google OAuth
    GF_AUTH_GOOGLE_ENABLED: true
    GF_AUTH_GOOGLE_CLIENT_ID: tu-client-id
    GF_AUTH_GOOGLE_CLIENT_SECRET: tu-client-secret
    GF_AUTH_GOOGLE_ALLOWED_DOMAINS: tu-dominio.com
```

### Instalar Plugins Adicionales

```yaml
grafana:
  environment:
    GF_INSTALL_PLUGINS: >
      grafana-clock-panel,
      grafana-simple-json-datasource,
      grafana-piechart-panel,
      grafana-worldmap-panel
```

---

## 📊 Crear Alertas

### Ejemplo: Alerta de Conexiones Altas

1. Abre un dashboard
2. Edita el panel de "Conexiones Activas"
3. Ve a pestaña **Alert**
4. Click en **Create Alert**
5. Configura condición:
   ```
   WHEN avg() OF query(A, 5m, now) IS ABOVE 400
   ```
6. Configura notificación
7. Guarda

### Ejemplo: Alerta de MySQL Down

```
WHEN avg() OF query(mysql_up) IS BELOW 1
```

---

## 🔍 Queries Útiles de Prometheus

Puedes usar estas queries en Grafana Explorer o crear paneles custom:

### Conexiones
```promql
# Conexiones activas
mysql_global_status_threads_connected

# Conexiones máximas
mysql_global_variables_max_connections

# Porcentaje de uso
(mysql_global_status_threads_connected / mysql_global_variables_max_connections) * 100
```

### Queries
```promql
# Queries por segundo
rate(mysql_global_status_queries[5m])

# SELECTs por segundo
rate(mysql_global_status_commands_total{command="select"}[5m])

# Queries lentas por segundo
rate(mysql_global_status_slow_queries[5m])
```

### InnoDB Buffer Pool
```promql
# Hit ratio del buffer pool
(1 - (mysql_global_status_innodb_buffer_pool_reads / mysql_global_status_innodb_buffer_pool_read_requests)) * 100

# Páginas dirty
mysql_global_status_innodb_buffer_pool_pages{state="dirty"}

# Uso del buffer pool (bytes)
mysql_global_status_innodb_buffer_pool_bytes_data
```

### Replicación
```promql
# Lag de replicación (segundos)
mysql_slave_status_seconds_behind_master

# Estado de replicación
mysql_slave_status_slave_io_running
mysql_slave_status_slave_sql_running
```

---

## 🐛 Troubleshooting

### Grafana no muestra datos

1. **Verificar que Prometheus está UP:**
   ```bash
   curl http://localhost:9090/-/healthy
   ```

2. **Verificar targets en Prometheus:**
   - Ir a: http://localhost:9090/targets
   - `mysqld-exporter` debe estar UP (verde)

3. **Verificar métricas del exporter:**
   ```bash
   curl http://localhost:9104/metrics | grep mysql_up
   ```

4. **Verificar datasource en Grafana:**
   - Configuration → Data Sources → Prometheus
   - Click en **Test** - debe decir "Data source is working"

### Paneles muestran "N/A" o "No data"

- **Causa:** Query incorrecta o métricas no disponibles
- **Solución:** 
  1. Verifica que mysqld_exporter tenga los collectors habilitados
  2. Revisa la query en "Edit panel" → "Query Inspector"
  3. Prueba la query directamente en Prometheus

### Dashboard importado no funciona

- **Causa:** Nombre de datasource incorrecto
- **Solución:**
  1. Edita el dashboard
  2. Dashboard settings → Variables
  3. Cambia `DS_PROMETHEUS` a `Prometheus`
  4. Guarda

---

## 📚 Recursos

- **Grafana Dashboards:** https://grafana.com/grafana/dashboards/?search=mysql
- **Grafana Docs:** https://grafana.com/docs/
- **Prometheus MySQL Exporter:** https://github.com/prometheus/mysqld_exporter
- **PromQL Basics:** https://prometheus.io/docs/prometheus/latest/querying/basics/

---

**Última actualización:** Enero 2026
