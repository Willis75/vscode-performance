# Script de Limpieza Automática de VS Code para Inicio de Windows
# Este script se ejecutará automáticamente al iniciar Windows

param(
    [switch]$Silent = $false
)

# Función para escribir log
function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    
    if (-not $Silent) {
        Write-Host $logMessage -ForegroundColor Green
    }
    
    # Crear log en archivo
    $logPath = "$env:TEMP\vscode-auto-cleanup.log"
    Add-Content -Path $logPath -Value $logMessage
}

try {
    Write-Log "🚀 Iniciando limpieza automática de VS Code..."

    # 1. Limpiar caché de VS Code (solo si existe)
    $vscodeCachePaths = @(
        "$env:APPDATA\Code\logs",
        "$env:APPDATA\Code\CachedExtensions", 
        "$env:APPDATA\Code\CachedExtensionVSIXs"
    )

    foreach ($path in $vscodeCachePaths) {
        if (Test-Path $path) {
            $oldSize = (Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            Get-ChildItem $path | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-3) } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "✅ Limpiado caché: $path"
        }
    }

    # 2. Limpiar workspace storage antiguo (más de 30 días)
    $workspacePath = "$env:APPDATA\Code\User\workspaceStorage"
    if (Test-Path $workspacePath) {
        Get-ChildItem $workspacePath | Where-Object { 
            $_.LastAccessTime -lt (Get-Date).AddDays(-30) 
        } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "✅ Limpiado workspace storage antiguo"
    }

    # 3. Limpiar archivos temporales del sistema
    $tempPaths = @(
        "$env:TEMP\vscode-*",
        "$env:LOCALAPPDATA\Temp\vscode-*"
    )
    
    foreach ($pattern in $tempPaths) {
        Get-ChildItem $pattern -ErrorAction SilentlyContinue | Where-Object { 
            $_.LastWriteTime -lt (Get-Date).AddHours(-6) 
        } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Log "✅ Limpiados archivos temporales"

    # 4. Establecer prioridad alta para VS Code (si está ejecutándose)
    $vscodeProcesses = Get-Process -Name "Code" -ErrorAction SilentlyContinue
    foreach ($process in $vscodeProcesses) {
        try {
            $process.PriorityClass = "High"
            Write-Log "⚡ Prioridad alta establecida para VS Code PID: $($process.Id)"
        } catch {
            Write-Log "⚠️ No se pudo establecer prioridad para PID: $($process.Id)"
        }
    }

    # 5. Verificar y optimizar memoria si es necesario
    $memory = Get-WmiObject -Class Win32_OperatingSystem
    $freeMemoryPercent = ($memory.FreePhysicalMemory / $memory.TotalVisibleMemorySize) * 100
    
    if ($freeMemoryPercent -lt 20) {
        Write-Log "⚠️ Memoria baja detectada ($([math]::Round($freeMemoryPercent, 1))% libre)"
        # Ejecutar recolector de basura
        [System.GC]::Collect()
        Write-Log "🧹 Recolección de basura ejecutada"
    }

    Write-Log "✅ Limpieza automática completada exitosamente"
    
} catch {
    Write-Log "❌ Error durante la limpieza: $($_.Exception.Message)"
}

# Si se ejecuta en modo silencioso, esperar menos tiempo
if ($Silent) {
    Start-Sleep -Seconds 1
} else {
    Write-Host "`n✨ Limpieza completada. Revisa el log en: $env:TEMP\vscode-auto-cleanup.log" -ForegroundColor Cyan
}
