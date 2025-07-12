# Script de Optimizacion de VS Code para Windows
# Ejecutar en PowerShell como Administrador

Write-Host "Iniciando optimizacion de VS Code..." -ForegroundColor Green

# 1. Limpiar cache de VS Code
Write-Host "Limpiando cache de VS Code..." -ForegroundColor Yellow
$vscodePaths = @(
    "$env:APPDATA\Code\logs",
    "$env:APPDATA\Code\CachedExtensions",
    "$env:APPDATA\Code\CachedExtensionVSIXs",
    "$env:APPDATA\Code\logs",
    "$env:APPDATA\Code\User\workspaceStorage"
)

foreach ($path in $vscodePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Limpiado: $path" -ForegroundColor Green
    }
}

# 2. Limpiar archivos temporales del sistema
Write-Host "Limpiando archivos temporales del sistema..." -ForegroundColor Yellow
$tempPaths = @(
    "$env:TEMP\*",
    "$env:LOCALAPPDATA\Temp\*"
)

foreach ($path in $tempPaths) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}

# 3. Configurar prioridad de proceso de VS Code
Write-Host "Configurando prioridad de proceso..." -ForegroundColor Yellow

# Crear script para establecer prioridad alta a VS Code
$priorityScript = @"
# Script para establecer prioridad alta a VS Code
`$processes = Get-Process -Name "Code" -ErrorAction SilentlyContinue
foreach (`$process in `$processes) {
    `$process.PriorityClass = "High"
    Write-Host "Prioridad establecida para proceso VS Code PID: `$(`$process.Id)"
}
"@

$priorityScript | Out-File -FilePath "$env:USERPROFILE\Documents\vscode-priority.ps1" -Encoding UTF8

# 4. Optimizar configuracion de Windows para VS Code
Write-Host "Optimizando configuracion de Windows..." -ForegroundColor Yellow

# Desactivar Windows Defender para carpeta de VS Code (opcional)
$vscodePath = "${env:LOCALAPPDATA}\Programs\Microsoft VS Code"
if (Test-Path $vscodePath) {
    try {
        Add-MpPreference -ExclusionPath $vscodePath -ErrorAction SilentlyContinue
        Write-Host "VS Code excluido de Windows Defender" -ForegroundColor Green
    } catch {
        Write-Host "No se pudo excluir VS Code de Windows Defender (requiere privilegios de admin)" -ForegroundColor Yellow
    }
}

# 5. Configurar memoria virtual
Write-Host "Informacion de memoria virtual..." -ForegroundColor Yellow
$pageFile = Get-WmiObject -Class Win32_PageFileUsage
Write-Host "Archivo de paginación actual: $($pageFile.AllocatedBaseSize) MB"
Write-Host "Recomendacion: Configurar archivo de paginacion a 4GB-8GB para mejor rendimiento"

# 6. Crear script de limpieza automática
$cleanupScript = @"
# Script de limpieza automática para VS Code
# Ejecutar semanalmente

Write-Host "Ejecutando limpieza automatica de VS Code..."

# Limpiar logs antiguos
`$logsPath = "`$env:APPDATA\Code\logs"
if (Test-Path `$logsPath) {
    Get-ChildItem `$logsPath | Where-Object { `$_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Recurse -Force
}

# Limpiar workspace storage no utilizado
`$workspacePath = "`$env:APPDATA\Code\User\workspaceStorage"
if (Test-Path `$workspacePath) {
    Get-ChildItem `$workspacePath | Where-Object { `$_.LastAccessTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Recurse -Force
}

Write-Host "Limpieza completada"
"@

$cleanupScript | Out-File -FilePath "$env:USERPROFILE\Documents\vscode-cleanup.ps1" -Encoding UTF8

# 7. Mostrar informacion del sistema
Write-Host "Informacion del sistema:" -ForegroundColor Cyan
$memory = Get-WmiObject -Class Win32_ComputerSystem
$cpu = Get-WmiObject -Class Win32_Processor
Write-Host "RAM Total: $([math]::Round($memory.TotalPhysicalMemory / 1GB, 2)) GB"
Write-Host "CPU: $($cpu.Name)"
Write-Host "Cores: $($cpu.NumberOfCores)"

Write-Host "`nOptimizacion completada!" -ForegroundColor Green
Write-Host "Scripts creados en Documents:" -ForegroundColor Yellow
Write-Host "   - vscode-priority.ps1 (establecer prioridad alta)"
Write-Host "   - vscode-cleanup.ps1 (limpieza automática)"

Write-Host "`nReinicia VS Code para aplicar todos los cambios" -ForegroundColor Red
