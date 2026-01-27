# ====================================================================================
# SCRIPT: INICIAR PRODUCCIÓN
# ====================================================================================
# Inicia PostgreSQL en modo Production con configuración optimizada
# ====================================================================================

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  PostgreSQL 17 + Monitoreo - PRODUCTION" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Navegar al directorio correcto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Verificar si existe el archivo .env
if (-not (Test-Path ".env")) {
    Write-Host "❌ ERROR: No se encontró el archivo .env" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, crea un archivo .env con las siguientes variables:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "POSTGRES_USER=prod_user" -ForegroundColor Gray
    Write-Host "POSTGRES_PASSWORD=secure_password_here" -ForegroundColor Gray
    Write-Host "POSTGRES_DB=production_db" -ForegroundColor Gray
    Write-Host "GF_ADMIN_USER=admin" -ForegroundColor Gray
    Write-Host "GF_ADMIN_PASSWORD=secure_grafana_password" -ForegroundColor Gray
    Write-Host "GF_SERVER_DOMAIN=your-domain.com" -ForegroundColor Gray
    Write-Host "GF_SERVER_ROOT_URL=https://your-domain.com" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "✅ Archivo .env encontrado" -ForegroundColor Green
Write-Host ""

# Verificar archivos de configuración
$configFiles = @(
    "config/postgresql/active/postgresql.conf",
    "config/postgresql/active/pg_hba.conf"
)

foreach ($file in $configFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "⚠️  ADVERTENCIA: No se encontró $file" -ForegroundColor Yellow
        Write-Host "   Se usarán las configuraciones por defecto de PostgreSQL" -ForegroundColor Gray
    } else {
        Write-Host "✅ Encontrado: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📦 Iniciando servicios de producción..." -ForegroundColor Yellow
Write-Host ""

# Levantar servicios
docker-compose -f templates/production.yml up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Servicios iniciados correctamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host "  ACCESO A SERVICIOS" -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🐘 PostgreSQL:" -ForegroundColor White
    Write-Host "   Host:     localhost:5432" -ForegroundColor Gray
    Write-Host "   Usuario:  [Ver archivo .env]" -ForegroundColor Gray
    Write-Host "   Password: [Ver archivo .env]" -ForegroundColor Gray
    Write-Host "   Database: [Ver archivo .env]" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📊 Grafana:   http://localhost:3000" -ForegroundColor White
    Write-Host "   Usuario:  [Ver archivo .env]" -ForegroundColor Gray
    Write-Host "   Password: [Ver archivo .env]" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📈 Prometheus: http://localhost:9090" -ForegroundColor White
    Write-Host "📉 Exporter:   http://localhost:9187/metrics" -ForegroundColor White
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Esperar un momento
    Write-Host "⏳ Esperando que los servicios estén listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
    
    # Verificar estado
    Write-Host ""
    Write-Host "📊 Estado de los contenedores:" -ForegroundColor Yellow
    docker-compose -f templates/production.yml ps
    
    Write-Host ""
    Write-Host "🔒 RECORDATORIOS DE SEGURIDAD:" -ForegroundColor Red
    Write-Host "   • Cambia las contraseñas por defecto" -ForegroundColor Yellow
    Write-Host "   • Configura backups automáticos" -ForegroundColor Yellow
    Write-Host "   • Revisa pg_hba.conf para acceso seguro" -ForegroundColor Yellow
    Write-Host "   • Configura SSL/TLS para conexiones remotas" -ForegroundColor Yellow
    Write-Host "   • Monitorea los logs regularmente" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "💡 Comandos útiles:" -ForegroundColor Yellow
    Write-Host "   Ver logs:      docker-compose -f templates/production.yml logs -f" -ForegroundColor Gray
    Write-Host "   Detener:       docker-compose -f templates/production.yml stop" -ForegroundColor Gray
    Write-Host "   Reiniciar:     docker-compose -f templates/production.yml restart" -ForegroundColor Gray
    Write-Host "   Backup:        Ver documentación de backups" -ForegroundColor Gray
    Write-Host ""
    
} else {
    Write-Host ""
    Write-Host "❌ Error al iniciar los servicios" -ForegroundColor Red
    Write-Host "Ver logs con: docker-compose -f templates/production.yml logs" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
