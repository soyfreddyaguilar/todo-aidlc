# Trazabilidad cruzada final — Build and Test

Alcance: spec-review, sin unidades. Fuente de trazabilidad: `construction/code-generation/traceability.json` (etapa a nivel de stage). Requisitos: `inception/requirements-analysis/requirements.md`.

## Veredicto

**Parcial (FAIL en la verificación de cobertura de IDs).** Cada ID está cubierto por al menos una entrada, pero no todas con estado `OK`, y hay objetivos sin verificar.

## Cobertura por ID

| ID | Estado | Destino | Notas |
|---|---|---|---|
| FR1 | OK | `TaskForm.jsx` | BDD 1 y 2 |
| FR2 | OK | `TaskList.jsx` | BDD 3 y 4 |
| FR3 | OK | `TaskItem.jsx` | BDD 5 |
| FR4 | OK | `FilterButtons.jsx` | BDD 6; errores de consola no verificados (ver NFR9) |
| FR5 | OK | `TaskItem.jsx` | BDD 7; integración |
| FR6 | OK | `TaskItem.jsx` | BDD 8; integración |
| FR7 | PARTIAL | `App.css` | Solo validación estática de CSS; sin prueba de 320px |
| FR8 | OK | `useTheme.js` | BDD 10; contraste calculado en tokens |
| FR9 | OK | `validation.js` | Unitarias (7); sin escenario BDD propio (desviación declarada) |
| FR10 | OK | `localStorage.js` | Unitarias (8) e integración (6); sin escenario BDD propio |
| NFR1 | GAP | — | Tamaño verificado; tiempo de carga no medido |
| NFR2 | GAP | — | Contraste calculado en tokens; recorrido de teclado no realizado |
| NFR3 | GAP | — | Sin pruebas multi-navegador |
| NFR4 | OK | `useTodos.js` | Hooks, PascalCase, camelCase |
| NFR5 | PARTIAL | `eslint.config.js` | Lint y formato pasan; sin husky ni CI |
| NFR6 | PARTIAL | `tasks.feature.test.jsx` | 40% de cobertura cumplido; el mapeo 1:1 con FR1-FR10 no se cumple (ver matriz) |
| NFR7 | N/A | — | Sin imágenes en el alcance |
| NFR8 | OK | `localStorage.js` | Validación de carga y JSON inválido; "Clear saved data" sin prueba automatizada |
| NFR9 | GAP | — | Consola del navegador no verificada |
| NFR10 | OK | `useTodos.js` | Estado con useState, actualizaciones inmutables |

## Elementos sin cobertura completa

- FR7, NFR1, NFR2, NFR3 y NFR9: no hay evidencia de navegador ni de viewport real.
- NFR6: el criterio "10 escenarios 1:1 con FR1-FR10" no se cumple; FR9 y FR10 no tienen escenario propio.
- NFR5: falta husky y CI.

Cada uno de estos puntos se muestra en el gate de Build and Test para decisión humana.

## Archivos de destino

Todos los destinos `OK` existen bajo `projects/todo-app/src/` (verificado en esta sesión contra el árbol de archivos).
