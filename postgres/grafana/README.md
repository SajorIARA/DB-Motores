# 📊 CONFIGURACIÓN DE GRAFANA PARA POSTGRESQL

## 🚀 Acceso Rápido

**URL:** http://localhost:3000

**Credenciales por defecto:**
- Usuario: `admin`
- Password: `admin123`

⚠️ **IMPORTANTE:** Cambia la contraseña en producción editando el docker-compose.yml

---

## 📁 Estructura de Archivos

```
grafana/
├── provisioning/
│   ├── datasources/
│   │   └── prometheus.yml          # Auto-configura Prometheus como datasource
│   └── dashboards/
│       ├── dashboard-provider.yml  # Define dónde buscar dashboards
│       └── postgresql-overview.json # Dashboard principal de PostgreSQL
└── README.md
```

---

## 🎨 Dashboard Incluido: PostgreSQL - Vista General

El dashboard pre-configurado incluye:

### 📈 Paneles Principales

1. **Estado de PostgreSQL** - Indica si la BD está UP (1) o DOWN (0)
2. **Conexiones Activas** - Total de conexiones actuales
3. **Cache Hit Ratio** - Porcentaje de aciertos de caché (debe ser > 95%)
4. **Tamaño de Base de Datos** - Espacio ocupado en disco

### 📊 Gráficos de Series de Tiempo

5. **Transacciones por Segundo** - Commits vs Rollbacks
6. **Conexiones por Estado** - Active, Idle, Idle in Transaction
7. **Operaciones DML** - Inserts, Updates, Deletes por segundo
8. **Tuplas Muertas** - Indica si necesitas ejecutar VACUUM

---

## 🔧 Importar Dashboards Adicionales de la Comunidad

Grafana tiene dashboards públicos excelentes para PostgreSQL:

### 🏆 Dashboards Recomendados

1. **PostgreSQL Database by Wrouesnel** (ID: 9628)
   - Dashboard más completo para PostgreSQL
   - Compatible con postgres_exporter
   - Incluye: métricas detalladas, queries, locks, replicación

2. **PostgreSQL Overview** (ID: 455)
   - Dashboard simple y limpio
   - Ideal para monitoreo básico

3. **PostgreSQL Exporter Quickstart** (ID: 12485)
   - Específico para postgres_exporter
   - Incluye todas las métricas custom

### 📥 Cómo Importar Dashboards

#### Opción 1: Desde la Web UI
1. Ve a http://localhost:3000
2. Click en **+** → **Import**
3. Ingresa el ID del dashboard (ej: 9628)
4. Click en **Load**
5. Selecciona datasource: **Prometheus-Datasource**
6. Click en **Import**

#### Opción 2: Desde JSON File
1. Descarga el JSON del dashboard
2. Ve a **+** → **Import**
3. Sube el archivo JSON
4. Configura y guarda

---

## 🛠️ Configuración Avanzada

### Cambiar Credenciales de Admin

Edita `postgresql-docker-compose.yml`:

```yaml
grafana:
  environment:
    GF_SECURITY_ADMIN_USER: tu_usuario
    GF_SECURITY_ADMIN_PASSWORD: tu_password_segura
```

### Configurar Alertas por Email

Agrega variables de entorno a Grafana:

```yaml
grafana:
  environment:
    # SMTP Configuration
    GF_SMTP_ENABLED: "true"
    GF_SMTP_HOST: "smtp.gmail.com:587"
    GF_SMTP_USER: "tu-email@gmail.com"
    GF_SMTP_PASSWORD: "tu-app-password"
    GF_SMTP_FROM_ADDRESS: "tu-email@gmail.com"
    GF_SMTP_FROM_NAME: "Grafana PostgreSQL Alerts"
```

### Agregar Más Datasources

Crea archivos `.yml` adicionales en `grafana/provisioning/datasources/`:

```yaml
# influxdb.yml
apiVersion: 1
datasources:
  - name: InfluxDB
    type: influxdb
    url: http://influxdb:8086
    database: mydb
```

---

## 📊 Métricas Disponibles

Gracias al archivo `postgres-queries.yaml`, tienes acceso a:

### 🔧 Configuración
- `pg_settings_value` - Todos los parámetros (shared_buffers, max_connections, etc.)

### 📈 Performance
- `pg_database_stats_cache_hit_ratio` - Cache hit ratio
- `pg_database_stats_transactions_committed` - Transacciones confirmadas
- `pg_database_stats_deadlocks_count` - Deadlocks

