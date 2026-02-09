# ====================================================================================
# SCRIPT: INICIAR ANALYTICS
# ====================================================================================
# Inicia PostgreSQL en modo Analytics optimizado para queries complejas
# ====================================================================================

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  PostgreSQL 17 + Monitoreo - ANALYTICS" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Navegar al directorio padre (postgres/) donde están las plantillas
$currentDir = Get-Location
if ($currentDir.Path -like "*scripts*") {
    $parentDir = Split-Path -Parent $currentDir
    Set-Location $parentDir
} 

Write-Host "Iniciando servicios de analytics..." -ForegroundColor Yellow
Write-Host "Directorio actual: $(Get-Location)" -ForegroundColor Cyan
Write-Host ""

# Verificar que el archivo existe
if (-not (Test-Path "templates/analytics.yml")) {
    Write-Host "Error: No se encuentra templates/analytics.yml" -ForegroundColor Red
    Write-Host "Directorio actual: $(Get-Location)" -ForegroundColor Gray
    Get-ChildItem | Format-Table Name, Mode
    exit 1
}

Write-Host "Ejecutando: docker-compose -p analytics -f templates/analytics.yml up -d" -ForegroundColor Cyan

# Levantar servicios con nombre de proyecto explícito
$result = docker-compose -p analytics -f templates/analytics.yml up -d 2>&1
Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Gray

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Servicios iniciados correctamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host "  ACCESO A SERVICIOS" -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "PostgreSQL:" -ForegroundColor White
    Write-Host "   Host:     localhost:5435" -ForegroundColor Gray
    Write-Host "   Usuario:  analytics_user" -ForegroundColor Gray
    Write-Host "   Password: analytics_pass_456" -ForegroundColor Gray
    Write-Host "   Database: analytics_db" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Grafana:   http://localhost:3003" -ForegroundColor White
    Write-Host "   Usuario:  admin" -ForegroundColor Gray
    Write-Host "   Password: analytics_admin_789" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Prometheus: http://localhost:9093" -ForegroundColor White
    Write-Host "Exporter:   http://localhost:9190/metrics" -ForegroundColor White
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Esperar un momento
    Write-Host "Esperando que los servicios estén listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    # Verificar estado
    Write-Host ""
    Write-Host "Estado de los contenedores:" -ForegroundColor Yellow
    docker-compose -p analytics -f templates/analytics.yml ps
    
    Write-Host ""
    Write-Host "OPTIMIZACIONES DE ANALYTICS:" -ForegroundColor Green
    Write-Host "   • Work Memory: 128MB (queries complejas)" -ForegroundColor Gray
    Write-Host "   • Max Parallel Workers: 4" -ForegroundColor Gray
    Write-Host "   • Statistics Target: Alto (mejor planning)" -ForegroundColor Gray
    Write-Host "   • Sin timeout de queries" -ForegroundColor Gray
    Write-Host "   • Logging de queries > 5 segundos" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Comandos útiles:" -ForegroundColor Yellow
    Write-Host "   Ver logs:      docker-compose -p analytics -f templates/analytics.yml logs -f" -ForegroundColor Gray
    Write-Host "   Detener:       docker-compose -p analytics -f templates/analytics.yml stop" -ForegroundColor Gray
    Write-Host "   Reiniciar:     docker-compose -p analytics -f templates/analytics.yml restart" -ForegroundColor Gray
    Write-Host "   Eliminar todo: docker-compose -p analytics -f templates/analytics.yml down -v" -ForegroundColor Gray
    Write-Host ""
    
    # Preguntar si quiere abrir Grafana
    Write-Host "Deseas abrir Grafana en el navegador? (S/N): " -ForegroundColor Yellow -NoNewline
    $response = Read-Host
    
    if ($response -eq "S" -or $response -eq "s") {
        Start-Process "http://localhost:3003"
        Write-Host "Abriendo Grafana..." -ForegroundColor Green
    }
    
} else {
    Write-Host ""
    Write-Host "Error al iniciar los servicios" -ForegroundColor Red
    Write-Host "Ver logs con: docker-compose -p analytics -f templates/analytics.yml logs" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Resultado del comando:" -ForegroundColor Gray
    Write-Host $result
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""