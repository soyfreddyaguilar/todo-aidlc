#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Script de verificación de requisitos para el proyecto TODO App (POC)
    Verifica que todas las dependencias estén instaladas correctamente

.DESCRIPTION
    Este script verifica:
    - Git
    - Node.js
    - npm
    - uv
    - Claude Code (opcional)
    - Dependencias del proyecto (node_modules)

.EXAMPLE
    .\verificar-requisitos.ps1
#>

Write-Host "🔍 Verificando requisitos del proyecto TODO App (POC)..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Inicializar contadores
$OK = 0
$WARNINGS = 0
$ERRORS = 0

# Función auxiliar para mostrar resultados
function Test-Command {
    param(
        [string]$Name,
        [string]$Command,
        [string]$VersionParam = "--version",
        [string]$MinVersion = ""
    )

    try {
        $result = & $Command $VersionParam 2>&1 | Select-Object -First 1
        if ($result) {
            Write-Host "✅ $Name" -ForegroundColor Green
            Write-Host "   $result" -ForegroundColor Gray
            $script:OK++
            return $true
        }
        else {
            Write-Host "❌ $Name - No se pudo obtener versión" -ForegroundColor Red
            $script:ERRORS++
            return $false
        }
    }
    catch {
        Write-Host "❌ $Name - NO ENCONTRADO" -ForegroundColor Red
        Write-Host "   Error: $_" -ForegroundColor Red
        $script:ERRORS++
        return $false
    }
}

# ============================================================================
# 1. GIT
# ============================================================================
Write-Host "1️⃣  Git" -ForegroundColor Yellow
Test-Command -Name "Git" -Command "git" | Out-Null
Write-Host ""

# ============================================================================
# 2. NODE.JS
# ============================================================================
Write-Host "2️⃣  Node.js" -ForegroundColor Yellow
Test-Command -Name "Node.js" -Command "node" | Out-Null
Write-Host ""

# ============================================================================
# 3. NPM
# ============================================================================
Write-Host "3️⃣  npm" -ForegroundColor Yellow
Test-Command -Name "npm" -Command "npm" | Out-Null
Write-Host ""

# ============================================================================
# 4. UV
# ============================================================================
Write-Host "4️⃣  uv (Gestor Python)" -ForegroundColor Yellow
if (Test-Command -Name "uv" -Command "uv") {
    Write-Host "   ℹ️  Necesario para servidores MCP de AWS" -ForegroundColor Gray
}
Write-Host ""

# ============================================================================
# 5. CLAUDE CODE (OPCIONAL)
# ============================================================================
Write-Host "5️⃣  Claude Code (Opcional)" -ForegroundColor Yellow
try {
    $claudeVersion = & claude --version 2>&1 | Select-Object -First 1
    if ($claudeVersion) {
        Write-Host "✅ Claude Code (Global)" -ForegroundColor Green
        Write-Host "   $claudeVersion" -ForegroundColor Gray
        $script:OK++
    }
    else {
        Write-Host "⚠️  Claude Code - No instalado globalmente (opcional)" -ForegroundColor Yellow
        $script:WARNINGS++
    }
}
catch {
    Write-Host "⚠️  Claude Code - No instalado globalmente (opcional)" -ForegroundColor Yellow
    Write-Host "   Instálalo con: npm install -g @anthropic-ai/claude-code" -ForegroundColor Gray
    $script:WARNINGS++
}
Write-Host ""

# ============================================================================
# 6. DIRECTORIO DEL PROYECTO
# ============================================================================
Write-Host "6️⃣  Directorios del Proyecto" -ForegroundColor Yellow

$projectPath = "projects/todo-app"
if (Test-Path $projectPath) {
    Write-Host "✅ Directorio del proyecto encontrado" -ForegroundColor Green
    Write-Host "   $projectPath" -ForegroundColor Gray
    $script:OK++
}
else {
    Write-Host "❌ Directorio del proyecto NO encontrado" -ForegroundColor Red
    Write-Host "   $projectPath" -ForegroundColor Red
    $script:ERRORS++
}
Write-Host ""

# ============================================================================
# 7. PACKAGE.JSON
# ============================================================================
Write-Host "7️⃣  Configuración del Proyecto" -ForegroundColor Yellow

if (Test-Path "$projectPath/package.json") {
    Write-Host "✅ package.json encontrado" -ForegroundColor Green
    $script:OK++
}
else {
    Write-Host "❌ package.json NO encontrado" -ForegroundColor Red
    $script:ERRORS++
}

if (Test-Path "$projectPath/package-lock.json") {
    Write-Host "✅ package-lock.json encontrado" -ForegroundColor Green
    $script:OK++
}
else {
    Write-Host "⚠️  package-lock.json no encontrado (se creará con npm install)" -ForegroundColor Yellow
    $script:WARNINGS++
}
Write-Host ""

# ============================================================================
# 8. NODE_MODULES
# ============================================================================
Write-Host "8️⃣  Dependencias Instaladas" -ForegroundColor Yellow

