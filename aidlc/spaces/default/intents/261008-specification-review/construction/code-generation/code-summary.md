# Resumen de Code Generation — TODO App

## Resumen

Se implemento la aplicacion TODO (React 19 + Vite 8) en `projects/todo-app`, extendiendo la plantilla existente. El enfoque fue BDD: primero se escribieron los 10 escenarios (en rojo: 10 de 10 fallaban antes de implementar) y despues se implementaron las capas hasta dejarlos en verde.

Resultados reales de la ultima ejecucion:

- `npm run test:coverage`: 5 archivos de prueba, 34 de 34 pruebas en verde.
- Cobertura: lineas 90.47% (umbral 40%), sentencias 87.9% (umbral 40%), funciones 86.9% (umbral 40%), ramas 73.79% (umbral 30%). Ningun umbral se bajo.
- `npm run lint` (oxlint): sin errores ni advertencias.
- `npm run lint:eslint` (ESLint con react y react-hooks): sin errores.
- `npm run format:check` (Prettier): correcto.
- `npm run build`: correcto. Salida: JS 231.01 kB (72.32 kB gzip), CSS 4.22 kB (1.42 kB gzip).

## Archivos creados y modificados

Todos bajo `projects/todo-app/` (la lista exacta esta en `source-manifest.json`).

- Configuracion: `vitest.config.js` (nuevo), `eslint.config.js` (nuevo), `.prettierrc` y `.prettierignore` (nuevos), `package.json` y `package-lock.json` (modificados: scripts y devDependencies), `.gitignore` (se agrego `coverage`).
- Pruebas base: `src/test/setup.js` (nuevo).
- Estilos: `src/App.css` y `src/index.css` (reescritos; se quito el layout de plantilla con hero y contador).
- Aplicacion: `src/App.jsx` (reescrito; cableado de la app).
- Funcionalidad de tareas: `src/features/tasks/components/` con `TaskForm.jsx`, `TaskList.jsx`, `TaskItem.jsx`, `FilterButtons.jsx`.
- Compartido: `src/shared/components/Header.jsx`, `Toast.jsx`; `src/shared/hooks/useTodos.js`, `useTheme.js`, `useToast.js`; `src/shared/utils/validation.js`, `localStorage.js`, `taskId.js`, `taskFilters.js`.
- Pruebas: `src/features/tasks/__tests__/tasks.feature.test.jsx` (10 escenarios BDD), `src/features/tasks/__tests__/localStorage-integration.test.jsx` (6 pruebas), `src/shared/utils/__tests__/validation.test.js` (7), `localStorage.test.js` (8), `taskId.test.js` (3).
- Sin cambios: `src/main.jsx`, `vite.config.js`, `index.html`, `README.md`.

## Decisiones clave

- **Persistencia en el mismo evento**: cada alta, edicion, cambio de estado o borrado escribe en localStorage de forma sincrona desde el hook `useTodos`. Se evito un `useEffect` que llamara a setState, porque oxlint lo marcaba (`react(set-state-in-effect`). La especificacion dice "sincrono", asi que el cambio encaja.
- **Fallo de almacenamiento**: el error se guarda en el estado. El boton Create queda deshabilitado y aparece un toast. Para datos corruptos (JSON invalido) aparece el boton "Clear saved data".
- **Registros malformados (NFR8)**: se validan `id` y `title`. Los registros invalidos se omiten y se avisa con un toast con el numero omitido.
- **Ordenacion**: las tareas se muestran de la mas reciente a la mas antigua (createdAt descendente, desempate por id).
- **Edicion inline**: guarda al perder el foco (solo cuando el foco sale de la fila; pasar de titulo a descripcion no guarda), con Enter en el titulo, y cancela con Escape.
- **Tema**: preferencia en la clave `todos-app-theme`; si no hay preferencia, sigue `prefers-color-scheme`. El atributo `data-theme` va en el div raiz.
- **IDs**: formato `YYYYMMDDHHMMSSMMM` en hora local. Si se crean dos tareas en el mismo milisegundo, el timestamp se incrementa para garantizar unicidad.
- **Textos de interfaz**: en ingles, segun los literales de los requisitos (Create, All, Pending, Completed).

## Mapeo FR1-FR10 a escenarios y pruebas

Los escenarios siguen la lista aprobada de `unit-test-instructions.md`, que tiene 10 escenarios. NFR6 pide un mapeo 1:1 con FR1-FR10, pero esa lista no coincide con FR1-FR10 (por ejemplo, FR9 y FR10 no tienen escenario propio). Se siguio la lista aprobada y el mapeo queda asi:

