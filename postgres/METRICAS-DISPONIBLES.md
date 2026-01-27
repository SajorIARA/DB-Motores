# 📊 Métricas Disponibles - PostgreSQL + Prometheus

Este documento lista todas las métricas disponibles en el sistema de monitoreo.

---

## 📋 Tabla de Contenidos

1. [Métricas por Defecto del Exporter](#métricas-por-defecto-del-exporter)
2. [Métricas Personalizadas](#métricas-personalizadas)
3. [Queries PromQL Útiles](#queries-promql-útiles)
4. [Alertas Recomendadas](#alertas-recomendadas)

---

## 🔵 Métricas por Defecto del Exporter

El postgres_exporter proporciona **más de 300 métricas** automáticamente:

### 1. **Conexiones y Actividad** (`pg_stat_activity`)
```promql
# Conexiones activas totales
pg_stat_activity_count

# Conexiones por estado
pg_stat_activity_count{state="active"}
pg_stat_activity_count{state="idle"}
pg_stat_activity_count{state="idle in transaction"}

# Conexiones por base de datos
pg_stat_activity_count{datname="production_db"}
```

### 2. **Transacciones y Rendimiento** (`pg_stat_database`)
```promql
# Transacciones por segundo
rate(pg_stat_database_xact_commit[1m])
rate(pg_stat_database_xact_rollback[1m])

# Bloques leídos del cache vs disco
rate(pg_stat_database_blks_hit[1m])
rate(pg_stat_database_blks_read[1m])

# Cache hit ratio (%)
pg_stat_database_blks_hit / (pg_stat_database_blks_hit + pg_stat_database_blks_read) * 100

# Tuplas insertadas/actualizadas/eliminadas
rate(pg_stat_database_tup_inserted[1m])
rate(pg_stat_database_tup_updated[1m])
rate(pg_stat_database_tup_deleted[1m])
rate(pg_stat_database_tup_returned[1m])
```

### 3. **Checkpoints** (`pg_stat_checkpointer`)
```promql
# Checkpoints programados vs solicitados
rate(pg_checkpointer_checkpoints_scheduled[5m])
rate(pg_checkpointer_checkpoints_requested[5m])

# Tiempo de checkpoints
rate(pg_checkpointer_write_time_ms[5m])
rate(pg_checkpointer_sync_time_ms[5m])

# Buffers escritos
rate(pg_checkpointer_buffers_written[5m])
```

### 4. **Background Writer** (`pg_stat_bgwriter`)
```promql
# Buffers escritos por background writer
rate(pg_stat_bgwriter_buffers_clean[1m])

# Buffers escritos por backends
rate(pg_stat_bgwriter_buffers_backend[1m])

# Buffers allocados
rate(pg_stat_bgwriter_buffers_alloc[1m])
```

### 5. **Configuración** (`pg_settings`)
```promql
# Shared buffers (bytes)
pg_settings_shared_buffers_bytes

# Max connections
pg_settings_max_connections

# Work memory (bytes)
pg_settings_work_mem_bytes

# Effective cache size (bytes)
pg_settings_effective_cache_size_bytes
```

### 6. **Tamaños de Base de Datos**
```promql
# Tamaño total de la base de datos
pg_database_size_bytes{datname="production_db"}

# Convertir a GB
pg_database_size_bytes / 1024 / 1024 / 1024
```

### 7. **Replicación** (`pg_stat_replication`)
```promql
# Lag de replicación
pg_replication_lag_seconds

# Estado de réplicas
pg_stat_replication_state
```

---

## 🟣 Métricas Personalizadas

Definidas en [`config/queries/postgres-queries.yaml`](config/queries/postgres-queries.yaml)

### 1. **Conexiones por Estado**
```promql
# Conexiones agrupadas por estado
pg_connections_by_state{state="active"}
pg_connections_by_state{state="idle"}
pg_connections_by_state{state="idle in transaction"}
```

### 2. **Queries Lentas**
```promql
# Queries activas por más de 5 segundos
pg_slow_queries{state="active"}
```

### 3. **Tamaño de Tablas**
```promql
# Tablas más grandes
topk(10, pg_table_sizes_total_size_bytes)

# Convertir a GB
pg_table_sizes_total_size_bytes{schema_name="public"} / 1024 / 1024 / 1024
```

### 4. **Estadísticas de Tablas**
```promql
# Sequential scans (alto = posible falta de índice)
pg_table_stats_sequential_scans

# Index scans
pg_table_stats_index_scans

# Dead tuples (necesitan VACUUM)
pg_table_stats_dead_tuples

# Ratio de tuplas muertas (alerta si > 20%)
pg_table_stats_dead_tuple_ratio
```

### 5. **Índices No Utilizados**
```promql
# Índices nunca usados
pg_unused_indexes{index_scans="0"}

# Tamaño de índices no usados
sum(pg_unused_indexes_index_size_bytes{index_scans="0"})
```

### 6. **Locks y Bloqueos**
```promql
# Total de locks
sum(pg_locks_active_lock_count)

# Locks por tipo
pg_locks_active_lock_count{locktype="relation"}
pg_locks_active_lock_count{locktype="tuple"}

# Locks no concedidos (esperando)
pg_locks_active_lock_count{granted="false"}
```

### 7. **Progreso de VACUUM**
```promql
# Porcentaje de progreso
pg_vacuum_progress_progress_percent

# Bloques escaneados vs totales
pg_vacuum_progress_scanned_blocks / pg_vacuum_progress_total_blocks * 100
```

---

## 💡 Queries PromQL Útiles

### Performance General

#### Cache Hit Ratio (debe ser > 99%)
```promql
sum(rate(pg_stat_database_blks_hit[5m])) / 
(sum(rate(pg_stat_database_blks_hit[5m])) + sum(rate(pg_stat_database_blks_read[5m]))) * 100
```

#### Transacciones por Segundo (TPS)
```promql
sum(rate(pg_stat_database_xact_commit[1m])) + sum(rate(pg_stat_database_xact_rollback[1m]))
```

#### Queries por Segundo
```promql
sum(rate(pg_stat_database_tup_returned[1m]))
```

### Conexiones

#### Uso de Conexiones (%)
```promql
sum(pg_stat_activity_count) / pg_settings_max_connections * 100
```

#### Conexiones por Base de Datos
```promql
sum(pg_stat_activity_count) by (datname)
```

### I/O y Disco

#### Bloques Leídos del Disco (debe ser bajo)
```promql
rate(pg_stat_database_blks_read[5m])
```

#### Escrituras WAL por Segundo
```promql
rate(pg_stat_wal_wal_write[1m])
```

### Checkpoints

#### Ratio de Checkpoints Solicitados (debe ser bajo)
```promql
rate(pg_checkpointer_checkpoints_requested[5m]) / 
(rate(pg_checkpointer_checkpoints_requested[5m]) + rate(pg_checkpointer_checkpoints_scheduled[5m])) * 100
```

### Tablas

#### Top 10 Tablas más Grandes
```promql
topk(10, pg_table_sizes_total_size_bytes)
```

#### Tablas con Más Tuplas Muertas
```promql
topk(10, pg_table_stats_dead_tuples)
```

#### Tablas con Sequential Scans (posible falta de índice)
```promql
topk(10, rate(pg_table_stats_sequential_scans[5m]))
```

---

## 🚨 Alertas Recomendadas

### Alerta: Cache Hit Ratio Bajo
```yaml
- alert: PostgresCacheHitRatioLow
  expr: |
    (
      sum(rate(pg_stat_database_blks_hit[5m])) / 
      (sum(rate(pg_stat_database_blks_hit[5m])) + sum(rate(pg_stat_database_blks_read[5m])))
    ) * 100 < 90
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Cache hit ratio bajo (< 90%)"
    description: "El cache hit ratio es {{ $value }}%. Considera aumentar shared_buffers."
```

### Alerta: Conexiones Altas
```yaml
- alert: PostgresConnectionsHigh
  expr: |
    sum(pg_stat_activity_count) / pg_settings_max_connections * 100 > 80
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Uso de conexiones alto (> 80%)"
    description: "{{ $value }}% de las conexiones están en uso."
```

### Alerta: Checkpoints Frecuentes
```yaml
- alert: PostgresCheckpointsTooFrequent
  expr: |
    rate(pg_checkpointer_checkpoints_requested[5m]) / 
    (rate(pg_checkpointer_checkpoints_requested[5m]) + rate(pg_checkpointer_checkpoints_scheduled[5m])) 
    * 100 > 50
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "Demasiados checkpoints solicitados (> 50%)"
    description: "Considera aumentar max_wal_size o checkpoint_timeout."
```

### Alerta: Dead Tuples Alto
```yaml
- alert: PostgresDeadTuplesHigh
  expr: |
    pg_table_stats_dead_tuple_ratio > 20
  for: 15m
  labels:
    severity: warning
  annotations:
    summary: "Tabla {{ $labels.table_name }} tiene muchas tuplas muertas"
    description: "{{ $value }}% de tuplas muertas. Ejecutar VACUUM."
```

### Alerta: Query Lenta
```yaml
- alert: PostgresSlowQuery
  expr: |
    pg_slow_queries > 0
  for: 2m
  labels:
    severity: info
  annotations:
    summary: "Query lenta detectada"
    description: "Query en {{ $labels.database_name }} por {{ $labels.username }} lleva más de 5 segundos."
```

### Alerta: Locks Esperando
```yaml
- alert: PostgresLocksWaiting
  expr: |
    pg_locks_active_lock_count{granted="false"} > 5
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Locks esperando (> 5)"
    description: "Hay {{ $value }} locks esperando en {{ $labels.database_name }}."
```

### Alerta: Espacio en Disco
```yaml
- alert: PostgresDatabaseSizeGrowing
  expr: |
    rate(pg_database_size_bytes[1h]) > 1073741824  # 1GB/hora
  for: 1h
  labels:
    severity: info
  annotations:
    summary: "Base de datos creciendo rápido"
    description: "{{ $labels.datname }} está creciendo a {{ $value | humanize }}B/s."
```

---

## 🔍 Verificar Métricas Disponibles

### Ver Todas las Métricas

```powershell
# Ver todas las métricas del exporter
curl http://localhost:9187/metrics

# Filtrar solo métricas de PostgreSQL
curl http://localhost:9187/metrics | Select-String "^pg_"

# Ver métricas específicas
curl http://localhost:9187/metrics | Select-String "pg_stat_database"
```

### Probar en Prometheus

1. Abrir http://localhost:9090
2. Ir a **Graph**
3. Escribir la métrica en el campo de query
4. Click en **Execute**

### Ver en Grafana

1. Abrir http://localhost:3000
2. Ir a **Explore**
3. Seleccionar datasource **Prometheus**
4. Escribir la query PromQL
5. Click en **Run Query**

---

## 📚 Referencias

- [PostgreSQL Statistics Collector](https://www.postgresql.org/docs/17/monitoring-stats.html)
- [postgres_exporter](https://github.com/prometheus-community/postgres_exporter)
- [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana PromQL Cheat Sheet](https://grafana.com/docs/grafana/latest/basics/promql/)

---

**¡Explora las métricas y crea tus propios dashboards personalizados! 📊**
