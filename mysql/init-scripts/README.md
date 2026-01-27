# 📜 Scripts de Inicialización MySQL

Esta carpeta contiene scripts SQL y Shell que se ejecutan automáticamente la **primera vez** que se crea el contenedor MySQL.

## 🔄 ¿Cómo Funciona?

MySQL ejecuta automáticamente todos los archivos en `/docker-entrypoint-initdb.d/` al inicializar, **SOLO si el volumen de datos está vacío**.

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

Modifica el contenido:
```sql
-- 01-init.sql
CREATE DATABASE IF NOT EXISTS mi_aplicacion;
USE mi_aplicacion;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3. Montar en Docker Compose

Edita la plantilla que uses (ejemplo `templates/development.yml`) y agrega el volumen:
```yaml
services:
  mysql:
    volumes:
      - mysql_dev_data:/var/lib/mysql
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
- Crea base de datos para la aplicación
- Crea tablas de ejemplo (users, posts, comments)
- Crea índices
- Inserta datos de prueba

**Usar para:**
- Estructura inicial de tu aplicación
- Datos de testing

---

### `02-functions.sql.example`
**Qué hace:**
- Crea stored procedures
- Crea funciones útiles
- Crea triggers (ej: actualizar `updated_at` automáticamente)

**Usar para:**
- Lógica de negocio en base de datos
- Triggers automáticos
- Funciones de utilidad

---

### `03-setup.sh.example`
**Qué hace:**
- Ejecuta comandos shell complejos
- Puede llamar a múltiples scripts SQL
- Configuración condicional

**Usar para:**
- Setup complejo
- Importar múltiples archivos
- Lógica condicional

---

## ⚙️ Variables de Entorno Disponibles

Dentro de los scripts puedes usar:

```bash
# En .sh scripts
$MYSQL_ROOT_PASSWORD
$MYSQL_USER
$MYSQL_PASSWORD
$MYSQL_DATABASE

# Ejemplo:
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'readonly'@'%' IDENTIFIED BY 'readonly123';"
```

```sql
-- En .sql scripts no hay acceso directo a variables de entorno
-- Pero el script se ejecuta en el contexto de $MYSQL_DATABASE si está definido
```

---

## 🔍 Ver Logs de Inicialización

```bash
# Ver logs del contenedor durante la inicialización
docker logs -f mysql_dev

# Buscar errores específicos
docker logs mysql_dev 2>&1 | grep -i error
```

---

## 🐛 Troubleshooting

### Scripts no se ejecutan

**Causas comunes:**
1. El volumen ya tiene datos (scripts solo corren en volumen vacío)
2. Sintaxis SQL incorrecta
3. Permisos incorrectos en archivos .sh

**Solución:**
```bash
# Eliminar volumen y recrear
docker-compose -f templates/development.yml down -v
docker-compose -f templates/development.yml up -d

# Ver logs para errores
docker logs mysql_dev
```

### Error de sintaxis SQL

```bash
# Validar sintaxis antes de ejecutar
mysql -u root -p < 01-init.sql --verbose

# O dentro del contenedor
docker exec -i mysql_dev mysql -u root -p < init-scripts/01-init.sql
```

### Script .sh no ejecuta

```bash
# Dar permisos de ejecución
chmod +x init-scripts/03-setup.sh

# Verificar que tenga shebang correcto
head -1 init-scripts/03-setup.sh
# Debe mostrar: #!/bin/bash
```

---

## 💡 Tips y Mejores Prácticas

### 1. Usar Transacciones
```sql
START TRANSACTION;

-- Tus operaciones aquí
CREATE TABLE ...
INSERT INTO ...

COMMIT;
```

### 2. Crear Usuarios con Permisos Mínimos
```sql
-- Usuario de solo lectura
CREATE USER 'readonly'@'%' IDENTIFIED BY 'pass123';
GRANT SELECT ON mydatabase.* TO 'readonly'@'%';

-- Usuario de aplicación
CREATE USER 'app'@'%' IDENTIFIED BY 'apppass123';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydatabase.* TO 'app'@'%';

-- Usuario para mysqld_exporter (monitoreo)
-- NOTA: Este usuario se crea automáticamente en 00-create-exporter-user.sql
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter_password_123' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';

FLUSH PRIVILEGES;
```

### 3. Manejar Errores
```bash
#!/bin/bash
set -e  # Detiene en error

mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
-- Tu SQL aquí
EOF

if [ $? -eq 0 ]; then
    echo "✓ Script ejecutado exitosamente"
else
    echo "✗ Error en script"
    exit 1
fi
```

### 4. Separar Concerns
- `01-schema.sql` - Estructura (tablas, índices)
- `02-functions.sql` - Lógica (procedures, triggers)
- `03-users.sql` - Usuarios y permisos
- `04-data.sql` - Datos iniciales

---

## 📚 Recursos

- [MySQL Docker Init](https://hub.docker.com/_/mysql) - Sección "Initializing a fresh instance"
- [MySQL CREATE TABLE](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)
- [MySQL Stored Procedures](https://dev.mysql.com/doc/refman/8.0/en/stored-programs-defining.html)

---

**Última actualización:** Enero 2026