| Requisito | Escenario BDD (tasks.feature.test.jsx) | Otras pruebas |
|---|---|---|
| FR1 Crear | 1 (crear con titulo y descripcion), 2 (el formulario se limpia) | localStorage-integration (crear, listar, persistir) |
| FR2 Listar | 3 (orden al iniciar), 4 (estado vacio) | — |
| FR3 Completar | 5 (alternar completada) | — |
| FR4 Filtrar | 6 (filtro Completed con contador) | — |
| FR5 Eliminar | 7 (eliminar) | localStorage-integration (eliminar desde almacenamiento) |
| FR6 Editar | 8 (edicion inline con Enter) | localStorage-integration (guardar al perder foco) |
| FR7 Responsive | 9 (validacion estatica de CSS) | — (brecha: sin prueba de viewport) |
| FR8 Modo oscuro | 10 (alternar y persistir) | — |
| FR9 Validacion | — | validation.test.js (7) |
| FR10 Persistencia | — | localStorage.test.js (8), localStorage-integration (cuota, datos invalidos, almacenamiento no disponible) |

## Resultados de verificacion

- Ejecucion de prueba unitaria acotada, como se registra abajo: `npm run test -- src/shared/utils/__tests__/validation.test.js` (7 de 7 en verde).
- Ejecucion de la suite completa con cobertura: 34 de 34 en verde. Comando: `npm run test:coverage`.
- Antes de la implementacion, los 10 escenarios BDD fallaban (10 de 10 en rojo).
- Lint, formato y build: ver seccion de resumen.

## Desviaciones del plan

1. **React 19 se mantiene**. El plan decia React 18. La plantilla ya trae React 19 y el requisito pide React 18+, asi que se conserva React 19.
2. **ESLint + Prettier se agregan junto a oxlint**. El equipo pide ESLint y Prettier, y la plantilla usa oxlint. Se agregaron `eslint.config.js` (flat config, ESLint 9) y `.prettierrc`; el script `lint` (oxlint) se conserva y se agrego `lint:eslint`. Se uso flat config en lugar de `.eslintrc.json` porque es el formato actual de ESLint. ESLint 10 no se pudo usar porque `eslint-plugin-react` 7.37 no admite el peer de ESLint 10.
3. **Archivos de prueba con JSX usan extension `.jsx`**, por ejemplo `tasks.feature.test.jsx`, en lugar de `.test.js`. El archivo de Vite no transforma JSX dentro de `.js`.
4. **Un solo archivo BDD**. Se mantiene `tasks.feature.test.jsx` con 10 escenarios, segun la instruccion aprobada. La instruccion del brief pedia "un archivo por criterio"; no se siguio porque contradice el plan aprobado.
5. **Conteo de pruebas**: 10 BDD, 18 unitarias y 6 de integracion (34 en total). El plan pedia 19 unitarias y 5 de integracion. Validacion tiene 7 pruebas en vez de 8 (se fusionaron "valor valido" y "alfanumerico"). Integracion tiene 6 en vez de 5: se agrego "almacenamiento no disponible".
6. **localStorage real de jsdom**, no el objeto mock de `unit-test-instructions.md`. Los fallos se simulan con `vi.spyOn(Storage.prototype, ...)`. El resultado es el mismo y el comportamiento es mas realista.
7. **Vitest 5 en lugar de Jest** (NFR6 menciona Jest). Se alinea con el runner que pide el brief.
8. **Cobertura excluye `src/main.jsx`** (solo hace `createRoot`) y `src/test/**`. El umbral no se bajo.
9. **Prettier reformatea los archivos de la aplicacion** con `semi: false`, `singleQuote: true`, `trailingComma: all`. Los archivos de plantilla que no cambiaron no se tocaron.

## Brechas (gaps)

- **FR7 (responsive)**: solo hay validacion estatica de CSS. No se probo en un viewport de 320px ni se verifico ausencia de desplazamiento horizontal en navegador.
- **NFR1 (rendimiento)**: el tamano de build esta dentro del objetivo (<100 kB gzip), pero el tiempo de carga y FCP en 4G no se midio.
- **NFR2 (accesibilidad)**: no se midio el contraste WCAG 4.5:1 en ambos temas, ni se hizo un recorrido completo de teclado en navegador.
- **NFR3 (compatibilidad)**: no se probo en Chrome, Firefox, Safari ni Edge.
- **NFR9 (consola limpia)**: no se verifico la consola del navegador.
- **NFR5 (pre-commit y CI)**: no hay husky ni pipeline de CI; esto queda fuera de este stage.
- **Flujo "Clear saved data"**: no tiene prueba automatizada.
- **Pruebas de E2E**: no se agregaron (la estrategia `standard` no lo exige).

## Proximos pasos

1. Verificar en navegador real: viewport 320px, contraste en modo oscuro, recorrido de teclado y consola limpia (cierra FR7, NFR2, NFR9).
2. Agregar prueba para el flujo "Clear saved data" si el equipo quiere cubrir NFR8 al 100%.
3. Configurar husky y CI cuando se aborde el pipeline (NFR5).
4. Revisar `traceability.json` con el sensor de trazabilidad antes de cerrar el stage.
