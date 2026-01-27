# CONFIGURACIÓN DE VOLÚMENES POR AMBIENTE

## 📊 RESUMEN DE CONFIGURACIÓN

| Ambiente | Grafana Storage | Ubicación | Persistencia | Puerto |
|----------|----------------|-----------|--------------|--------|
| **Development** | Docker Volume | `grafana_development_data` | ✅ Sí | :3000 |
| **Testing** | tmpfs (Memoria) | `/var/lib/grafana` | ❌ No | :3001 |
| **Production** | Bind Mount | `./data/grafana/production` | ✅ Sí | :3002 |
| **Analytics** | Bind Mount | `./data/grafana/analytics` | ✅ Sí | :3003 |

---

## 🔧 DETALLES POR AMBIENTE

### 1️⃣ DEVELOPMENT (Volumen Docker)
```yaml
volumes:
  - grafana_development_data:/var/lib/grafana  # ← Named volume
  - ../grafana/provisioning:/etc/grafana/provisioning:ro
```
**Características:**
- ✅ Datos persisten entre reinicios
- ✅ Gestión automática por Docker
- ✅ No requiere permisos especiales
- ⚠️ Los datos están en carpeta de Docker

**Acceso:** http://localhost:3000 (admin/admin)

---

### 2️⃣ TESTING (tmpfs - Memoria)
```yaml
volumes:
  - ../grafana/provisioning:/etc/grafana/provisioning:ro

tmpfs:
  - /var/lib/grafana  # ← En memoria RAM
```
**Características:**
- ❌ Datos NO persisten (se borran al detener)
- ⚡ Ultra rápido (todo en RAM)
- 💾 No ocupa espacio en disco
- ✅ Ideal para CI/CD y pruebas

**Acceso:** http://localhost:3001 (admin/admin)

---

### 3️⃣ PRODUCTION (Bind Mount - Físico)
```yaml
volumes:
  - ../data/grafana/production:/var/lib/grafana  # ← Carpeta física
  - ../grafana/provisioning:/etc/grafana/provisioning:ro
```
**Características:**
- ✅ Datos persisten en carpeta física
- 📁 Acceso directo a archivos
- 💾 Fácil backup/restauración
- ⚠️ Requiere permisos correctos

**Ubicación:** `d:\DB-Motores\postgres\data\grafana\production`
**Acceso:** http://localhost:3002 (credenciales vía env)

---

### 4️⃣ ANALYTICS (Bind Mount - Físico)
```yaml
volumes:
  - ../data/grafana/analytics:/var/lib/grafana  # ← Carpeta física
  - ../grafana/provisioning:/etc/grafana/provisioning:ro
```
**Características:**
- ✅ Datos persisten en carpeta física
- 📁 Acceso directo a archivos
- 💾 Fácil backup/restauración
- ⚠️ Requiere permisos correctos

**Ubicación:** `d:\DB-Motores\postgres\data\grafana\analytics`
**Acceso:** http://localhost:3003 (admin/analytics_admin_789)

---

## 🚀 INICIAR AMBIENTES

### Development (Docker Volume)
```powershell
docker-compose -f templates/development.yml up -d
# Acceder: http://localhost:3000
```

### Testing (tmpfs)
```powershell
docker-compose -f templates/testing.yml up -d
# Acceder: http://localhost:3001
# ⚠️ Los dashboards configurados se perderán al detener
```

### Production (Bind Mount)
```powershell
# Crear directorio si no existe
New-Item -ItemType Directory -Path "data\grafana\production" -Force

docker-compose -f templates/production.yml up -d
# Acceder: http://localhost:3002
```

### Analytics (Bind Mount)
```powershell
# Crear directorio si no existe
New-Item -ItemType Directory -Path "data\grafana\analytics" -Force

docker-compose -f templates/analytics.yml up -d
# Acceder: http://localhost:3003
```

---

## 🔒 DASHBOARDS Y BASE DE DATOS INTERNA

### ✅ CONFIGURACIÓN APLICADA

Para **TODOS** los ambientes, los dashboards están configurados como **READ-ONLY**:

**Archivo:** `grafana/provisioning/dashboards/dashboard-provider.yml`
```yaml
allowUiUpdates: false       # ← Dashboards de solo lectura
disableDeletion: true        # ← No se pueden borrar
updateIntervalSeconds: 5     # ← Recarga rápida desde archivos
```

