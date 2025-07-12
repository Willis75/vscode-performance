# Contribuir a VS Code Performance Optimizer

¡Gracias por tu interés en contribuir! Este proyecto busca optimizar VS Code para máximo rendimiento.

## 🚀 Cómo Contribuir

### 🐛 Reportar Bugs
1. Verifica que el bug no esté ya reportado en [Issues](https://github.com/Willis75/vscode-performance/issues)
2. Crea un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Configuración de tu sistema (OS, RAM, VS Code version)
   - Screenshots si es relevante

### ✨ Proponer Mejoras
1. Abre un issue describiendo tu idea
2. Explica cómo mejorará el rendimiento
3. Proporciona evidencia/benchmarks si es posible

### 🔧 Enviar Pull Requests

#### Antes de empezar:
1. Fork el repositorio
2. Clona tu fork localmente
3. Crea una rama descriptiva: `git checkout -b feature/nueva-optimizacion`

#### Criterios para contribuciones:
- **Rendimiento**: Debe mejorar significativamente el rendimiento
- **Compatibilidad**: Debe funcionar en Windows 10/11
- **Documentación**: Incluir comentarios explicativos
- **Testing**: Probar en diferentes escenarios

#### Tipos de contribuciones bienvenidas:
- 🎯 Nuevas optimizaciones de `settings.json`
- 🧹 Mejoras a scripts de limpieza
- 📚 Mejoras a documentación
- 🔧 Optimizaciones para casos específicos
- 🐛 Corrección de bugs

### 📝 Estilo de Código

#### PowerShell:
```powershell
# Usar comentarios descriptivos
Write-Host "✅ Descripción clara de la acción" -ForegroundColor Green

# Manejo de errores
try {
    # Código aquí
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}
```

#### JSON:
```json
{
  // Comentarios explicativos en configuración
  "editor.quickSuggestions": false,  // Reduce uso de CPU
}
```

#### Markdown:
- Usar emojis para mejorar legibilidad
- Títulos descriptivos
- Secciones bien estructuradas
- Enlaces funcionales

### 🧪 Testing

Antes de enviar un PR, verifica:

1. **Funcionalidad básica**:
   ```powershell
   # Aplicar configuración
   Copy-Item settings.json "$env:APPDATA\Code\User\settings.json" -Force
   
   # Verificar que VS Code arranca sin errores
   code --new-window
   ```

2. **Scripts de automatización**:
   ```powershell
   # Probar configuración automática
   .\setup-auto-startup.ps1
   
   # Verificar limpieza
   .\auto-cleanup-startup.ps1
   ```

3. **Rendimiento**:
   - Medir uso de CPU/RAM antes y después
   - Probar con proyectos grandes (1000+ archivos)
   - Verificar tiempo de inicio

### 📊 Benchmarking

Para contribuciones de rendimiento, incluir:

```powershell
# Ejemplo de medición
$before = Get-Process -Name "Code" | Measure-Object WorkingSet -Sum
# ... aplicar optimización ...
$after = Get-Process -Name "Code" | Measure-Object WorkingSet -Sum
$improvement = ($before.Sum - $after.Sum) / $before.Sum * 100
Write-Host "Mejora de memoria: $([math]::Round($improvement, 1))%"
```

### 🏷️ Formato de Commits

```
tipo(scope): descripción corta

Descripción más detallada si es necesario.

- Cambio específico 1
- Cambio específico 2

Fixes #123
```

**Tipos:**
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `perf`: Mejora de rendimiento
- `refactor`: Refactorización
- `test`: Añadir/modificar tests

### 📋 Checklist para PRs

- [ ] El código sigue las convenciones del proyecto
- [ ] Se han añadido comentarios explicativos
- [ ] La documentación está actualizada
- [ ] Se han realizado pruebas básicas
- [ ] El commit message es descriptivo
- [ ] No se incluyen archivos temporales/log

### 🎯 Áreas Prioritarias

Contribuciones especialmente bienvenidas en:

1. **Optimizaciones por tipo de desarrollo**:
   - Frontend (React, Vue, Angular)
   - Backend (Node.js, Python, etc.)
   - Móvil (React Native, Flutter)

2. **Compatibilidad**:
   - Diferentes versiones de VS Code
   - Variantes de Windows
   - Equipos con recursos muy limitados

3. **Automatización**:
   - Detección automática de configuración óptima
   - Métricas de rendimiento en tiempo real
   - Auto-ajuste según uso

### 📞 Comunicación

- **Issues**: Para bugs y propuestas
- **Discussions**: Para preguntas generales
- **PR Reviews**: Para feedback técnico

### 🙏 Reconocimientos

Todos los contribuidores serán reconocidos en el README principal.

¡Gracias por ayudar a hacer VS Code más rápido para todos! 🚀
