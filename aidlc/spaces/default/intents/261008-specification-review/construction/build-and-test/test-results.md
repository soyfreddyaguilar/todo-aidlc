# Resultados de pruebas — Build and Test

Fecha: 2026-10-09. Proyecto: `projects/todo-app`. Ejecutado en esta sesión.

## Build

| Comando | Resultado |
|---|---|
| `npm run build` | Correcto. `dist/index.html` 0.45 kB; CSS 4.22 kB (1.42 kB gzip); JS 231.01 kB (72.32 kB gzip); 265 ms |

## Pruebas

| Comando | Total | Pasan | Fallan | Omitidas |
|---|---|---|---|---|
| `npm run test` | 34 | 34 | 0 | 0 |

Archivos: 5 (tasks.feature 10, localStorage-integration 6, validation 7, localStorage 8, taskId 3).

## Cobertura (`npm run test:coverage`)

| Métrica | Medido | Piso |
|---|---|---|
| Líneas | 90.47% (209/231) | 40% |
| Sentencias | 87.9% (218/248) | 40% |
| Funciones | 86.9% (73/84) | 40% |
| Ramas | 73.79% (107/145) | 30% |

## Lint y formato

| Comando | Resultado |
|---|---|
| `npm run lint` (oxlint sobre 21 archivos de `src/`) | 0 errores. Corregido: antes el script no revisaba ningún archivo |
| `npm run lint:eslint` | 0 errores |
| `npm run format:check` | Correcto |

Prueba de control del lint: se sembró un error de `rules-of-hooks` en un archivo temporal; el lint lo detectó y salió con código 1. El archivo se borró.

## Fallos

Ninguno en comandos de build, pruebas, lint o formato.

## Ciclo de correcciones (Loop-Back Log)

No aplica: no hubo fallos de comando ni objetivos que dispararan un loop-back. La etapa queda pendiente de decisión humana por objetivos sin verificar (ver `build-and-test-summary.md`).

## Historial previo

La ejecución anterior de esta etapa está archivada en `construction/archive/2026-10-09-build-and-test-previous/`.

## Decisión humana: Accept failure

El humano aceptó el fallo el 2026-10-09 con los objetivos abiertos siguientes, sin corregirlos en esta etapa: FR7 (320px), NFR1 (carga 4G), NFR2 (recorrido de teclado), NFR3 (navegadores), NFR9 (consola), NFR6 (mapeo 1:1 de escenarios BDD con FR1-FR10). Se registran como brechas en el gate de aprobación y en la trazabilidad. No se modificó ningún umbral.
