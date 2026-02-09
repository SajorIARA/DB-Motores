# 🗄️ DB-Motores

**Colección de Configuraciones Docker para Motores de Bases de Datos**

Repositorio con configuraciones Docker Compose listas para usar de diferentes motores de bases de datos. Cada motor incluye documentación completa, plantillas para diferentes entornos y mejores prácticas.

---

## 📋 Contenido

- [¿Qué encontrarás aquí?](#qué-encontrarás-aquí)
- [Entendiendo Docker y Docker Compose](#-entendiendo-docker-y-docker-compose)
  - [¿Qué es Docker?](#qué-es-docker)
  - [Conceptos Fundamentales](#conceptos-fundamentales-de-docker)
  - [¿Qué es Docker Compose?](#qué-es-docker-compose)
  - [Anatomía de un Archivo Docker Compose](#anatomía-de-un-archivo-docker-compose)
- [Motores Disponibles](#motores-disponibles)
- [Inicio Rápido](#inicio-rápido)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Requisitos](#requisitos)
- [Guía de Uso](#guía-de-uso)
- [Contribuir](#contribuir)

---

## ¿Qué encontrarás aquí?

Este repositorio proporciona:

- ✅ **Configuraciones Docker Compose** listas para usar
- ✅ **Múltiples plantillas** por motor (desarrollo, producción, testing, etc.)
- ✅ **Documentación completa** de cada motor
- ✅ **Variables de entorno** documentadas
- ✅ **Scripts de inicialización** y configuraciones personalizadas
- ✅ **Monitoreo integrado** (cuando aplica)
- ✅ **Mejores prácticas** por motor y entorno

### Casos de uso

- Desarrollo local de aplicaciones
- Ambientes de testing/CI-CD
- Prototipos y POCs
- Aprendizaje y experimentación
- Referencias para configuraciones de producción

---

## 🐋 Entendiendo Docker y Docker Compose

### ¿Qué es Docker?

**Docker** es una plataforma de **contenedorización** que permite empaquetar aplicaciones junto con todas sus dependencias (bibliotecas, configuraciones, archivos) en unidades portables llamadas **contenedores**.

#### 🏠 Analogía: La Casa Prefabricada

Imagina que una aplicación es como una casa:

- **Método tradicional (sin Docker):** 
  - Construyes la casa en tu terreno
  - Usas materiales locales
  - Si quieres otra casa igual, tienes que reconstruirla desde cero
  - Si cambias de terreno, puede que no funcione igual (diferentes cimientos, clima, etc.)

- **Con Docker:**
  - La casa viene **prefabricada y completa**
  - Incluye todo: paredes, techo, muebles, instalaciones
  - Puedes colocarla en cualquier terreno (servidor)
  - Es **idéntica** sin importar dónde la pongas
  - Si quieres otra, simplemente traes otra casa prefabricada

**En términos técnicos:**
- Tu aplicación y sus dependencias están empaquetadas
- Se ejecuta igual en tu laptop, en un servidor, o en la nube
- No más "en mi máquina funciona" 🎯

### Conceptos Fundamentales de Docker

#### 1. 📦 Imagen (Image)

**Qué es:** Una plantilla de solo lectura que contiene todo lo necesario para ejecutar una aplicación.

**Analogía:** Es como el **plano arquitectónico** de una casa o una **receta de cocina**. No es la casa ni la comida, es la *instrucción* de cómo construirla.

**Contiene:**
- Sistema operativo base (Alpine, Debian, Ubuntu, etc.)
- La aplicación (PostgreSQL, MySQL, etc.)
- Dependencias y librerías
- Archivos de configuración por defecto
- Scripts de inicio

**Ejemplo:**
```
   postgres:17-alpine
    └─┬──┘ └┬┘ └──┬──┘
      │     │     └── Variante (Alpine Linux = más ligera)
      │     └──────── Versión específica
      └────────────── Nombre de la imagen
```

**Dónde viven:** En registros como [Docker Hub](https://hub.docker.com/), donde millones de imágenes están disponibles públicamente.

#### 2. 📦→🏃 Contenedor (Container)

**Qué es:** Una **instancia en ejecución** de una imagen. Es la aplicación corriendo de verdad.

**Analogía:** Si la imagen es el plano, el contenedor es la **casa construida y habitada**.

**Características:**
- ✅ **Aislado** - No interfiere con otros contenedores ni con tu sistema
- ✅ **Efímero** - Puedes crearlo, destruirlo y recrearlo fácilmente
- ✅ **Portable** - Corre igual en cualquier máquina con Docker
- ✅ **Ligero** - Comparte el kernel del sistema, no virtualiza hardware completo

**Diferencia con Máquinas Virtuales:**

```
┌─────────────────────────────┐  ┌─────────────────────────────┐
│     MÁQUINA VIRTUAL         │  │         CONTENEDOR          │
├─────────────────────────────┤  ├─────────────────────────────┤
│      Aplicación             │  │      Aplicación             │
│      Bibliotecas            │  │      Bibliotecas            │
│   Sistema Operativo COMPLETO│  ├─────────────────────────────┤
│  (GB de almacenamiento)     │  │    Docker Engine            │
├─────────────────────────────┤  ├─────────────────────────────┤
│      Hypervisor             │  │   Sistema Operativo Host    │
├─────────────────────────────┤  └─────────────────────────────┘
│   Sistema Operativo Host    │  
└─────────────────────────────┘  
   ⚠️ Pesado, lento                ✅ Ligero, rápido
   ⚠️ Inicia en minutos            ✅ Inicia en segundos
```

#### 3. 💾 Volumen (Volume)

**Qué es:** Almacenamiento persistente para contenedores.

**Analogía:** Un **almacén externo** donde guardas cosas importantes. Aunque tu casa prefabricada (contenedor) se destruya, el almacén permanece con todas tus pertenencias.

**¿Por qué son necesarios?**

Sin volumen:
```
1. Creas contenedor PostgreSQL → Creas base de datos
2. Eliminas contenedor → ❌ ¡DATOS PERDIDOS!
```

Con volumen:
```
1. Creas contenedor PostgreSQL → Datos se guardan en volumen
2. Eliminas contenedor → ✅ Datos siguen en el volumen
3. Creas nuevo contenedor → ✅ Datos disponibles de nuevo
```

**Tipos de volúmenes:**

- **Named Volume (recomendado):**
  ```yaml
  volumes:
    - pgdata:/var/lib/postgresql/data  # Docker gestiona dónde se guarda
  ```

- **Bind Mount:**
  ```yaml
  volumes:
    - ./mi-carpeta:/var/lib/postgresql/data  # Mapeo directo a carpeta local
  ```

#### 4. 🌐 Red (Network)

**Qué es:** Redes virtuales que permiten a los contenedores comunicarse entre sí.

**Analogía:** Como el **cableado telefónico** entre casas de un vecindario. Permite que PostgreSQL hable con Prometheus, y Prometheus con Grafana.

**Tipos:**
- **Bridge (por defecto):** Red privada para contenedores
- **Host:** Contenedor usa directamente la red del host
- **None:** Sin red

#### 5. 🔌 Port Binding (Mapeo de Puertos)

**Qué es:** Exponer puertos del contenedor hacia tu máquina.

**Analogía:** Como instalar una **puerta con número** en la casa prefabricada para que la gente pueda visitarla desde afuera.

**Sintaxis:**
```yaml
ports:
  - "5432:5432"
     └─┬─┘ └─┬─┘
       │     └── Puerto DENTRO del contenedor
       └──────── Puerto en TU MÁQUINA (host)
```

**Flujo de conexión:**
```
Tu Aplicación → localhost:5432 → Docker → Contenedor:5432 → PostgreSQL
```

### ¿Qué es Docker Compose?

**Docker Compose** es una herramienta para **definir y ejecutar aplicaciones Docker multi-contenedor** usando un archivo de configuración YAML.

#### 🎼 Analogía: El Director de Orquesta

- **Docker:** Es como tener instrumentos musicales individuales
- **Docker Compose:** Es el director que coordina a todos los músicos para tocar una sinfonía

**Sin Docker Compose:**
```bash
# Necesitas ejecutar múltiples comandos:
docker network create mi_red
docker volume create pgdata
docker run -d --name postgres --network mi_red -v pgdata:/var/lib/postgresql/data ...
docker run -d --name prometheus --network mi_red ...
docker run -d --name grafana --network mi_red ...
# ¡Y mucho más! 😰
```

**Con Docker Compose:**
```bash
# Un solo comando:
docker-compose up -d
# ¡Todo configurado y corriendo! 🎉
```

### Anatomía de un Archivo Docker Compose

Un archivo `docker-compose.yml` tiene esta estructura:

```yaml
# Versión del formato (opcional en v2+)
version: '3.8'

# ═══════════════════════════════════════════════════════════
# SERVICIOS: Los contenedores que quieres ejecutar
# ═══════════════════════════════════════════════════════════
services:
  
  # ┌─────────────────────────────────────────────────────┐
  # │ SERVICIO 1: Base de Datos PostgreSQL                │
  # └─────────────────────────────────────────────────────┘
  postgres:
    # ¿Qué imagen usar?
    image: postgres:17-alpine
    
    # Nombre del contenedor (opcional pero recomendado)
    container_name: mi_postgres
    
    # Variables de entorno (configuración)
    environment:
      POSTGRES_USER: usuario
      POSTGRES_PASSWORD: contraseña
      POSTGRES_DB: mi_base_datos
    
    # Mapeo de puertos (host:contenedor)
    ports:
      - "5432:5432"
    
    # Volúmenes (persistencia de datos)
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    
    # Health check (verificar que funciona)
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U usuario"]
      interval: 10s
      timeout: 5s
      retries: 5
    
    # Política de reinicio
    restart: unless-stopped
    
    # Red a la que pertenece
    networks:
      - mi_red
  
  # ┌─────────────────────────────────────────────────────┐
  # │ SERVICIO 2: Prometheus (monitoreo)                  │
  # └─────────────────────────────────────────────────────┘
  prometheus:
    image: prom/prometheus:latest
    container_name: mi_prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    
    # Dependencias (espera a que postgres esté saludable)
    depends_on:
      postgres:
        condition: service_healthy
    
    networks:
      - mi_red

# ═══════════════════════════════════════════════════════════
# VOLÚMENES: Almacenamiento persistente
# ═══════════════════════════════════════════════════════════
volumes:
  pgdata:           # Datos de PostgreSQL
  prometheus_data:  # Datos de Prometheus

# ═══════════════════════════════════════════════════════════
# REDES: Comunicación entre contenedores
# ═══════════════════════════════════════════════════════════
networks:
  mi_red:
    driver: bridge
```

### 📚 Desglose de Secciones

#### `services:` - Los Contenedores

Define cada aplicación que quieres ejecutar.

```yaml
services:
  nombre_del_servicio:    # Identificador único
    image: ...            # ¿Qué imagen usar?
    container_name: ...   # Nombre del contenedor
    environment: ...      # Variables de configuración
    ports: ...           # Puertos expuestos
    volumes: ...         # Almacenamiento
    networks: ...        # Redes
    depends_on: ...      # Dependencias
    restart: ...         # Política de reinicio
```

#### `image:` - La Plantilla

Especifica qué imagen usar:

```yaml
image: postgres:17-alpine
#      └────┬───┘ └┬┘ └──┬──┘
#           │      │     └─── Variante/tag
#           │      └───────── Versión
#           └──────────────── Repositorio
```

**Fuentes de imágenes:**
- **Docker Hub:** `postgres:17-alpine` (por defecto)
- **Registro privado:** `mi-registro.com/postgres:17`
- **Construida localmente:** `build: ./mi-dockerfile`

#### `environment:` - Configuración

Pasa variables al contenedor:

```yaml
environment:
  # Método 1: Directo
  POSTGRES_USER: usuario
  POSTGRES_PASSWORD: secreto123
  
  # Método 2: Desde archivo .env
env_file:
  - .env
```

#### `ports:` - Exposición de Puertos

Hace accesibles los servicios desde tu máquina:

```yaml
ports:
  - "5432:5432"        # Host:Contenedor (mismo puerto)
  - "8080:80"          # Host 8080 → Contenedor 80
  - "127.0.0.1:5432:5432"  # Solo localhost puede acceder
```

#### `volumes:` - Persistencia

Guarda datos importantes:

```yaml
volumes:
  # Named volume (recomendado)
  - pgdata:/var/lib/postgresql/data
  
  # Bind mount (carpeta local)
  - ./config:/etc/postgresql
  
  # Read-only
  - ./scripts:/scripts:ro
```

#### `depends_on:` - Dependencias

Define orden de inicio:

```yaml
depends_on:
  # Simple (solo orden)
  - postgres
  
  # Con condición (espera a que esté healthy)
  postgres:
    condition: service_healthy
```

#### `networks:` - Redes

Conecta contenedores:

```yaml
networks:
  - frontend    # Red para servicios web
  - backend     # Red para bases de datos
```

### Comandos Esenciales de Docker Compose

```bash
# ═══════════════════════════════════════════════════════════
# GESTIÓN DE SERVICIOS
# ═══════════════════════════════════════════════════════════

# Iniciar todos los servicios
docker-compose up -d
#                  └─ detached (segundo plano)

# Detener servicios (mantiene datos)
docker-compose stop

# Detener y eliminar contenedores (datos en volúmenes se mantienen)
docker-compose down

# Detener y eliminar TODO (⚠️ incluye volúmenes)
docker-compose down -v

# Reiniciar servicios
docker-compose restart

# ═══════════════════════════════════════════════════════════
# INFORMACIÓN Y MONITOREO
# ═══════════════════════════════════════════════════════════

# Ver servicios corriendo
docker-compose ps

# Ver logs (todos los servicios)
docker-compose logs -f
#                    └─ follow (tiempo real)

# Ver logs de un servicio específico
docker-compose logs -f postgres

# Ver últimas 100 líneas
docker-compose logs --tail=100 postgres

# ═══════════════════════════════════════════════════════════
# EJECUCIÓN DE COMANDOS
# ═══════════════════════════════════════════════════════════

# Ejecutar comando en contenedor corriendo
docker-compose exec postgres psql -U usuario

# Ejecutar comando en nuevo contenedor
docker-compose run postgres pg_dump

# ═══════════════════════════════════════════════════════════
# CONSTRUCCIÓN Y ACTUALIZACIÓN
# ═══════════════════════════════════════════════════════════

# Descargar/actualizar imágenes
docker-compose pull

# Recrear contenedores (útil tras cambios)
docker-compose up -d --force-recreate

# Escalar servicios (múltiples instancias)
docker-compose up -d --scale postgres=3
```

### 🎯 Ejemplo Completo Comentado

```yaml
# ═══════════════════════════════════════════════════════════
# Stack PostgreSQL con Monitoreo
# ═══════════════════════════════════════════════════════════

services:
  # ┌──────────────────────────────────────────────────────┐
  # │ PostgreSQL: Base de datos principal                  │
  # │ - Almacena datos de tu aplicación                    │
  # │ - Accesible en localhost:5432                        │
  # └──────────────────────────────────────────────────────┘
  postgres:
    image: postgres:17-alpine        # Imagen oficial, versión 17, Alpine (ligera)
    container_name: postgres_prod    # Nombre único para identificar
    
    environment:
      POSTGRES_USER: ${DB_USER}      # Usuario (desde .env)
      POSTGRES_PASSWORD: ${DB_PASS}  # Contraseña (desde .env)
      POSTGRES_DB: ${DB_NAME}        # Base de datos inicial
      
      # Configuración de rendimiento
      POSTGRES_SHARED_BUFFERS: "2GB"
      POSTGRES_MAX_CONNECTIONS: "200"
    
    ports:
      - "5432:5432"                  # Puerto estándar de PostgreSQL
    
    volumes:
      # Datos persistentes
      - pgdata:/var/lib/postgresql/data
      
      # Scripts de inicialización (se ejecutan al crear)
      - ./init-scripts:/docker-entrypoint-initdb.d
      
      # Configuración personalizada
      - ./config/postgresql.conf:/etc/postgresql/postgresql.conf:ro
    
    healthcheck:
      # Verifica cada 10s si PostgreSQL responde
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
    
    restart: unless-stopped          # Reinicia automáticamente si falla
    
    networks:
      - db_network                   # Red privada para comunicación interna

  # ┌──────────────────────────────────────────────────────┐
  # │ Prometheus: Recolecta métricas                       │
  # │ - Accesible en localhost:9090                        │
  # └──────────────────────────────────────────────────────┘
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus_prod
    
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.retention.time=15d'  # Mantiene datos 15 días
    
    ports:
      - "9090:9090"
    
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    
    depends_on:
      postgres:
        condition: service_healthy   # Espera a que PostgreSQL esté listo
    
    networks:
      - db_network

  # ┌──────────────────────────────────────────────────────┐
  # │ Grafana: Visualización de métricas                   │
  # │ - Accesible en localhost:3000                        │
  # └──────────────────────────────────────────────────────┘
  grafana:
    image: grafana/grafana:latest
    container_name: grafana_prod
    
    environment:
      GF_SECURITY_ADMIN_USER: ${GRAFANA_USER}
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASS}
      GF_INSTALL_PLUGINS: "grafana-clock-panel"  # Plugin adicional
    
    ports:
      - "3000:3000"
    
    volumes:
      # Dashboards pre-configurados
      - ./grafana/provisioning:/etc/grafana/provisioning
      - grafana_data:/var/lib/grafana
    
    depends_on:
      - prometheus                   # Necesita que Prometheus esté corriendo
    
    networks:
      - db_network

# ═══════════════════════════════════════════════════════════
# Volúmenes Persistentes
# ═══════════════════════════════════════════════════════════
volumes:
  pgdata:            # Datos de PostgreSQL (bases de datos)
  prometheus_data:   # Métricas históricas de Prometheus
  grafana_data:      # Configuración y dashboards de Grafana

# ═══════════════════════════════════════════════════════════
# Redes
# ═══════════════════════════════════════════════════════════
networks:
  db_network:
    driver: bridge   # Red privada tipo bridge (por defecto)
```

### 💡 Ventajas de Usar Docker Compose

| Ventaja | Descripción |
|---------|-------------|
| **📝 Declarativo** | Describes "qué quieres", no "cómo hacerlo" |
| **🔄 Reproducible** | Mismo resultado en cualquier máquina |
| **🚀 Rápido** | Levanta todo con un comando |
| **📦 Portable** | Comparte configuración vía Git |
| **🔧 Mantenible** | Cambios documentados en código |
| **🎯 Versionable** | Control de versiones de infraestructura |

---

## Motores Disponibles

### Bases de Datos Relacionales

| Motor | Estado | Características | Documentación |
|-------|--------|----------------|---------------|
| **[PostgreSQL](./postgres/)** | ✅ Disponible | • PostgreSQL 17-alpine<br>• 4 plantillas (dev/prod/testing/analytics)<br>• Monitoreo con Grafana + Prometheus<br>• 13 categorías de métricas<br>• 5 dashboards pre-configurados | [Ver README →](./postgres/README.md) |
| **MySQL** | 🚧 Próximamente | En desarrollo | - |
| **MariaDB** | 📋 Planificado | En roadmap | - |
| **Microsoft SQL Server** | 📋 Planificado | En roadmap | - |

### Bases de Datos NoSQL

| Motor | Estado | Tipo | Documentación |
|-------|--------|------|---------------|
| **MongoDB** | 🚧 Próximamente | Documentos | - |
| **Redis** | 🚧 Próximamente | Clave-Valor / Cache | - |
| **Cassandra** | 📋 Planificado | Columnar / Distribuida | - |
| **Elasticsearch** | 📋 Planificado | Búsqueda y Análisis | - |
| **CouchDB** | 📋 Planificado | Documentos | - |

**Leyenda:**
- ✅ **Disponible** - Completamente funcional y documentado
- 🚧 **Próximamente** - En desarrollo activo
- 📋 **Planificado** - En roadmap

---

## Inicio Rápido

### 1. Clonar el repositorio

```bash
git clone <repository-url>
cd DB-Motores
```

### 2. Elegir un motor

```bash
# Ejemplo con PostgreSQL
cd postgres
```

### 3. Elegir plantilla y ejecutar

```bash
# Desarrollo
docker-compose -f templates/development.yml up -d

# Producción (requiere archivo .env)
docker-compose -f templates/production.yml --env-file .env up -d

# Testing
docker-compose -f templates/testing.yml up -d

# Analytics
docker-compose -f templates/analytics.yml up -d
```

### 4. Verificar

```bash
docker ps
```

### 5. Conectar

Usa las credenciales definidas en la plantilla o tu archivo `.env`. Consulta el README específico de cada motor para detalles de conexión.

---


## Estructura del Proyecto

```
DB-Motores/
│
├── README.md                    ← Este archivo (índice general)
│
├── postgres/                    ← PostgreSQL
│   ├── README.md               ← Documentación completa
│   ├── QUICK-START.md          ← Guía de inicio rápido
│   ├── STRUCTURE.md            ← Estructura detallada del proyecto
│   ├── templates/              ← Plantillas Docker Compose
│   │   ├── development.yml    ← Para desarrollo local
│   │   ├── production.yml     ← Para producción
│   │   ├── testing.yml        ← Para CI/CD
│   │   ├── analytics.yml      ← Para análisis de datos
│   │   ├── base.yml           ← Configuración base
│   │   ├── .env.example       ← Variables de entorno
│   │   └── README.md          ← Documentación de plantillas
│   ├── config/                 ← Configuraciones personalizadas
│   ├── init-scripts/           ← Scripts de inicialización
│   ├── grafana/                ← Dashboards y datasources
│   ├── postgres-queries.yaml   ← Métricas personalizadas
│   └── prometheus.yml          ← Configuración de Prometheus
│
├── mysql/                       ← MySQL (próximamente)
│   ├── README.md
│   ├── templates/
│   └── ...
│
├── mongodb/                     ← MongoDB (próximamente)
│   ├── README.md
│   ├── templates/
│   └── ...
│
└── redis/                       ← Redis (próximamente)
    ├── README.md
    ├── templates/
    └── ...
```

### Convención de Estructura por Motor

Cada motor sigue esta estructura estándar:

```
{motor}/
├── README.md              # Documentación principal del motor
├── QUICK-START.md         # Inicio rápido (5 minutos)
├── templates/             # Plantillas Docker Compose
│   ├── development.yml   # Desarrollo
│   ├── production.yml    # Producción
│   ├── testing.yml       # Testing/CI-CD
│   ├── .env.example      # Variables documentadas
│   └── README.md         # Comparación de plantillas
├── config/                # Archivos de configuración
├── init-scripts/          # Scripts de inicialización
└── monitoring/            # (opcional) Herramientas de monitoreo
```

---

## Requisitos

### Software Necesario

**Obligatorio:**
- **Docker Engine** 20.10 o superior
- **Docker Compose** v2.0 o superior

**Opcional (para scripts de gestión):**
- **PowerShell 5.1+** (Windows) o **PowerShell Core 7+** (Linux/Mac)

> **📝 Nota**: Los proyectos incluyen **scripts PowerShell** (`.ps1`) para facilitar la gestión, pero también se pueden usar manualmente con comandos Docker Compose. Los scripts están **optimizados para Windows** pero funcionan en cualquier SO con PowerShell instalado.

### Instalación

<details>
<summary>🪟 Windows</summary>

Instala [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop)

Verifica instalación:
```powershell
docker --version
docker-compose --version
```
</details>

<details>
<summary>🐧 Linux</summary>

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Instalar Docker Compose plugin
sudo apt install docker-compose-plugin
```

Verifica instalación:
```bash
docker --version
docker compose version
```
</details>

<details>
<summary>🍎 macOS</summary>

Instala [Docker Desktop para Mac](https://www.docker.com/products/docker-desktop)

Verifica instalación:
```bash
docker --version
docker-compose --version
```
</details>

---

## Guía de Uso

### Flujo de Trabajo General

```
1. Elegir Motor
   ↓
2. Leer README del motor
   ↓
3. Elegir plantilla (dev/prod/testing)
   ↓
4. Configurar variables (opcional)
   ↓
5. Ejecutar docker-compose
   ↓
6. Verificar estado
   ↓
7. Conectar y usar
```

### Ejemplo Completo con PostgreSQL

```bash
# 1. Ir a la carpeta del motor
cd postgres

# 2. Ver plantillas disponibles
ls templates/

# 3. Copiar archivo de ejemplo (si usas producción)
cp templates/.env.example .env

# 4. Editar variables (si es necesario)
nano .env  # o usa tu editor preferido

# 5. Levantar con la plantilla deseada
docker-compose -f templates/development.yml up -d

# 6. Verificar
docker ps

# 7. Ver logs
docker-compose -f templates/development.yml logs -f

# 8. Detener cuando termines
docker-compose -f templates/development.yml down
```

### Comandos Útiles

```bash
# Ver contenedores corriendo
docker ps

# Ver logs de un servicio
docker-compose logs -f [servicio]

# Ejecutar comando en contenedor
docker-compose exec [servicio] [comando]

# Detener servicios
docker-compose down

# Detener y eliminar volúmenes (⚠️ BORRA DATOS)
docker-compose down -v

# Reiniciar servicios
docker-compose restart
```

---

## Contribuir

### Agregar un nuevo motor

1. Crea carpeta con nombre del motor
2. Sigue la estructura estándar
3. Incluye al menos:
   - `README.md` completo
   - `QUICK-START.md`
   - Plantilla `development.yml`
   - `.env.example` documentado
4. Actualiza este README en la sección [Motores Disponibles](#motores-disponibles)

### Mejoras a motores existentes

1. Verifica que la configuración funcione
2. Documenta cambios claramente
3. Actualiza el README correspondiente
4. Prueba todas las plantillas afectadas

---

## Recursos

### Documentación Docker

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [Docker Hub](https://hub.docker.com/)

### Por Motor

Cada motor tiene enlaces a su documentación oficial en su README correspondiente.

---

## Licencia

Este proyecto está bajo licencia MIT. Ver `LICENSE` para más detalles.

---

**Mantenido por:** RAISIAR  
**Última actualización:** Enero 2026  
**Versión:** 2.0.0

---

> 💡 **Nota:** Este es un proyecto de referencia. Ajusta las configuraciones según tus necesidades específicas, especialmente para ambientes de producción.
