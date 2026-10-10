#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Descarga automáticamente los instaladores necesarios para el proyecto

.DESCRIPTION
    Script que descarga:
    - Git
    - Node.js LTS
    - uv
    - Claude Code (opcional)

.PARAMETER DownloadPath
    Carpeta donde guardar los instaladores (por defecto: $HOME\Downloads\poc-instaladores)

.EXAMPLE
    .\descargar-instaladores.ps1
    .\descargar-instaladores.ps1 -DownloadPath "C:\Instaladores"
#>

param(
    [string]$DownloadPath = "$HOME\Downloads\poc-instaladores"
)

Write-Host "📥 Descargador de Instaladores - TODO App (POC)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Crear carpeta de descargas
if (-not (Test-Path $DownloadPath)) {
    Write-Host "📁 Creando carpeta de descargas: $DownloadPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null
}

Write-Host "📂 Los instaladores se guardarán en:" -ForegroundColor Green
Write-Host "   $DownloadPath" -ForegroundColor Gray
Write-Host ""

$downloaded = 0
$failed = 0

# Función auxiliar para descargar
function Download-File {
    param(
        [string]$Url,
        [string]$FileName,
        [string]$Description
    )

    $FilePath = Join-Path $DownloadPath $FileName

    Write-Host "⏳ Descargando $Description..." -ForegroundColor Yellow
    Write-Host "   URL: $Url" -ForegroundColor Gray

    try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $FilePath -UseBasicParsing -ErrorAction Stop
        $ProgressPreference = 'Continue'

        $size = [math]::Round((Get-Item $FilePath).Length / 1MB, 2)
        Write-Host "✅ Descargado: $FileName ($size MB)" -ForegroundColor Green
        Write-Host ""

        return $true
    }
    catch {
        Write-Host "❌ Error descargando $Description" -ForegroundColor Red
        Write-Host "   Error: $_" -ForegroundColor Red
        Write-Host ""
        return $false
    }
}

# ============================================================================
# 1. GIT
# ============================================================================
Write-Host "1️⃣  Git (Control de Versiones)" -ForegroundColor Cyan
$gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"
if (Download-File -Url $gitUrl -FileName "Git-installer.exe" -Description "Git") {
    $downloaded++
} else {
    $failed++
}

# ============================================================================
# 2. NODE.JS
# ============================================================================
Write-Host "2️⃣  Node.js LTS (JavaScript + npm)" -ForegroundColor Cyan
$nodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
if (Download-File -Url $nodeUrl -FileName "nodejs-installer.msi" -Description "Node.js LTS") {
    $downloaded++
} else {
    $failed++
}

# ============================================================================
# 3. UV
# ============================================================================
Write-Host "3️⃣  uv (Gestor Python)" -ForegroundColor Cyan
$uvUrl = "https://github.com/astral-sh/uv/releases/download/0.1.0/uv-x86_64-pc-windows-msvc.exe"
if (Download-File -Url $uvUrl -FileName "uv.exe" -Description "uv") {
    $downloaded++
    Write-Host "   ℹ️  Copia este archivo a: C:\Program Files\uv\" -ForegroundColor Gray
    Write-Host ""
} else {
    $failed++
    Write-Host "   💡 Puedes descargarlo manualmente desde:" -ForegroundColor Yellow
    Write-Host "      https://github.com/astral-sh/uv/releases" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# 4. CLAUDE CODE (OPCIONAL)
# ============================================================================
Write-Host "4️⃣  Claude Code (Opcional)" -ForegroundColor Cyan
Read-Host "¿Descargar Claude Code? (Presiona Enter para sí, o escribe 'no')" | ForEach-Object {
    if ($_ -ne "no") {
        Write-Host "ℹ️  Claude Code está disponible en:" -ForegroundColor Blue
        Write-Host "    https://github.com/anthropics/claude-code/releases" -ForegroundColor Gray
        Write-Host "    Busca: claude-code-<version>-win-x64.exe" -ForegroundColor Gray
        Write-Host ""
    }
}

# ============================================================================
# RESUMEN
# ============================================================================
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📊 RESUMEN" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Descargados: $downloaded" -ForegroundColor Green
Write-Host "❌ Errores:     $failed" -ForegroundColor Red
Write-Host ""

Write-Host "📁 Carpeta de descargas:" -ForegroundColor Green
Write-Host "   $DownloadPath" -ForegroundColor Gray
Write-Host ""

# Abrir carpeta
Write-Host "¿Abrir carpeta de descargas?" -ForegroundColor Yellow
$openFolder = Read-Host "(Presiona Enter para sí, o escribe 'no')"

if ($openFolder -ne "no") {
    Write-Host "Abriendo carpeta..." -ForegroundColor Cyan
    Start-Process explorer.exe -ArgumentList $DownloadPath
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Ejecuta cada instalador en este orden:" -ForegroundColor Green
Write-Host "   a) Git-installer.exe" -ForegroundColor Cyan
Write-Host "   b) nodejs-installer.msi" -ForegroundColor Cyan
Write-Host "   c) uv.exe" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Reinicia PowerShell después de cada instalación" -ForegroundColor Green
Write-Host ""
Write-Host "3. Verifica las instalaciones:" -ForegroundColor Green
Write-Host "   git --version" -ForegroundColor Cyan
Write-Host "   node --version" -ForegroundColor Cyan
Write-Host "   npm --version" -ForegroundColor Cyan
Write-Host "   uv --version" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Instala dependencias del proyecto:" -ForegroundColor Green
Write-Host "   cd projects/todo-app" -ForegroundColor Cyan
Write-Host "   npm install" -ForegroundColor Cyan
Write-Host ""
Write-Host "5. ¡Inicia desarrollo!" -ForegroundColor Green
Write-Host "   npm run dev" -ForegroundColor Cyan
Write-Host ""

Write-Host "✨ ¡Listo! Sigue la guía INSTALACION.md para más detalles." -ForegroundColor Green
