# ====================================================================================
# SCRIPT MAESTRO: GESTIÓN DE POSTGRESQL + MONITOREO
# ====================================================================================
# Script interactivo para gestionar las 4 modalidades de PostgreSQL
# ====================================================================================

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "██████╗  ██████╗ ███████╗████████╗ ██████╗ ██████╗ ███████╗███████╗" -ForegroundColor Cyan
    Write-Host "██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝██╔════╝ ██╔══██╗██╔════╝██╔════╝" -ForegroundColor Cyan
    Write-Host "██████╔╝██║   ██║███████╗   ██║   ██║  ███╗██████╔╝█████╗  ███████╗" -ForegroundColor Cyan
    Write-Host "██╔═══╝ ██║   ██║╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  ╚════██║" -ForegroundColor Cyan
    Write-Host "██║     ╚██████╔╝███████║   ██║   ╚██████╔╝██║  ██║███████╗███████║" -ForegroundColor Cyan
    Write-Host "╚═╝      ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  PostgreSQL 17 + Prometheus + Grafana - Gestión de Ambientes" -ForegroundColor White
    Write-Host ""
}

function Show-Menu {
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host "  MENÚ PRINCIPAL" -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  🔵 [1] Development  - Desarrollo local (1GB RAM)" -ForegroundColor White
    Write-Host "  🟡 [2] Testing      - CI/CD sin persistencia (512MB RAM)" -ForegroundColor White
    Write-Host "  🟢 [3] Production   - Alta carga y performance (4-8GB RAM)" -ForegroundColor White
    Write-Host "  🟣 [4] Analytics    - Queries complejas (2-4GB RAM)" -ForegroundColor White
    Write-Host ""
    Write-Host "  📊 [5] Ver estado de todos los ambientes" -ForegroundColor Yellow
    Write-Host "  🛑 [6] Detener todos los ambientes" -ForegroundColor Red
    Write-Host "  🗑️  [7] Eliminar todo (incluyendo datos)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  ℹ️  [8] Ayuda e información" -ForegroundColor Cyan
    Write-Host "  ❌ [9] Salir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Start-Environment {
    param([string]$Environment)
    
    $templates = @{
        "1" = @{Name="Development"; File="development.yml"; Script="start-development.ps1"}
        "2" = @{Name="Testing"; File="testing.yml"; Script="start-testing.ps1"}
        "3" = @{Name="Production"; File="production.yml"; Script="start-production.ps1"}
        "4" = @{Name="Analytics"; File="analytics.yml"; Script="start-analytics.ps1"}
    }
    
    if ($templates.ContainsKey($Environment)) {
        $env = $templates[$Environment]
        Write-Host ""
        Write-Host "🚀 Iniciando ambiente: $($env.Name)" -ForegroundColor Green
        Write-Host ""
        
        & ".\$($env.Script)"
    }
}

