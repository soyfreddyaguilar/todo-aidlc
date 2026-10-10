# 🚀 Guía de Instalación - TODO App (POC)

Elige tu camino para configurar el entorno:

---

## 📖 Documentos disponibles

### 1. **INSTALACION.md** ← EMPIEZA AQUÍ
Guía paso a paso completa con:
- Instrucciones claras de instalación
- Comandos listos para copiar/pegar
- Tabla de solución de problemas
- Enlaces de descarga directa
- **Incluye sección de Claude Code + AI-DLC**

**Lectura rápida:** 5 minutos  
**Para:** Cualquiera que quiera instalar desde cero

---

### 2. **AIDLC-SETUP.md** ← LEE DESPUÉS
Guía específica para AI-DLC (el framework del proyecto):
- Qué es AI-DLC
- Cómo activarlo
- Comandos principales
- Estructura del workflow
- Fases del desarrollo

**Lectura rápida:** 5 minutos  
**Para:** Entender cómo funciona el framework de desarrollo

---

### 3. **DESCARGAS.md**
Listado de todos los enlaces de descarga:
- Git
- Node.js
- uv
- Claude Code
- AI-DLC
- VS Code

**Lectura rápida:** 2 minutos  
**Para:** Si prefieres descargar instaladores manualmente

---

### 4. **descargar-instaladores.ps1**
Script PowerShell que descarga automáticamente todo:

```powershell
.\descargar-instaladores.ps1
```

**Tiempo:** 5-10 minutos (depende de velocidad de Internet)  
**Para:** Automatizar las descargas

---

### 5. **verificar-requisitos.ps1**
Script que verifica que todo está instalado:

```powershell
.\verificar-requisitos.ps1
```

**Tiempo:** 1 minuto  
**Para:** Validar que tu instalación es correcta

---

## ⚡ Opción más rápida

```powershell
# 1. Ejecuta el script de descargas
.\descargar-instaladores.ps1

# 2. Instala cada descarga (Git, Node.js, uv, Claude Code)
# 3. Reinicia PowerShell
# 4. Verifica
.\verificar-requisitos.ps1

# 5. Instala dependencias del proyecto
cd projects\todo-app
npm install

# 6. Inicia Claude Code (para AI-DLC)
claude

# 7. En Claude Code, dentro del chat:
/aidlc --status
/aidlc --resume

# 8. ¡El desarrollo está orquestado por AI-DLC!
```

---

## 📋 Opción manual paso a paso

1. Lee **INSTALACION.md** (guía completa)
2. Descarga desde **DESCARGAS.md** o usa `winget`
3. Instala cada herramienta (Git, Node.js, uv, Claude Code)
4. Verifica con **verificar-requisitos.ps1**
5. Ejecuta `npm install` en `projects/todo-app`
6. Lee **AIDLC-SETUP.md** (para entender el framework)
7. Abre Claude Code y activa AI-DLC: `/aidlc --status`
8. ¡Listo! Continúa con `/aidlc --resume`

---

## 🎯 Resumen de requisitos

| Herramienta | Necesario | Descarga |
|------------|----------|----------|
| **Git** | ✅ Sí | https://git-scm.com/download/win |
| **Node.js** | ✅ Sí | https://nodejs.org/ |
| **npm** | ✅ Sí | (incluido con Node.js) |
| **uv** | ✅ Sí | https://github.com/astral-sh/uv/releases |
| **Claude Code** | ✅ Sí* | https://github.com/anthropics/claude-code/releases |
| **AI-DLC** | ✅ Sí* | (incluido en el proyecto) |
| **VS Code** | ⚠️ Opcional | https://code.visualstudio.com/ |

*Necesario para usar el workflow AI-DLC (framework de desarrollo)

---

## ✅ Después de instalar

### 1. Instala dependencias del proyecto
```powershell
cd d:\PROJECTS\POC\poc-test\projects\todo-app
npm install
```

### 2. Inicia desarrollo con AI-DLC
```powershell
# Abre Claude Code
claude

# Dentro de Claude Code:
/aidlc --status    # Ver estado
/aidlc --resume    # Continuar desarrollo
```

### 3. (Opcional) Inicia servidor de desarrollo
```powershell
npm run dev
# Abre http://localhost:5173/ en navegador
```

---

## 🐛 Si algo falla

1. Lee la sección "Si algo falla" en **INSTALACION.md**
2. Ejecuta `.\verificar-requisitos.ps1` para diagnosticar
3. Reinicia PowerShell después de instalar cada herramienta
4. Limpia caché de npm: `npm cache clean --force`

---

## 💡 Tips

- **Siempre reinicia PowerShell** después de instalar software
- **Usa winget** si quieres instalación automática (más rápido)
- **Usa descargar-instaladores.ps1** si quieres controlar dónde se guardan
- **Verifica con verificar-requisitos.ps1** cuando termines

---

## 🎬 ¡Listo!

Ahora puedes:

```powershell
npm run dev              # Inicia desarrollo
npm run test             # Ejecuta tests
npm run build            # Compila para producción
npm run format           # Formatea código
npm run lint             # Verifica código
```

---

**¿Dónde empiezo?**

1. Si quieres instrucciones claras → **INSTALACION.md**
2. Si solo quieres los enlaces → **DESCARGAS.md**
3. Si quieres automatizar descargas → `.\descargar-instaladores.ps1`
4. Si quieres verificar instalación → `.\verificar-requisitos.ps1`