### 📋 COMPORTAMIENTO

| Acción | Resultado |
|--------|-----------|
| Modificar dashboard desde UI | ❌ **BLOQUEADO** - Solo lectura |
| Borrar dashboard desde UI | ❌ **BLOQUEADO** - Protegido |
| Crear nuevo dashboard | ✅ **PERMITIDO** - Se guarda en DB interna |
| Modificar dashboard JSON | ✅ **EFECTIVO** - Recarga automática |

### 🎯 IMPLICACIONES

1. **Dashboards Provisionados** (los 6 JSON files):
   - ✅ Siempre cargan desde archivos
   - ✅ No se corrompen entre ambientes
   - ✅ Mismo comportamiento en todos los puertos
   - ⚠️ NO se pueden modificar desde UI

2. **Dashboards Creados Manualmente**:
   - ✅ Se guardan en la DB interna de Grafana
   - ✅ Persisten según el tipo de volumen:
     - **Development**: Persisten (Docker volume)
     - **Testing**: Se pierden (tmpfs)
     - **Production**: Persisten (bind mount)
     - **Analytics**: Persisten (bind mount)

3. **Para Modificar Dashboards**:
   - Editar el archivo JSON directamente
   - Guardar cambios
   - Grafana recarga automáticamente en 5 segundos

---

## 📁 ESTRUCTURA DE CARPETAS

```
postgres/
├── data/
│   └── grafana/
│       ├── analytics/        ← Analytics (físico)
│       └── production/       ← Production (físico)
│
├── grafana/
│   └── provisioning/
│       ├── dashboards/
│       │   ├── dashboard-provider.yml  ← allowUiUpdates: false
│       │   ├── postgresql-overview.json
│       │   ├── postgresql-performance-io.json
│       │   ├── postgresql-queries-locks.json
│       │   ├── postgresql-tables-indexes.json
│       │   ├── postgresql-config.json
│       │   └── postgresql-checkpoints.json
│       └── datasources/
│           └── prometheus-datasource.yml
│
└── templates/
    ├── development.yml  → grafana_development_data (Docker)
    ├── testing.yml      → tmpfs (Memoria)
    ├── production.yml   → ./data/grafana/production (Físico)
    └── analytics.yml    → ./data/grafana/analytics (Físico)
```

---

## 🔄 BACKUP Y RESTAURACIÓN

### Development (Docker Volume)
```powershell
# Backup
docker run --rm -v templates_grafana_development_data:/data -v ${PWD}/backups:/backup alpine tar czf /backup/grafana-dev-backup.tar.gz -C /data .

# Restore
docker run --rm -v templates_grafana_development_data:/data -v ${PWD}/backups:/backup alpine tar xzf /backup/grafana-dev-backup.tar.gz -C /data
```

### Testing (tmpfs)
❌ No aplica - Los datos no persisten

### Production/Analytics (Bind Mount)
```powershell
# Backup (simple copy)
Copy-Item -Recurse "data\grafana\production" "backups\grafana-production-$(Get-Date -Format 'yyyyMMdd')"

# Restore
Copy-Item -Recurse "backups\grafana-production-20260114\*" "data\grafana\production"
```

---

## ⚠️ NOTAS IMPORTANTES

1. **Permisos en Bind Mounts:**
   - Windows: Generalmente no hay problemas
   - Linux: `chown -R 472:472 data/grafana/production` (UID de Grafana)

2. **Dashboards No Aparecen:**
   - Verificar `allowUiUpdates: false` en dashboard-provider.yml
   - Reiniciar Grafana: `docker restart grafana_[ambiente]`
   - Esperar 5-10 segundos para provisioning

3. **Dropdown Vacío:**
   - Verificar que Prometheus esté corriendo
   - Verificar datasource: http://localhost:3000/connections/datasources
   - Comprobar métricas: http://localhost:9090/api/v1/label/datname/values

4. **Multiple Ambientes Simultáneos:**
   - ✅ Puedes correr todos a la vez (puertos diferentes)
   - Cada uno tiene su propia instancia de Grafana
   - No hay conflictos entre ambientes