function Show-AllStatus {
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host "  ESTADO DE TODOS LOS AMBIENTES" -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    $environments = @(
        @{Name="Development"; Containers=@("postgres_dev", "grafana_dev", "prometheus_dev", "postgres_exporter_dev")}
        @{Name="Testing"; Containers=@("postgres_test", "grafana_test", "prometheus_test", "postgres_exporter_test")}
        @{Name="Production"; Containers=@("postgres_prod", "grafana_prod", "prometheus_prod", "postgres_exporter_prod")}
        @{Name="Analytics"; Containers=@("postgres_analytics", "grafana_analytics", "prometheus_analytics", "postgres_exporter_analytics")}
    )
    
    foreach ($env in $environments) {
        Write-Host "  $($env.Name):" -ForegroundColor Yellow
        $running = 0
        foreach ($container in $env.Containers) {
            $status = docker ps -a --filter "name=$container" --format "{{.Status}}" 2>$null
            if ($status -like "*Up*") {
                Write-Host "    ✅ $container - Running" -ForegroundColor Green
                $running++
            } elseif ($status) {
                Write-Host "    🔴 $container - Stopped" -ForegroundColor Red
            }
        }
        if ($running -eq 0) {
            Write-Host "    ⚪ No hay contenedores corriendo" -ForegroundColor Gray
        }
        Write-Host ""
    }
    
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Stop-AllEnvironments {
    Write-Host ""
    Write-Host "🛑 Deteniendo todos los ambientes..." -ForegroundColor Yellow
    Write-Host ""
    
    $templates = @("development.yml", "testing.yml", "production.yml", "analytics.yml")
    
    foreach ($template in $templates) {
        $envName = $template -replace ".yml", ""
        Write-Host "  Deteniendo $envName..." -ForegroundColor Gray
        docker-compose -f "templates/$template" stop 2>$null
    }
    
    Write-Host ""
    Write-Host "✅ Todos los ambientes detenidos" -ForegroundColor Green
    Write-Host ""
}

function Remove-AllEnvironments {
    Write-Host ""
    Write-Host "⚠️  ADVERTENCIA: Esta acción eliminará TODOS los datos" -ForegroundColor Red
    Write-Host ""
    Write-Host "¿Estás seguro? Escribe 'ELIMINAR' para confirmar: " -ForegroundColor Yellow -NoNewline
    $confirm = Read-Host
    
    if ($confirm -eq "ELIMINAR") {
        Write-Host ""
        Write-Host "🗑️  Eliminando todos los ambientes y datos..." -ForegroundColor Red
        Write-Host ""
        
        $templates = @("development.yml", "testing.yml", "production.yml", "analytics.yml")
        
        foreach ($template in $templates) {
            $envName = $template -replace ".yml", ""
            Write-Host "  Eliminando $envName..." -ForegroundColor Gray
            docker-compose -f "templates/$template" down -v 2>$null
        }
        
        Write-Host ""
        Write-Host "✅ Todos los ambientes eliminados" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
        Write-Host ""
    }
}

function Show-Help {
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host "  AYUDA E INFORMACIÓN" -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📚 Documentación disponible:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  • GUIA-COMPLETA.md       - Guía completa de uso" -ForegroundColor White
    Write-Host "  • QUICK-START.md         - Inicio rápido" -ForegroundColor White
    Write-Host "  • STRUCTURE.md           - Estructura del proyecto" -ForegroundColor White
    Write-Host "  • README.md              - Documentación general" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 Scripts disponibles:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  • start-development.ps1  - Iniciar desarrollo" -ForegroundColor White
    Write-Host "  • start-testing.ps1      - Iniciar testing" -ForegroundColor White
    Write-Host "  • start-production.ps1   - Iniciar producción" -ForegroundColor White
    Write-Host "  • start-analytics.ps1    - Iniciar analytics" -ForegroundColor White
    Write-Host ""
    Write-Host "📊 Paneles de Grafana:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. PostgreSQL Overview         - Vista general" -ForegroundColor White
    Write-Host "  2. PostgreSQL Checkpoints      - Checkpoints y WAL" -ForegroundColor White
    Write-Host "  3. PostgreSQL Configuration    - Configuración actual" -ForegroundColor White
    Write-Host "  4. PostgreSQL Performance I/O  - I/O y performance" -ForegroundColor White
    Write-Host "  5. PostgreSQL Queries & Locks  - Queries y bloqueos" -ForegroundColor White
    Write-Host "  6. PostgreSQL Tables & Indexes - Tablas e índices" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 Comandos Docker útiles:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Ver logs:      docker logs -f <container_name>" -ForegroundColor Gray
    Write-Host "  Conectar:      docker exec -it postgres_dev psql -U dev_user -d dev_database" -ForegroundColor Gray
    Write-Host "  Reiniciar:     docker restart <container_name>" -ForegroundColor Gray
    Write-Host "  Stats:         docker stats" -ForegroundColor Gray
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Navegar al directorio del script
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Loop principal
do {
    Show-Banner
    Show-Menu
    
    Write-Host "Selecciona una opción: " -ForegroundColor Yellow -NoNewline
    $option = Read-Host
    
    switch ($option) {
        "1" { Start-Environment "1" }
        "2" { Start-Environment "2" }
        "3" { Start-Environment "3" }
        "4" { Start-Environment "4" }
        "5" { Show-AllStatus }
        "6" { Stop-AllEnvironments }
        "7" { Remove-AllEnvironments }
        "8" { Show-Help }
        "9" { 
            Write-Host ""
            Write-Host "👋 ¡Hasta luego!" -ForegroundColor Cyan
            Write-Host ""
            exit 
        }
        default { 
            Write-Host ""
            Write-Host "❌ Opción inválida" -ForegroundColor Red
            Write-Host ""
        }
    }
    
    if ($option -ne "9") {
        Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    
} while ($true)
