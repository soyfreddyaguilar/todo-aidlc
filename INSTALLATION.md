# Instalación - TODO App (POC)

## Requisitos previos
- Windows 11 Pro
- Conexión a Internet
- Privilegios de administrador

---

## Paso 1: Instalar Git
Necesario para control de versiones

**Opción A: Windows Package Manager**
```powershell
winget install Git.Git
```

**Opción B: Descargar instalador**
1. Ve a https://git-scm.com/download/win
2. Descarga el `.exe` (64-bit)
3. Ejecuta el instalador
4. Acepta opciones por defecto

**Verificar:** `git --version`

---

## Paso 2: Instalar Node.js
Plataforma JavaScript que ejecuta la app

**Opción A: Windows Package Manager**
```powershell
winget install OpenJS.NodeJS
```

**Opción B: Descargar instalador**
1. Ve a https://nodejs.org/
2. Descarga versión **LTS** (20.x o superior)
3. Ejecuta el `.msi` (64-bit)
4. Acepta opciones por defecto (incluye npm automáticamente)

**Verificar:** `node --version` y `npm --version`
(Reinicia PowerShell después de instalar)

---

## Paso 3: Instalar uv
Necesario para servidores MCP de AWS

**Opción A: Automático (PowerShell como Administrador)**
```powershell
(iwr https://astral.sh/uv/install.ps1 -UseBasicParsing).Content | iex
```

**Opción B: Descargar instalador**
1. Ve a https://github.com/astral-sh/uv/releases
2. Descarga `uv-x86_64-pc-windows-msvc.exe` (versión más reciente)
3. Renómbralo a `uv.exe`
4. Cópialo a `C:\Program Files\uv\` (crea la carpeta si no existe)
5. Añade `C:\Program Files\uv\` a tu PATH:
   - Win+X → Sistema
   - Configuración avanzada del sistema
   - Variables de entorno
   - Nueva variable: Nombre=`UV_HOME`, Valor=`C:\Program Files\uv`

**Verificar:** `uv --version`
(Reinicia PowerShell después de instalar)

---

## Paso 4: Instalar Claude Code
Necesario para el workflow AI-DLC del proyecto

**Opción A: Via npm (después de instalar Node.js)**
```powershell
npm install -g @anthropic-ai/claude-code
```

**Opción B: Descargar ejecutable**
1. Ve a https://github.com/anthropics/claude-code/releases
2. Descarga `claude-code-<version>-win-x64.exe`
3. Ejecuta el instalador
4. Sigue el asistente

**Verificar:** `claude --version`

---

## Paso 4b: Activar AI-DLC en Claude Code
AI-DLC es el framework que orquesta el desarrollo del proyecto

**Primero, abre Claude Code:**
```powershell
claude
```

**Luego dentro de Claude Code (en el chat), ejecuta:**
```
/aidlc --status
```

Si ves la información del workflow, ¡está listo!

**Comandos útiles de AI-DLC:**
```powershell
aidlc --status              # Ver dónde estamos en el workflow
aidlc --resume              # Continuar desde donde se pausó
aidlc --doctor              # Verificar que todo está bien
aidlc --help                # Ver todas las opciones
aidlc --stage <nombre>      # Ir a una etapa específica
```

---

## Paso 5: Instalar dependencias del proyecto
Descarga todas las librerías necesarias

```powershell
cd d:\PROJECTS\POC\poc-test\projects\todo-app
npm install
```

Espera 2-5 minutos. Instala: React, Vite, Tests, ESLint, Prettier.

---

## Paso 6: Verificar instalación
Comprueba que todo está correcto

```powershell
.\..\..\verificar-requisitos.ps1
```

O manualmente:
```powershell
git --version
node --version
npm --version
uv --version
```

---

## ✅ ¡Listo! Tu setup está completo

### Flujo recomendado: AI-DLC + Desarrollo

```powershell
# 1. Abre Claude Code (esto abre AI-DLC)
claude

# 2. Ver estado del workflow
/aidlc --status

# 3. Continuar desarrollo (Claude te guiará)
/aidlc --resume

# 4. En otra terminal, iniciar servidor (opcional)
cd projects\todo-app
npm run dev
```

### Comandos del proyecto (en otra terminal)

```powershell
cd projects\todo-app

npm run dev              # Inicia servidor desarrollo (http://localhost:5173/)
npm run test             # Ejecuta tests
npm run test:watch       # Tests en modo observación
npm run lint             # Verifica código
npm run format           # Formatea código automáticamente
npm run build            # Compila para producción
```

### Comandos de AI-DLC (en Claude Code)

```
/aidlc --status              # Ver dónde estamos
/aidlc --resume              # Continuar desarrollo
/aidlc --doctor              # Diagnosticar problemas
/aidlc --stage <nombre>      # Ir a etapa específica
/aidlc --help                # Ver todas las opciones
```

---

## 🐛 Si algo falla

| Problema | Solución |
|----------|----------|
| "npm: command not found" | Reinicia PowerShell después de instalar Node.js |
| "git: command not found" | Reinstala Git asegurándote de marcar "Use Git from the command line" |
| Errores en `npm install` | `npm cache clean --force` luego `npm install` |
| Puerto 5173 en uso | `npm run dev -- --port 3000` |
| Tests fallan | `rm -r node_modules` luego `npm install` |

---

## Estructura del proyecto

```
d:\PROJECTS\POC\poc-test\
├── projects/todo-app/         ← APP REACT
│   ├── src/                   (código fuente)
│   ├── package.json           (dependencias)
│   └── vite.config.js         (configuración)
├── aidlc/                      (framework desarrollo)
├── .claude/                    (configuración Claude)
└── .mcp.json                   (servidores MCP)
```

---

## 📥 Enlaces de descarga directa

| Herramienta | Enlace | Notas |
|------------|--------|-------|
| **Git** | https://git-scm.com/download/win | Elige 64-bit |
| **Node.js LTS** | https://nodejs.org/ | v20.x o superior |
| **uv** | https://github.com/astral-sh/uv/releases | `uv-x86_64-pc-windows-msvc.exe` |
| **Claude Code** | https://github.com/anthropics/claude-code/releases | `claude-code-<version>-win-x64.exe` |
| **VS Code** (recomendado) | https://code.visualstudio.com/download | Para editar el código |

---

## Próximos pasos

1. **Desarrollo:** `npm run dev`
2. **Tests:** `npm run test`
3. **Workflow AI-DLC:** `aidlc --status` (si instalaste Claude Code)
