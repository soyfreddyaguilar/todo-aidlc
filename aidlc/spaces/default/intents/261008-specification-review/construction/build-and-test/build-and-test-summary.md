# Resumen de Build and Test — TODO App

## Estado general

- **Build:** correcto (`npm run build`).
- **Pruebas:** 34 de 34 pasan (5 archivos).
- **Cobertura:** cumple los umbrales (líneas 90.47%).
- **Lint y formato:** correctos (oxlint, ESLint y Prettier).
- **Etapa:** **no supera** la regla de fallo del protocolo, porque hay objetivos medibles sin verificar o no cumplidos (ver matriz). Requiere decisión humana.

## Prerrequisitos

Node.js 20+, `npm install` en `projects/todo-app`. Sin backend ni servicios externos.

## Inventario de tipos de prueba (estrategia standard)

- Pruebas unitarias (Code Generation): 18 (validación 7, localStorage 8, taskId 3).
- Escenarios BDD: 10 (`tasks.feature.test.jsx`).
- Pruebas de integración: 6 (`localStorage-integration.test.jsx`).
- Pruebas de rendimiento y seguridad: no aplican con esta estrategia. Los archivos `performance-test-instructions.md` y `security-test-instructions.md` son de una sesión anterior y quedan sin uso; se archivarán en la siguiente pasada.

## Expectativas de cobertura por unidad

Sin unidades (alcance spec-review). Cobertura medida en el proyecto completo: líneas 90.47%, sentencias 87.9%, funciones 86.9%, ramas 73.79%.

## Matriz de verificación de objetivos

| Target ID | Fuente | Esperado | Actual | Evidencia | Etapa responsable | Veredicto |
|---|---|---|---|---|---|---|
| T-BUILD-01 | build-instructions.md | Build sin errores | Correcto, 231.01 kB JS | `npm run build` | build-and-test | Met |
| T-TEST-01 | unit-test-instructions.md | Todas las pruebas pasan | 34/34 | `npm run test` | build-and-test | Met |
| T-COV-01 | Piso de cobertura 40% líneas | ≥ 40% | 90.47% | `npm run test:coverage` | build-and-test | Met |
| T-COV-02 | Umbrales de vitest.config.js | fn 40 / ramas 30 / sent 40 | fn 86.9 / ramas 73.79 / sent 87.9 | `npm run test:coverage` | build-and-test | Met |
| T-NFR1-SIZE | NFR1 / plan (< 100 KB gzip) | < 100 KB gzip | 72.32 kB gzip | `npm run build` | build-and-test | Met |
| T-NFR5-LINT | NFR5 (lint sin errores) | 0 errores | 0 (oxlint revisa 21 archivos) | `npm run lint`, `npm run lint:eslint` | build-and-test | Met |
| T-NFR5-FMT | NFR5 (Prettier) | Formato correcto | Correcto | `npm run format:check` | build-and-test | Met |
| T-NFR2-CONTRAST | NFR2 (4.5:1 texto, ambos temas) | ≥ 4.5 | Mínimo 5.55 en tokens (ver nota) | Cálculo WCAG sobre `src/index.css` | build-and-test | Met |
| T-NFR1-LOAD | NFR1 (carga < 2 s en 4G) | Tiempo medido | No medido | Ninguna | performance-validation (programada en el alcance) | Unverified |
| T-NFR2-KEYBOARD | NFR2 (recorrido de teclado) | Recorrido completo | No realizado | Ninguna | Ninguna programada | Unverified |
| T-NFR3-BROWSERS | NFR3 (Chrome, Firefox, Safari, Edge) | Pruebas en cada navegador | No realizado | Ninguna | Ninguna programada | Unverified |
| T-NFR9-CONSOLE | NFR9 (consola limpia) | Sin errores ni warnings | No verificado | Ninguna | Ninguna programada | Unverified |
| T-FR7-320 | FR7 (320px sin scroll horizontal) | Prueba de viewport | Solo validación estática de CSS | `src/App.css` | Ninguna programada | Unverified |
| T-NFR6-MAP | NFR6 (10 escenarios 1:1 con FR1-FR10) | 10 escenarios, uno por FR | 10 escenarios que no cubren FR9 ni FR10 | `tasks.feature.test.jsx` | build-and-test | Not Met |

**Nota sobre T-NFR2-CONTRAST:** el cálculo usa los tokens de color, no pixeles renderizados en un navegador. Pares más débiles: éxito sobre fondo de éxito en tema claro (5.55:1) y texto sobre superficie en tema oscuro (10.71:1); todos los pares de texto superan 4.5:1.

## Preparación de listo / no listo

- **Build-ready:** sí.
- **Test-ready:** sí, con la brecha de NFR6 y los objetivos no verificados.
- **Deployment-ready:** no. Sin CI ni husky (NFR5 parcial), sin verificación en navegador.

## Limitaciones conocidas

- FR7 (responsive) sin prueba de viewport real.
- FR9 y FR10 cubiertos por pruebas unitarias e de integración, no por escenarios BDD propios (desviación declarada en code-summary).
- NFR9: el propio código tiene un `console.error` solo si falla la escritura de la preferencia de tema.
- NFR3: sin pruebas multi-navegador.
- Las instrucciones de rendimiento y seguridad son de una sesión anterior y no aplican a esta estrategia.

## Decisión pendiente

La regla de fallo del protocolo se cumple (objetivos Unverified y uno Not Met). Opciones ante el gate de Build and Test: **Accept failure** (registrar y avanzar), **Abort** (detener y reanudar después) o **Retry with fix** si existe una corrección identificable (por ejemplo, agregar escenarios para FR9 y FR10 y una prueba de consola para NFR9, con impacto estimado de esfuerzo bajo y sin costo económico). La elección es del humano.
