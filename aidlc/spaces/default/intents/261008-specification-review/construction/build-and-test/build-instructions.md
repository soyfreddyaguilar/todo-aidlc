# Instrucciones de Build — TODO App

## Prerrequisitos

- Node.js 20 o superior y npm.
- Dependencias instaladas en `projects/todo-app` (`npm install`).
- No se requieren variables de entorno, servicios locales ni backend (la especificación es solo localStorage).

## Pasos de instalación

```bash
cd projects/todo-app
npm install
```

## Comandos de build

| Paso | Comando | Resultado esperado |
|---|---|---|
| Build de producción | `npm run build` | Genera `dist/` sin errores |
| Vista previa del build | `npm run preview` | Sirve `dist/` en el navegador |
| Lint (oxlint, sobre `src/`) | `npm run lint` | Sin errores |
| Lint (ESLint, react y react-hooks) | `npm run lint:eslint` | Sin errores |
| Formato (Prettier) | `npm run format:check` | "All matched files use Prettier code style!" |

## Verificación del build

1. `npm run build` termina con código 0.
2. `dist/assets/*.js` ocupa menos de 100 KB comprimidos (medido: 72.32 kB gzip).
3. `npm run lint` revisa los 21 archivos de `src/`. Si el número de archivos revisados es 0, el lint no sirve de evidencia: ver nota abajo.

## Nota sobre oxlint

oxlint 1.87 no recorre directorios ni expande globs en Windows. Por eso `npm run lint` ejecuta `scripts/oxlint-src.mjs`, que reúne los archivos `.js` y `.jsx` de `src/` y se los pasa a oxlint. Se verificó que el script detecta un error sembrado (regla `rules-of-hooks`) y sale con código 1.

## Solución de problemas comunes

- **`Cannot find module`**: confirmar que se ejecutó `npm install` dentro de `projects/todo-app`.
- **Lint sin archivos revisados**: revisar que `scripts/oxlint-src.mjs` exista y que `package.json` apunte a él.
- **Build con advertencias de tamaño**: no relajar umbrales; el límite es 100 KB gzip según el plan.
