# Extensiones recomendadas para VS Code - Configuración optimizada
# Mantén solo las extensiones esenciales para reducir el consumo de recursos

## Extensiones básicas esenciales (solo instalar las que realmente necesites):

### Para desarrollo web general:
- ms-vscode.vscode-typescript-next (TypeScript)
- bradlc.vscode-tailwindcss (si usas Tailwind CSS)
- esbenp.prettier-vscode (formateo de código)

### Para Python:
- ms-python.python (solo si desarrollas en Python)

### Para productividad:
- ms-vscode.vscode-json (manejo de JSON)
- redhat.vscode-yaml (si trabajas con YAML)

## Extensiones a EVITAR o DESINSTALAR para mejor rendimiento:

❌ Extensiones pesadas que consumen muchos recursos:
- GitHub Copilot (muy pesado en CPU y memoria)
- Live Server (mantiene proceso en background)
- Auto Rename Tag (procesa todo el HTML constantemente)
- Bracket Pair Colorizer (reemplazado por funcionalidad nativa)
- Path Intellisense (pesado en proyectos grandes)
- IntelliCode (consume mucha memoria)
- GitLens (muy pesado para repositorios grandes)

❌ Temas y iconos innecesarios:
- Material Icon Theme
- One Dark Pro
- Múltiples temas instalados

❌ Extensiones de sintaxis para lenguajes que no usas:
- Extensiones de Go, Rust, Java, etc. si no las necesitas

## Comandos para limpiar extensiones:

```bash
# Listar todas las extensiones instaladas
code --list-extensions

# Desinstalar una extensión específica
code --uninstall-extension EXTENSION_ID

# Ejemplo para desinstalar extensiones pesadas:
code --uninstall-extension GitHub.copilot
code --uninstall-extension eamodio.gitlens
code --uninstall-extension ms-vscode.vscode-typescript-next
```

## Configuración adicional para extensiones:

En settings.json, añade estas configuraciones para las extensiones que mantengas:

```json
{
  // Desactivar extensiones automáticamente en archivos grandes
  "extensions.autoUpdate": false,
  "extensions.autoCheckUpdates": false,
  
  // Configurar Prettier para ser menos intensivo
  "prettier.requireConfig": true,
  "prettier.useEditorConfig": false,
  
  // Limitar IntelliSense para Python (si lo usas)
  "python.analysis.autoImportCompletions": false,
  "python.analysis.indexing": false
}
```