### 🗃️ Tablas e Índices
- `pg_table_stats_sequential_scans` - Table scans (alerta si muy alto)
- `pg_table_stats_dead_tuples` - Tuplas muertas
- `pg_index_stats_index_scans` - Uso de índices

### 🔒 Locks
- `pg_locks_detail_lock_count` - Locks por tipo y modo

### 💾 Storage
- `pg_database_sizes_size_bytes` - Tamaño de bases de datos
- `pg_table_sizes_total_size_bytes` - Tamaño de tablas

### 🔄 Replicación
- `pg_replication_status_replay_lag_seconds` - Lag de réplicas

### ⚡ Background Processes
- `pg_bgwriter_checkpoints_requested` - Checkpoints forzados (alerta si alto)
- `pg_bgwriter_buffers_written_by_backends` - Backends escribiendo (alerta si alto)

---

## 🎯 Queries PromQL Útiles

### Cache Hit Ratio
```promql
pg_database_stats_cache_hit_ratio
```

### Conexiones Activas
```promql
sum(pg_connections_by_state_connection_count{state="active"})
```

### Transacciones por Segundo
```promql
rate(pg_database_stats_transactions_committed[5m])
```

### Queries Lentas (> 5 segundos)
```promql
pg_slow_queries_query_duration_seconds > 5
```

### Tablas con Más Tuplas Muertas
```promql
topk(10, pg_table_stats_dead_tuples)
```

### Índices No Usados
```promql
pg_index_stats_index_scans == 0
```

---

## 🚨 Alertas Recomendadas

### Cache Hit Ratio Bajo
```yaml
alert: LowCacheHitRatio
expr: pg_database_stats_cache_hit_ratio < 90
for: 5m
annotations:
  summary: "Cache hit ratio bajo en {{$labels.database_name}}"
  description: "Cache hit ratio: {{$value}}% (debe ser > 95%)"
```

### Demasiadas Tuplas Muertas
```yaml
alert: HighDeadTuples
expr: pg_table_stats_dead_tuple_ratio > 20
for: 10m
annotations:
  summary: "Tabla {{$labels.table_name}} necesita VACUUM"
  description: "{{$value}}% de tuplas muertas"
```

### Conexiones Cercanas al Límite
```yaml
alert: ConnectionPoolAlmostFull
expr: (sum(pg_connections_by_state_connection_count) / pg_settings_value{name="max_connections"}) > 0.8
for: 5m
annotations:
  summary: "Conexiones al 80% del límite"
```

---

## 🔍 Troubleshooting

### Grafana no muestra datos

1. **Verificar que Prometheus esté UP:**
   ```bash
   curl http://localhost:9090/-/healthy
   ```

2. **Verificar targets en Prometheus:**
   http://localhost:9090/targets
   - postgres-exporter debe estar **UP**

3. **Verificar métricas disponibles:**
   ```bash
   curl http://localhost:9187/metrics | grep pg_
   ```

4. **Revisar logs de Grafana:**
   ```bash
   docker logs grafana
   ```

### Dashboard no carga

1. Verifica que el datasource esté configurado:
   - Grafana → Configuration → Data Sources → Prometheus
   - Debe estar en **http://prometheus:9090**

2. Prueba la conexión del datasource:
   - Click en **Save & Test**
   - Debe mostrar "Data source is working"

### Paneles vacíos

1. Verifica el rango de tiempo (arriba derecha)
2. Cambia a "Last 15 minutes" o "Last 1 hour"
3. Verifica que haya datos en Prometheus:
   ```bash
   curl 'http://localhost:9090/api/v1/query?query=pg_up'
   ```

---

## 📚 Recursos Adicionales

- **Grafana Docs:** https://grafana.com/docs/
- **Prometheus Docs:** https://prometheus.io/docs/
- **postgres_exporter:** https://github.com/prometheus-community/postgres_exporter
- **Dashboards Públicos:** https://grafana.com/grafana/dashboards/
- **PromQL Cheat Sheet:** https://promlabs.com/promql-cheat-sheet/

---

## 🎉 Listo para Usar

1. Levanta el stack: `docker-compose up -d`
2. Accede a Grafana: http://localhost:3000
3. Login: admin / admin123
4. El dashboard "PostgreSQL - Vista General" ya está disponible
5. Importa dashboards adicionales según tus necesidades

**¡Disfruta monitoreando tu PostgreSQL! 🚀**
