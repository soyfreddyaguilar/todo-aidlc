# 📥 Descargas Rápidas - TODO App (POC)

Copiar el enlace y descargar en tu navegador, o usa los comandos de instalación.

---

## 1️⃣ Git (Control de Versiones)

**Descarga directa:**
- https://git-scm.com/download/win

**Versión recomendada:** Última disponible (2.40+)  
**Tipo de descarga:** Instalador `.exe` (64-bit)

**Comandos alternativos:**
```powershell
winget install Git.Git
# o descargar manualmente desde el enlace de arriba
```

---

## 2️⃣ Node.js LTS (JavaScript Runtime)

**Descarga directa:**
- https://nodejs.org/

**Versión recomendada:** v20.x LTS o superior  
**Tipo de descarga:** Instalador `.msi` (64-bit)

**Incluye:** Node.js + npm (gestor de paquetes)

**Comandos alternativos:**
```powershell
winget install OpenJS.NodeJS
# o descargar manualmente desde el enlace de arriba
```

---

## 3️⃣ uv (Gestor Python - para MCP)

**Descarga directa:**
- https://github.com/astral-sh/uv/releases

**Buscar:** `uv-x86_64-pc-windows-msvc.exe` (versión más reciente)

**Instalación manual:**
1. Descarga el archivo `.exe`
2. Renómbralo a `uv.exe`
3. Copia a `C:\Program Files\uv\`
4. Añade a PATH: 
   - Win+X → Sistema → Variables de entorno
   - Agrega a PATH: `C:\Program Files\uv`

**Comandos alternativos:**
```powershell
# Instalación automática (PowerShell como Administrador)
(iwr https://astral.sh/uv/install.ps1 -UseBasicParsing).Content | iex
```

---

## 4️⃣ Claude Code (Necesario - para AI-DLC)

**Descarga directa:**
- https://github.com/anthropics/claude-code/releases

**Buscar:** `claude-code-<version>-win-x64.exe`

**O instalar via npm:**
```powershell
npm install -g @anthropic-ai/claude-code
```

**Verificar:** `claude --version`

---

## 5️⃣ AI-DLC (Framework del Proyecto)

**¿Qué es?** Framework que orquesta todo el desarrollo (ya está en el proyecto)

**¿Cómo activarlo?** Después de instalar Claude Code:

1. Abre Claude Code:
```powershell
claude
```

2. En el chat, ejecuta:
```
/aidlc --status
```

3. Ver próximas etapas:
```
/aidlc --resume
```

**Nota:** AI-DLC viene incluido en `.claude/` del proyecto. Solo necesitas Claude Code para usarlo.

---

## 5️⃣ VS Code (Recomendado para editar código)

**Descarga directa:**
- https://code.visualstudio.com/download

**Versión recomendada:** Última disponible (Windows 64-bit)

**Extensiones útiles:**
- ESLint
- Prettier
- Claude Code (después de instalar la CLI)

---

## ✅ Orden de instalación recomendado

1. **Git** → Control de versiones
2. **Node.js** → JavaScript + npm
3. **uv** → Servidores MCP
4. **Claude Code** → Necesario para AI-DLC (framework del proyecto)
5. **VS Code** (opcional) → Editor de código recomendado

---

## 🚀 Después de descargar

```powershell
# Navega al proyecto
cd d:\PROJECTS\POC\poc-test

# Instala dependencias del proyecto
cd projects\todo-app
npm install

# Inicia desarrollo
npm run dev
```

---

## 🔗 Resumen de enlaces

```
Git:         https://git-scm.com/download/win
Node.js:     https://nodejs.org/
uv:          https://github.com/astral-sh/uv/releases
Claude Code: https://github.com/anthropics/claude-code/releases
VS Code:     https://code.visualstudio.com/download
```

---

## ❓ ¿Qué versión descargar?

- **Git:** Busca `Git-<version>-64-bit.exe`
- **Node.js:** Busca la versión **LTS** (no Current), arquitectura **Windows x64**
- **uv:** Busca `uv-x86_64-pc-windows-msvc.exe`
- **Claude Code:** Busca `claude-code-<version>-win-x64.exe`
- **VS Code:** Windows instalador (x64)

---

## 💾 Después de descargar

Todos los instaladores son ejecutables `.exe` o `.msi`. Solo abre y sigue el asistente.

Para verificar que todo está correcto, abre PowerShell y ejecuta:

```powershell
git --version
node --version
npm --version
uv --version
# Opcional:
claude --version
```

Deberías ver números de versión para cada uno.