if (Test-Path "$projectPath/node_modules") {
    Write-Host "✅ node_modules encontrado" -ForegroundColor Green
    Write-Host "   Dependencias ya instaladas" -ForegroundColor Gray
    $script:OK++

    # Verificar dependencias clave
    Write-Host ""
    Write-Host "   Verificando dependencias clave..." -ForegroundColor Gray

    $keyDeps = @('react', 'react-dom', 'vite', 'vitest', 'prettier', 'eslint')
    foreach ($dep in $keyDeps) {
        if (Test-Path "$projectPath/node_modules/$dep") {
            Write-Host "   ✅ $dep" -ForegroundColor Green
        }
        else {
            Write-Host "   ❌ $dep - FALTA instalar" -ForegroundColor Red
            $script:ERRORS++
        }
    }
}
else {
    Write-Host "⚠️  node_modules NO encontrado" -ForegroundColor Yellow
    Write-Host "   Ejecuta: npm install" -ForegroundColor Cyan
    $script:WARNINGS++
}
Write-Host ""

# ============================================================================
# 9. ARCHIVOS DE CONFIGURACIÓN
# ============================================================================
Write-Host "9️⃣  Archivos de Configuración" -ForegroundColor Yellow

$configFiles = @(
    '.mcp.json',
    '.claude/CLAUDE.md',
    'aidlc/spaces/default/memory/org.md'
)

foreach ($file in $configFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
        $script:OK++
    }
    else {
        Write-Host "⚠️  $file - no encontrado" -ForegroundColor Yellow
        $script:WARNINGS++
    }
}
Write-Host ""

# ============================================================================
# 10. RESUMEN
# ============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📊 RESUMEN" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Correcto:    $OK" -ForegroundColor Green
Write-Host "⚠️  Advertencias: $WARNINGS" -ForegroundColor Yellow
Write-Host "❌ Errores:     $ERRORS" -ForegroundColor Red
Write-Host ""

# ============================================================================
# RECOMENDACIONES
# ============================================================================
if ($ERRORS -eq 0 -and $WARNINGS -eq 0) {
    Write-Host "✨ ¡PERFECTO! Tu ambiente está completamente configurado." -ForegroundColor Green
    Write-Host ""
    Write-Host "Próximos pasos:" -ForegroundColor Green
    Write-Host "  1. cd projects/todo-app" -ForegroundColor Cyan
    Write-Host "  2. npm run dev" -ForegroundColor Cyan
    Write-Host "  3. Abre http://localhost:5173/ en tu navegador" -ForegroundColor Cyan
    Write-Host ""
}
elseif ($ERRORS -gt 0) {
    Write-Host "⚠️  Se encontraron ERRORES que necesitan ser solucionados:" -ForegroundColor Red
    Write-Host ""
    Write-Host "Pasos recomendados:" -ForegroundColor Yellow
    Write-Host "  1. Revisa los errores marcados con ❌ arriba" -ForegroundColor Cyan
    Write-Host "  2. Lee INSTALACION.md para instrucciones detalladas" -ForegroundColor Cyan
    Write-Host "  3. Si Git no está instalado: https://git-scm.com/download/win" -ForegroundColor Cyan
    Write-Host "  4. Si Node no está instalado: https://nodejs.org/" -ForegroundColor Cyan
    Write-Host ""
}
else {
    Write-Host "⚠️  Se encontraron algunas advertencias:" -ForegroundColor Yellow
    Write-Host ""

    if (-not (Test-Path "$projectPath/node_modules")) {
        Write-Host "1. Instala las dependencias:" -ForegroundColor Yellow
        Write-Host "   cd projects/todo-app" -ForegroundColor Cyan
        Write-Host "   npm install" -ForegroundColor Cyan
        Write-Host ""
    }

    Write-Host "2. Luego puedes comenzar el desarrollo:" -ForegroundColor Yellow
    Write-Host "   npm run dev" -ForegroundColor Cyan
    Write-Host ""
}

# ============================================================================
# INFORMACIÓN ÚTIL
# ============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📚 INFORMACIÓN ÚTIL" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Comandos útiles del proyecto:" -ForegroundColor Green
Write-Host "  npm run dev           - Inicia servidor de desarrollo" -ForegroundColor Gray
Write-Host "  npm run build         - Construye para producción" -ForegroundColor Gray
Write-Host "  npm run test          - Ejecuta tests" -ForegroundColor Gray
Write-Host "  npm run lint          - Verifica código con linter" -ForegroundColor Gray
Write-Host "  npm run format        - Formatea código con Prettier" -ForegroundColor Gray
Write-Host "  npm run test:coverage - Muestra cobertura de tests" -ForegroundColor Gray
Write-Host ""

Write-Host "Documentación:" -ForegroundColor Green
Write-Host "  - INSTALACION.md          - Guía completa de instalación (este archivo)" -ForegroundColor Gray
Write-Host "  - .claude/CLAUDE.md       - Onboarding para Claude Code" -ForegroundColor Gray
Write-Host "  - projects/todo-app/README.md - README del proyecto React" -ForegroundColor Gray
Write-Host ""

Write-Host "Para más ayuda, ejecuta:" -ForegroundColor Green
Write-Host "  aidlc --doctor   - Verifica el estado del workflow AI-DLC" -ForegroundColor Gray
Write-Host "  aidlc --help     - Muestra opciones disponibles" -ForegroundColor Gray
Write-Host ""

# Retornar código de salida según errores
if ($ERRORS -gt 0) { exit 1 } else { exit 0 }
