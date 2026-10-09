# Instrucciones de Pruebas de Integración — TODO App

Estrategia de pruebas: **standard**. Según la tabla de la etapa, con esta estrategia se genera `integration-test-instructions.md` (pruebas de integración en fronteras clave). No se generan pruebas de rendimiento ni de seguridad propias de Comprehensive.

## Framework

- Vitest 5 con jsdom y React Testing Library (`vitest.config.js`).
- Entorno de pruebas en `src/test/setup.js`.
- Persistencia real de jsdom (`window.localStorage`); los fallos de cuota y de almacenamiento no disponible se simulan con `vi.spyOn`.

## Comandos

```bash
cd projects/todo-app
npm run test                 # todas las pruebas (34)
npm run test:coverage        # con umbrales de cobertura
npm run test -- src/features/tasks/__tests__/localStorage-integration.test.jsx   # solo integración
```

## Pruebas de integración

Archivo: `src/features/tasks/__tests__/localStorage-integration.test.jsx` (6 pruebas).

| Frontera | Qué verifica |
|---|---|
| Crear → listar → persistir | Una tarea creada aparece en la lista y queda en `todos-app-data` |
| Editar → sincronizar | La edición se refleja en localStorage |
| Borrar → eliminar del almacenamiento | El borrado retira la tarea del almacenamiento |
| Cuota excedida | Muestra el error y deshabilita el guardado |
| Datos corruptos al cargar | Muestra la opción de limpiar datos |
| Almacenamiento no disponible | Muestra el error sin romper la aplicación |

## Objetivos de cobertura

Piso de la estrategia y del alcance spec-review: 40% en líneas, funciones y sentencias; 30% en ramas (`vitest.config.js`). No se bajan para pasar un paso.

## Brechas conocidas

- No hay prueba automatizada del flujo "Clear saved data" (NFR8, opcional en el alcance POC).
- Las pruebas de integración no reemplazan una prueba en navegador real.
