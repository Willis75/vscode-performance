# Script para DESACTIVAR la limpieza automática de VS Code
# Ejecutar como Administrador si quieres eliminar todo

Write-Host "🛑 Desactivando limpieza automática de VS Code..." -ForegroundColor Yellow

$taskName = "VSCode-AutoCleanup"
$registryName = "VSCodeOptimizer"
$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\VSCode Optimizer.lnk"

try {
    # 1. Eliminar tarea programada
    Write-Host "📅 Eliminando tarea programada..." -ForegroundColor Gray
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($task) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Host "✅ Tarea programada eliminada" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No se encontró tarea programada" -ForegroundColor Gray
    }
    
    # 2. Eliminar entrada del registro
    Write-Host "🔑 Eliminando entrada del registro..." -ForegroundColor Gray
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $exists = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
    if ($exists) {
        Remove-ItemProperty -Path $registryPath -Name $registryName
        Write-Host "✅ Entrada del registro eliminada" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No se encontró entrada en registro" -ForegroundColor Gray
    }
    
    # 3. Eliminar acceso directo
    Write-Host "📂 Eliminando acceso directo..." -ForegroundColor Gray
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "✅ Acceso directo eliminado" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No se encontró acceso directo" -ForegroundColor Gray
    }
    
    Write-Host "`n🎉 Limpieza automática desactivada completamente" -ForegroundColor Green
    Write-Host "💡 Los archivos de configuración siguen en: C:\Users\wumni\vscode_config" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPresiona Enter para continuar..."
Read-Host
