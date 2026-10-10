# 🤖 Configuración de AI-DLC

AI-DLC (AI-Driven Development Life Cycle) es el framework que orquesta todo el desarrollo de este proyecto.

---

## ¿Qué es AI-DLC?

**AI-DLC** es un framework que:
- Guía cada etapa del desarrollo (ideación → construcción → operación)
- Pausa y pide aprobación en cada paso importante
- Mantiene un registro de decisiones y cambios
- Automatiza partes repetitivas del workflow

**Archivo principal:** `.claude/` (contiene toda la configuración)

---

## Requisitos previos

Para usar AI-DLC necesitas:

1. ✅ **Git** instalado
2. ✅ **Node.js + npm** instalado
3. ✅ **Claude Code** instalado y funcionando
4. ✅ **uv** instalado (para servidores MCP)

Ver `INSTALACION.md` para instalar estos antes de continuar.

---

## Paso 1: Instalar Claude Code

### Opción A: Via npm
```powershell
npm install -g @anthropic-ai/claude-code
```

### Opción B: Descargar ejecutable
https://github.com/anthropics/claude-code/releases
(Busca: `claude-code-<version>-win-x64.exe`)

### Verificar
```powershell
claude --version
```

Deberías ver un número de versión.

---

## Paso 2: Activar AI-DLC

### Abrir Claude Code
```powershell
claude
```

Esto abre la interfaz de Claude Code en tu terminal.

### Ver estado del workflow
```
/aidlc --status
```

Deberías ver:
- Proyecto actual
- Etapa donde estamos
- Próximos pasos

### Ver información detallada
```
/aidlc --doctor
```

Esto valida que todo el framework está bien configurado.

---

## Paso 3: Usar AI-DLC

### Ver opciones disponibles
```
/aidlc --help
```

### Comandos principales

| Comando | Qué hace |
|---------|----------|
| `/aidlc --status` | Ver dónde estamos en el workflow |
| `/aidlc --resume` | Continuar desde donde se pausó |
| `/aidlc --stage <nombre>` | Ir a una etapa específica |
| `/aidlc --doctor` | Diagnosticar problemas |
| `/aidlc --compose "<tarea>"` | Crear un plan personalizado |

### Ejemplo: Reanudar el desarrollo
```
/aidlc --resume
```

Claude te mostrará:
- Etapa actual
- Qué falta por hacer
- Próximos pasos

---

## Estructura del Proyecto AI-DLC

```
d:\PROJECTS\POC\poc-test\
├── .claude/                      ← Configuración de Claude Code
│   ├── CLAUDE.md                 (instrucciones del proyecto)
│   ├── agents/                   (expertos especializados)
│   ├── hooks/                    (automatizaciones)
│   ├── knowledge/                (referencias y guías)
│   ├── sensors/                  (verificaciones automáticas)
│   ├── skills/                   (comandos especiales)
│   └── tools/                    (herramientas internas)
│
├── aidlc/                        ← Estado y registros del workflow
│   └── spaces/default/
│       └── intents/
│           └── 261008-specification-review/  (trabajo actual)
│               ├── aidlc-state.md            (estado del workflow)
│               ├── audit/                    (registro de decisiones)
│               └── [fases]/                  (resultados de cada fase)
│
└── .mcp.json                     (configuración de servidores externos)
```

---

## Fases del Workflow

El proyecto sigue estas fases:

### 1. **Ideation** (Ideación)
- Capturar intención
- Investigación de mercado
- Definir alcance
- Etapa: Team Formation → Approval Handoff

### 2. **Inception** (Inicio)
- Análisis de requisitos
- Diseño de arquitectura
- Historias de usuario
- Etapa: Requirements → User Stories

### 3. **Construction** (Construcción)
- Diseño funcional
- Generación de código
- Tests y validación
- Etapa: Code Generation → Build and Test

### 4. **Operation** (Operación)
- Configuración de infraestructura
- Pipeline de despliegue
- Monitoreo y observabilidad

---

## Guardar Progreso

AI-DLC guarda automáticamente:
- Decisiones que tomas
- Cambios de código
- Resultados de cada etapa
- Todo en `aidlc/spaces/default/intents/`

---

## Si necesitas ayuda

### Ver configuración del proyecto
```
/aidlc --config guard-policy
```

### Diagnosticar problemas
```
/aidlc --doctor
```

### Leer la guía detallada
Archivo: `.claude/CLAUDE.md`

### Revisar prácticas del equipo
Archivos:
```
aidlc/spaces/default/memory/
├── org.md          (reglas globales)
├── team.md         (prácticas confirmadas)
├── project.md      (decisiones específicas)
└── phases/         (guías por fase)
```

---

## Flujo típico

```
1. Abres Claude Code
   claude

2. Ves el estado actual
   /aidlc --status

3. Continúas el trabajo
   /aidlc --resume

4. Claude te guía por los pasos
   (responde preguntas, aprueba cambios)

5. Se genera código y documentación
   (guardan en aidlc/spaces/default/intents/)

6. Próxima etapa se prepara automáticamente
   (vuelve al paso 2)
```

---

## Comandos útiles diarios

```powershell
# Ver dónde estamos
claude
/aidlc --status

# Continuar desarrollo
/aidlc --resume

# Si algo no funciona
/aidlc --doctor

# Construir plan personalizado
/aidlc --compose "tu tarea aquí"

# Ver próximos pasos
/aidlc --stage <nombre-etapa>
```

---

## Notas importantes

- **AI-DLC se ejecuta dentro de Claude Code** (`claude` comando)
- **No requiere instalación aparte** - viene con el proyecto
- **Guarda todo automáticamente** en `aidlc/`
- **Requiere Claude Code CLI** para funcionar
- **Mantén Git actualizado** - AI-DLC registra todo en git

---

## Próximos pasos

1. Instala Claude Code (si no lo has hecho)
2. Abre Claude Code: `claude`
3. Verifica el estado: `/aidlc --status`
4. Continúa el workflow: `/aidlc --resume`

¡Listo! El framework te guiará desde ahí. 🚀
