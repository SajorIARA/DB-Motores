#!/usr/bin/env pwsh
# Script para generar actividad continua sin necesidad de políticas de ejecución

$ErrorActionPreference = 'Stop'
Write-Host "`n=== Iniciando Generación de Actividad Continua ===" -ForegroundColor Green
Write-Host "Este script generará actividad durante 10 minutos" -ForegroundColor Yellow
Write-Host "Presione Ctrl+C para detener manualmente`n" -ForegroundColor Cyan

$startTime = Get-Date
$duration = New-TimeSpan -Minutes 10
$cycleNumber = 0

while ((Get-Date) - $startTime -lt $duration) {
    $cycleNumber++
    
    try {
        # INSERT 15 pedidos
        $null = docker exec postgres_dev psql -U dev_user -d dev_database -c @"
INSERT INTO pedidos (usuario_id, total, estado) 
SELECT 
    (random() * 99 + 1)::int,
    (random() * 1000 + 10)::numeric(10,2),
    (ARRAY['pendiente', 'procesando', 'completado'])[floor(random() * 3 + 1)::int]
FROM generate_series(1, 15);
"@
        
        # UPDATE 5 pedidos
        $null = docker exec postgres_dev psql -U dev_user -d dev_database -c @"
UPDATE pedidos 
SET estado = 'completado', total = total * 1.05
WHERE id IN (SELECT id FROM pedidos WHERE estado != 'cancelado' ORDER BY random() LIMIT 5);
"@
        
        # DELETE 3 pedidos
        $null = docker exec postgres_dev psql -U dev_user -d dev_database -c @"
DELETE FROM pedidos 
WHERE id IN (SELECT id FROM pedidos ORDER BY random() LIMIT 3);
"@
        
        if ($cycleNumber % 5 -eq 0) {
            $stats = docker exec postgres_dev psql -U dev_user -d dev_database -t -c "SELECT COUNT(*) as count FROM pedidos;"
            $elapsed = ((Get-Date) - $startTime).TotalSeconds
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Ciclo $cycleNumber | Pedidos: $($stats.Trim()) | Tiempo: $([math]::Round($elapsed))s" -ForegroundColor Cyan
        }
        
        Start-Sleep -Seconds 10
    }
    catch {
        Write-Host "Error en ciclo $cycleNumber : $_" -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}

$finalCount = docker exec postgres_dev psql -U dev_user -d dev_database -t -c "SELECT COUNT(*) FROM pedidos;"
Write-Host "`n=== Actividad Completada ===" -ForegroundColor Green
Write-Host "Ciclos ejecutados: $cycleNumber" -ForegroundColor Yellow
Write-Host "Pedidos finales: $($finalCount.Trim())" -ForegroundColor Yellow
