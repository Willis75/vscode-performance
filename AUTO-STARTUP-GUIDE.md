# Guía Completa - Automatización de Limpieza de VS Code

## 🚀 ¿Qué he creado para ti?

### 📁 **Nuevos archivos:**
1. **`auto-cleanup-startup.ps1`** - Script principal de limpieza automática
2. **`setup-auto-startup.ps1`** - Configurador automático (ejecutar UNA VEZ)
3. **`remove-auto-startup.ps1`** - Para desactivar todo si quieres

---

## ⚡ **Instalación RÁPIDA (Recomendada)**

### 🔧 **Opción 1: Configuración Automática Completa**

Ejecuta en PowerShell **como Administrador**:

```powershell
cd "C:\Users\wumni\vscode_config"
.\setup-auto-startup.ps1
```

**Esto configura automáticamente:**
- ✅ Tarea programada (cada 6 horas)
- ✅ Entrada en registro (al iniciar Windows)
- ✅ Acceso directo en carpeta Inicio

---

## 🎯 **Instalación MANUAL (Si prefieres control)**

### 📅 **Método 1: Tarea Programada (RECOMENDADO)**

```powershell
# 1. Abrir Programador de tareas como Administrador
taskschd.msc

# 2. Crear tarea básica:
#    - Nombre: "VSCode AutoCleanup"
#    - Trigger: "Al iniciar sesión"
#    - Acción: "Iniciar programa"
#    - Programa: PowerShell.exe
#    - Argumentos: -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\wumni\vscode_config\auto-cleanup-startup.ps1" -Silent
```

### 🔑 **Método 2: Registro de Windows**

```powershell
# Agregar al registro para inicio automático
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$name = "VSCodeOptimizer"
$value = 'PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\wumni\vscode_config\auto-cleanup-startup.ps1" -Silent'

Set-ItemProperty -Path $regPath -Name $name -Value $value
```

### 📂 **Método 3: Carpeta de Inicio (MÁS SIMPLE)**

```powershell
# Crear acceso directo en carpeta de inicio
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Copia el archivo auto-cleanup-startup.ps1 aquí
# O crea un .bat que lo ejecute
```

---

## ⏰ **¿Cuándo se ejecuta la limpieza automática?**

### 🔄 **Frecuencia de ejecución:**
- **Al iniciar sesión** en Windows
- **Cada 6 horas** (solo tarea programada)
- **Modo silencioso** - no molesta

### 🧹 **Qué limpia automáticamente:**
- Caché de VS Code (archivos +3 días)
- Workspace storage (archivos +30 días)
- Archivos temporales relacionados
- Establece prioridad alta a VS Code
- Optimiza memoria si está baja

---

## 🎛️ **Gestión y Control**

### ✅ **Para verificar que está funcionando:**

```powershell
# Ver si la tarea está programada
Get-ScheduledTask -TaskName "VSCode-AutoCleanup"

# Ver log de ejecuciones
Get-Content "$env:TEMP\vscode-auto-cleanup.log"

# Ver entrada en registro
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "VSCodeOptimizer"
```

### 🛑 **Para desactivar todo:**

```powershell
cd "C:\Users\wumni\vscode_config"
.\remove-auto-startup.ps1
```

### 🔧 **Para modificar frecuencia:**

Edita el archivo `setup-auto-startup.ps1` y cambia:
```powershell
# De cada 6 horas a cada 12 horas:
$triggerRepeat = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 12)
```

---

## 📊 **Ventajas de cada método:**

| Método | Ventajas | Desventajas |
|--------|----------|-------------|
| **Tarea Programada** | ✅ Más control, repetición automática, logs | ❌ Requiere permisos admin |
| **Registro** | ✅ Simple, siempre funciona | ❌ Solo al inicio, visible en msconfig |
| **Carpeta Inicio** | ✅ Muy simple, fácil de eliminar | ❌ Solo al inicio, puede ser visible |

---

## 🚨 **Importante:**

### ✅ **Ventajas:**
- **Totalmente automático** - no requiere intervención
- **Modo silencioso** - no interrumpe tu trabajo
- **Logs detallados** - puedes ver qué se limpió
- **Seguro** - solo elimina archivos temporales/caché

### ⚠️ **Consideraciones:**
- Requiere permisos de administrador para configuración inicial
- Se ejecuta en segundo plano (uso mínimo de recursos)
- Puedes desactivarlo cuando quieras

---

## 🎉 **Recomendación:**

**USA LA CONFIGURACIÓN AUTOMÁTICA:**
```powershell
.\setup-auto-startup.ps1
```

¡Es la forma más fácil y completa! Configura todo automáticamente y tu VS Code siempre estará optimizado. 🚀
