# 📜 Scripts de Inicialización PostgreSQL

Esta carpeta contiene scripts SQL y Shell que se ejecutan automáticamente la **primera vez** que se crea el contenedor PostgreSQL.

## 🔄 ¿Cómo Funciona?

PostgreSQL ejecuta automáticamente todos los archivos en `/docker-entrypoint-initdb.d/` al inicializar, **SOLO si el volumen de datos está vacío**.

### Orden de Ejecución
Los archivos se ejecutan en **orden alfabético**, por eso usamos prefijos numéricos:
```
01-init.sql         → Se ejecuta primero
02-functions.sql    → Segundo
03-setup.sh         → Tercero
04-data.sql         → Cuarto
...
```

### Tipos de Archivos Soportados
- `.sql` - Scripts SQL
- `.sql.gz` - Scripts SQL comprimidos
- `.sh` - Shell scripts (bash)

---

## 🚀 Uso Básico

### 1. Crear tus Scripts

Copia los ejemplos y personalízalos:
```bash
# Windows (PowerShell)
Copy-Item 01-init.sql.example 01-init.sql

# Linux/macOS
cp 01-init.sql.example 01-init.sql
```

### 2. Editar según tus Necesidades

Modifica el contenido de los scripts:
```sql
-- 01-init.sql
CREATE TABLE mi_tabla (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);
```

### 3. Montar en Docker Compose

Edita la plantilla que uses (ejemplo `templates/development.yml`) y agrega el volumen:
```yaml
services:
  postgres:
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d  # ← Agregar esta línea
```

### 4. Crear el Contenedor

```bash
# Si ya existe, bórralo primero (⚠️ esto borra los datos)
docker-compose -f templates/development.yml down -v

# Crear nuevo
docker-compose -f templates/development.yml up -d
```

---

## 📋 Ejemplos Incluidos

### `01-init.sql.example`
**Qué hace:**
- Crea extensiones útiles (uuid-ossp, pg_trgm, citext)
- Crea esquema `app`
- Crea tablas de ejemplo (users, posts)
- Crea índices
- Inserta datos de muestra

**Usar para:**
- Estructura inicial de tu aplicación
- Datos de prueba

---

### `02-functions.sql.example`
**Qué hace:**
- Crea función para actualizar `updated_at` automáticamente
- Crea triggers para tablas
- Crea función de búsqueda de usuarios

**Usar para:**
- Funciones de utilidad
- Triggers automáticos
- Stored procedures

---

### `03-setup.sh.example`
**Qué hace:**
- Crea roles (readonly, app_role)
- Crea usuarios adicionales (reader, app_user)
- Configura permisos
- Actualiza estadísticas

**Usar para:**
- Configuración compleja que requiere lógica
- Crear múltiples usuarios/roles
- Tareas administrativas

---

## 🎯 Casos de Uso Comunes

### Estructura de Aplicación
```sql
-- 01-schema.sql
CREATE SCHEMA IF NOT EXISTS myapp;

CREATE TABLE myapp.customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE myapp.orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES myapp.customers(id),
    total DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);
```

### Datos de Prueba
```sql
-- 02-test-data.sql
INSERT INTO myapp.customers (name, email) VALUES
    ('Test User 1', 'test1@example.com'),
    ('Test User 2', 'test2@example.com');

INSERT INTO myapp.orders (customer_id, total) VALUES
    (1, 99.99),
    (1, 149.50),
    (2, 49.99);
```

### Usuarios y Permisos
```sql
-- 03-users.sql
-- Usuario de aplicación
CREATE USER app_user WITH PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE myapp_db TO app_user;
GRANT USAGE ON SCHEMA myapp TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA myapp TO app_user;

-- Usuario de solo lectura
CREATE USER readonly_user WITH PASSWORD 'readonly_pass';
GRANT CONNECT ON DATABASE myapp_db TO readonly_user;
GRANT USAGE ON SCHEMA myapp TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA myapp TO readonly_user;
```

### Extensiones Útiles
```sql
-- 01-extensions.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- Generar UUIDs
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Búsqueda fuzzy
CREATE EXTENSION IF NOT EXISTS "hstore";         -- Pares clave-valor
CREATE EXTENSION IF NOT EXISTS "citext";         -- Texto case-insensitive
CREATE EXTENSION IF NOT EXISTS "postgis";        -- Datos geoespaciales
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements"; -- Estadísticas de queries
```

---

## ⚠️ Consideraciones Importantes

### Solo Primera Vez
```
❌ Los scripts NO se ejecutan si:
   - El volumen ya contiene datos
   - Modificas los scripts después de crear el contenedor
   
✅ Los scripts SÍ se ejecutan si:
   - Es la primera vez que creas el contenedor
   - Borraste el volumen (docker-compose down -v)
```

### Para Re-ejecutar Scripts
```bash
# 1. Backup de datos si es necesario
docker exec postgres_conection_test pg_dump -U test test_db > backup.sql

# 2. Borrar contenedor Y volumen
docker-compose -f postgresql-docker-compose.yml down -v

# 3. Recrear
docker-compose -f postgresql-docker-compose.yml up -d

# 4. Restaurar backup si es necesario
docker exec -i postgres_conection_test psql -U test test_db < backup.sql
```

### Debugging

Ver si los scripts se ejecutaron:
```bash
# Ver logs del contenedor
docker logs postgres_conection_test

# Buscar mensajes de los scripts
docker logs postgres_conection_test | grep "✅"
```

### Permisos de Shell Scripts

En Linux/macOS, asegúrate de que los `.sh` sean ejecutables:
```bash
chmod +x *.sh
```

---

## 🔒 Seguridad

### ⚠️ NO incluir en Git
Si tus scripts contienen datos sensibles:

```gitignore
# .gitignore
init-scripts/*.sql
init-scripts/*.sh
!init-scripts/*.example
```

### Usar Variables de Entorno
```bash
#!/bin/bash
# 03-users.sh
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER app_user WITH PASSWORD '$APP_USER_PASSWORD';
EOSQL
```

Definir en `.env`:
```ini
APP_USER_PASSWORD=secure_password_here
```

---

## 📚 Referencias

- [Docker PostgreSQL Initialization Scripts](https://hub.docker.com/_/postgres)
- [PostgreSQL SQL Syntax](https://www.postgresql.org/docs/current/sql.html)
- [PostgreSQL Extensions](https://www.postgresql.org/docs/current/contrib.html)

---

## 💡 Tips

1. **Usa transacciones** en scripts largos:
   ```sql
   BEGIN;
   -- tus operaciones
   COMMIT;
   ```

2. **Maneja errores** en shell scripts:
   ```bash
   set -e  # Salir si hay error
   ```

3. **Testea localmente** antes de producción

4. **Comenta bien** tus scripts para futuro mantenimiento

5. **Mensajes de confirmación** ayudan al debugging:
   ```sql
   DO $$
   BEGIN
       RAISE NOTICE '✅ Tabla users creada';
   END $$;
   ```
