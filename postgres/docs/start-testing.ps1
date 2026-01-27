# ====================================================================================
# SCRIPT: INICIAR TESTING
# ====================================================================================
# Inicia PostgreSQL en modo Testing (CI/CD) - Sin persistencia
# ====================================================================================

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  PostgreSQL 17 + Monitoreo - TESTING (CI/CD)" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Navegar al directorio correcto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "⚠️  MODO TESTING - Sin persistencia (datos en tmpfs)" -ForegroundColor Red
Write-Host ""
Write-Host "📦 Iniciando servicios de testing..." -ForegroundColor Yellow
Write-Host ""

# Levantar servicios
docker-compose -f templates/testing.yml up -d

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
    Write-Host "   Usuario:  test_user" -ForegroundColor Gray
    Write-Host "   Password: test_pass" -ForegroundColor Gray
    Write-Host "   Database: test_db" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📊 Grafana:   http://localhost:3001" -ForegroundColor White
    Write-Host "   Usuario:  admin" -ForegroundColor Gray
    Write-Host "   Password: admin" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📈 Prometheus: http://localhost:9090" -ForegroundColor White
    Write-Host "📉 Exporter:   http://localhost:9187/metrics" -ForegroundColor White
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Esperar un momento
    Write-Host "⏳ Esperando que los servicios estén listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    
    # Verificar estado
    Write-Host ""
    Write-Host "📊 Estado de los contenedores:" -ForegroundColor Yellow
    docker-compose -f templates/testing.yml ps
    
    Write-Host ""
    Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Red
    Write-Host "   • Los datos NO son persistentes" -ForegroundColor Yellow
    Write-Host "   • Al eliminar los contenedores, se pierden todos los datos" -ForegroundColor Yellow
    Write-Host "   • FSYNC está desactivado (no usar en producción)" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "💡 Comandos útiles:" -ForegroundColor Yellow
    Write-Host "   Ver logs:      docker-compose -f templates/testing.yml logs -f" -ForegroundColor Gray
    Write-Host "   Detener:       docker-compose -f templates/testing.yml stop" -ForegroundColor Gray
    Write-Host "   Eliminar todo: docker-compose -f templates/testing.yml down" -ForegroundColor Gray
    Write-Host ""
    
} else {
    Write-Host ""
    Write-Host "❌ Error al iniciar los servicios" -ForegroundColor Red
    Write-Host "Ver logs con: docker-compose -f templates/testing.yml logs" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
