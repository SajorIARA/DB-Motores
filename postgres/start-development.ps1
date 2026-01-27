# ====================================================================================
# SCRIPT: INICIAR DESARROLLO
# ====================================================================================
# Inicia PostgreSQL en modo Development con monitoreo completo
# ====================================================================================

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  PostgreSQL 17 + Monitoreo - DEVELOPMENT" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Navegar al directorio correcto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "📦 Iniciando servicios de desarrollo..." -ForegroundColor Yellow
Write-Host ""

# Levantar servicios
docker-compose -f templates/development.yml up -d

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
    Write-Host "   Usuario:  dev_user" -ForegroundColor Gray
    Write-Host "   Password: dev_pass_123" -ForegroundColor Gray
    Write-Host "   Database: dev_database" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📊 Grafana:   http://localhost:3000" -ForegroundColor White
    Write-Host "   Usuario:  admin" -ForegroundColor Gray
    Write-Host "   Password: dev_admin_123" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📈 Prometheus: http://localhost:9090" -ForegroundColor White
    Write-Host "📉 Exporter:   http://localhost:9187/metrics" -ForegroundColor White
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Esperar un momento
    Write-Host "⏳ Esperando que los servicios estén listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    # Verificar estado
    Write-Host ""
    Write-Host "📊 Estado de los contenedores:" -ForegroundColor Yellow
    docker-compose -f templates/development.yml ps
    
    Write-Host ""
    Write-Host "💡 Comandos útiles:" -ForegroundColor Yellow
    Write-Host "   Ver logs:      docker-compose -f templates/development.yml logs -f" -ForegroundColor Gray
    Write-Host "   Detener:       docker-compose -f templates/development.yml stop" -ForegroundColor Gray
    Write-Host "   Reiniciar:     docker-compose -f templates/development.yml restart" -ForegroundColor Gray
    Write-Host "   Eliminar todo: docker-compose -f templates/development.yml down -v" -ForegroundColor Gray
    Write-Host ""
    
    # Preguntar si quiere abrir Grafana
    Write-Host "¿Deseas abrir Grafana en el navegador? (S/N): " -ForegroundColor Yellow -NoNewline
    $response = Read-Host
    
    if ($response -eq 'S' -or $response -eq 's') {
        Start-Process "http://localhost:3000"
        Write-Host "✅ Abriendo Grafana..." -ForegroundColor Green
    }
    
} else {
    Write-Host ""
    Write-Host "❌ Error al iniciar los servicios" -ForegroundColor Red
    Write-Host "Ver logs con: docker-compose -f templates/development.yml logs" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
