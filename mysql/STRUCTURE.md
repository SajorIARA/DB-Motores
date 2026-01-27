# 📂 Estructura del Proyecto MySQL

```
mysql/
│
├── 📄 README.md                          # Documentación principal
├── 📄 QUICK-START.md                     # Guía rápida (5 minutos)
├── 📄 .gitignore                         # Ignorar .env y datos locales
│
├── 📂 templates/                         # ⭐ PLANTILLAS DOCKER COMPOSE
│   ├── 📄 README.md                      # Documentación de plantillas
│   ├── 📄 .env.example                   # Variables de entorno
│   ├── 📄 base.yml                       # Plantilla base original
│   ├── 📄 development.yml                # Desarrollo (512MB-1GB RAM)
│   ├── 📄 production.yml                 # Producción (4GB-8GB RAM)
│   ├── 📄 testing.yml                    # CI/CD (256MB-512MB RAM)
│   └── 📄 analytics.yml                  # Data Warehouse (2GB-4GB RAM)
│
├── 📂 grafana/                           # Configuración de Grafana
│   ├── 📄 README.md                      # Guía de dashboards
│   └── 📂 provisioning/
│       ├── 📂 datasources/
│       │   └── prometheus.yml            # Auto-configura Prometheus
│       └── 📂 dashboards/
│           ├── dashboard-provider.yml
│           └── mysql-*.json              # 5 dashboards incluidos
│
├── 📂 config/                            # Configuración avanzada de MySQL
│   ├── 📄 README.md                      # Guía de configuración
│   └── my.cnf.example                    # Ejemplo de configuración
│
├── 📂 init-scripts/                      # Scripts de inicialización
│   ├── 📄 README.md                      # Guía de scripts
│   ├── 01-init.sql.example               # Crear esquemas y tablas
│   ├── 02-functions.sql.example          # Funciones y procedures
│   └── 03-setup.sh.example               # Script bash de setup
│
├── 📄 prometheus.yml                     # Configuración de Prometheus
└── 📄 STRUCTURE.md                       # Este archivo
```

---

## 📖 Descripción de Archivos

### 📄 Archivos Raíz

#### README.md
Documentación completa del proyecto MySQL con monitoreo.

#### QUICK-START.md
Guía ultra-rápida para empezar en 5 minutos.

#### .gitignore
Previene commitear archivos sensibles: `.env`, datos, logs, secrets.

---

### 📂 templates/ - Plantillas Docker Compose

#### development.yml
**Desarrollo local:**
- 128MB buffer pool
- 50 conexiones
- Logging completo
- Red: `mysql_dev_network`

#### production.yml
**Producción:**
- 2GB buffer pool
- 500 conexiones
- Optimizado para SSD
- Seguridad reforzada
- Red: `mysql_prod_network`

#### testing.yml
**CI/CD:**
- 64MB buffer pool
- 20 conexiones
- Sin persistencia (tmpfs)
- Red: `mysql_test_network`

#### analytics.yml
**Data Warehouse:**
- 1GB buffer pool
- 100 conexiones
- Buffers grandes para JOINs
- Timeouts largos
- Red: `mysql_analytics_network`

---

### 📂 grafana/ - Visualización

#### 5 Dashboards Incluidos:
1. **mysql-overview.json** - Vista general
2. **mysql-config.json** - Configuración del servidor
3. **mysql-queries.json** - Queries y performance
4. **mysql-tables.json** - Tablas e índices
5. **mysql-innodb.json** - InnoDB e I/O

---

### 📂 config/ - Configuración Avanzada

#### my.cnf.example
Archivo de configuración completo de MySQL con parámetros comentados.

---

### 📂 init-scripts/ - Inicialización

Scripts que se ejecutan al crear el contenedor por primera vez.

**Orden:** Alfabético (por eso los prefijos 01-, 02-, 03-)

---

## 🎯 Flujos de Uso

### Desarrollo Local
```bash
1. cd mysql
2. docker-compose -f templates/development.yml up -d
3. Acceder: localhost:3306
4. Grafana: localhost:3000
```

### Producción
```bash
1. cp templates/.env.example .env
2. Editar .env con credenciales seguras
3. docker-compose -f templates/production.yml --env-file .env up -d
4. Configurar backups y alertas
```

### CI/CD
```bash
1. En pipeline: docker-compose -f templates/testing.yml up -d
2. Ejecutar tests
3. docker-compose -f templates/testing.yml down -v
```

---

**Última actualización:** 2026-01-12
