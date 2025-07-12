# Script para Configurar Limpieza Automática de VS Code
# Ejecutar SOLO UNA VEZ como Administrador

Write-Host "🔧 Configurando limpieza automática de VS Code..." -ForegroundColor Cyan

# Rutas importantes
$scriptPath = "C:\Users\wumni\vscode_config\auto-cleanup-startup.ps1"
$taskName = "VSCode-AutoCleanup"

# Verificar que el script existe
if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ Error: No se encuentra el script en $scriptPath" -ForegroundColor Red
    exit 1
}

try {
    # === OPCIÓN 1: TAREA PROGRAMADA (RECOMENDADO) ===
    Write-Host "`n📅 Creando tarea programada..." -ForegroundColor Yellow
    
    # Eliminar tarea si ya existe
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    
    # Crear acción
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`" -Silent"
    
    # Crear trigger (al iniciar sesión + cada 6 horas)
    $triggerStartup = New-ScheduledTaskTrigger -AtLogOn
    $triggerRepeat = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 6)
    
    # Crear configuración
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    
    # Registrar tarea
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $triggerStartup, $triggerRepeat -Settings $settings -Description "Limpieza automática de VS Code para optimizar rendimiento"
    
    Write-Host "✅ Tarea programada '$taskName' creada exitosamente" -ForegroundColor Green
    Write-Host "   📋 Se ejecutará: Al iniciar sesión + cada 6 horas" -ForegroundColor Gray
    
    # === OPCIÓN 2: REGISTRO DE WINDOWS (ALTERNATIVA) ===
    Write-Host "`n🔑 Configurando entrada en el Registro..." -ForegroundColor Yellow
    
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $registryName = "VSCodeOptimizer"
    $registryValue = "PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`" -Silent"
    
    Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -ErrorAction SilentlyContinue
    Write-Host "✅ Entrada en registro creada" -ForegroundColor Green
    
    # === OPCIÓN 3: CARPETA INICIO (SIMPLE) ===
    Write-Host "`n📂 Creando acceso directo en Inicio..." -ForegroundColor Yellow
    
    $startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $shortcutPath = "$startupFolder\VSCode Optimizer.lnk"
    
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "PowerShell.exe"
    $shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`" -Silent"
    $shortcut.Description = "Optimizador automático de VS Code"
    $shortcut.WindowStyle = 7  # Minimized
    $shortcut.Save()
    
    Write-Host "✅ Acceso directo creado en carpeta Inicio" -ForegroundColor Green
    
    # Mostrar resumen
    Write-Host "`n🎉 ¡Configuración automática completada!" -ForegroundColor Green
    Write-Host "`n📋 Métodos configurados:" -ForegroundColor Cyan
    Write-Host "   1. ✅ Tarea Programada (recomendado)" -ForegroundColor White
    Write-Host "   2. ✅ Registro de Windows" -ForegroundColor White  
    Write-Host "   3. ✅ Carpeta de Inicio" -ForegroundColor White
    
    Write-Host "`n⏰ Frecuencia de ejecución:" -ForegroundColor Cyan
    Write-Host "   • Al iniciar sesión de usuario" -ForegroundColor White
    Write-Host "   • Cada 6 horas (solo tarea programada)" -ForegroundColor White
    
    Write-Host "`n🔧 Para gestionar:" -ForegroundColor Cyan
    Write-Host "   • Tareas: Abrir 'Programador de tareas' → '$taskName'" -ForegroundColor White
    Write-Host "   • Registro: Ejecutar 'msconfig' → Pestaña 'Inicio'" -ForegroundColor White
    Write-Host "   • Carpeta: $startupFolder" -ForegroundColor White
    
} catch {
    Write-Host "❌ Error durante la configuración: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Asegúrate de ejecutar como Administrador" -ForegroundColor Yellow
}

Write-Host "`n🔄 Presiona Enter para continuar..." -ForegroundColor Gray
Read-Host
