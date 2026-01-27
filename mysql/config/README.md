# 🔧 Configuración MySQL

Esta carpeta contiene archivos de configuración personalizados para MySQL.

## 📁 Archivos Disponibles

### `my.cnf.example`
Archivo de configuración principal de MySQL con valores optimizados y comentados.

**Para usar:**
```bash
# 1. Copia el ejemplo
cp config/my.cnf.example config/my.cnf

# 2. Ajusta valores según tu servidor

# 3. Edita tu plantilla (ej: templates/production.yml) y monta el archivo:
volumes:
  - ./config/my.cnf:/etc/mysql/conf.d/custom.cnf:ro

# 4. Reinicia MySQL
docker-compose -f templates/production.yml restart mysql
```

**Secciones incluidas:**
- Conexiones y autenticación
- Recursos de memoria (InnoDB buffer pool, caches)
- Configuración de InnoDB
- Logging y binary logs
- Replicación
- Performance Schema
- Optimizaciones para SSD

---

## 🎯 Casos de Uso

### Desarrollo Local
```bash
# Usa defaults de la plantilla
# Sin configuración personalizada
docker-compose -f templates/development.yml up -d
```

### Producción Simple
```bash
# Usa variables de entorno en .env
# Sin archivo my.cnf personalizado
docker-compose -f templates/production.yml --env-file .env up -d
```

### Producción Avanzada
```bash
# 1. Personaliza my.cnf
cp config/my.cnf.example config/my.cnf
nano config/my.cnf

# 2. Edita templates/production.yml para montar:
#    volumes:
#      - ./config/my.cnf:/etc/mysql/conf.d/custom.cnf:ro

# 3. Levanta
docker-compose -f templates/production.yml up -d
```

---

## 🔄 Recargar Configuración

Algunos cambios se pueden aplicar sin reiniciar:

```bash
# Ver variables que se pueden cambiar dinámicamente
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES WHERE Variable_name IN ('max_connections', 'query_cache_size');"

# Cambiar dinámicamente (no persiste al reiniciar)
docker exec mysql_prod mysql -u root -p -e "SET GLOBAL max_connections = 200;"

# Para cambios permanentes, edita my.cnf y reinicia
docker-compose -f templates/production.yml restart mysql
```

---

## 📊 Verificar Configuración Activa

```bash
# Ver todas las variables
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES;"

# Ver variables específicas
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES LIKE 'innodb_buffer%';"

# Ver variables que fueron cambiadas del default
docker exec mysql_prod mysql -u root -p -e "SHOW VARIABLES WHERE Variable_name NOT IN (SELECT Variable_name FROM performance_schema.variables_info WHERE VARIABLE_SOURCE = 'COMPILED');" 2>/dev/null || echo "Usa: SHOW VARIABLES;"
```

---

## 💡 Tips

1. **No modifiques `/etc/mysql/my.cnf` directamente** - Usa `/etc/mysql/conf.d/` para overrides
2. **Valida sintaxis** antes de reiniciar con `mysqld --validate-config`
3. **Backup antes de cambios** importantes
4. **Monitorea performance** después de cambios con Grafana

---

**Recursos:**
- [MySQL Configuration Reference](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)
- [InnoDB Configuration](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html)
