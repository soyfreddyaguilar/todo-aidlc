# TODO App - Especificación de Requisitos

## 📋 Descripción General
Aplicación web moderna de gestión de tareas con almacenamiento persistente en localStorage. Interfaz responsiva construida con React y Vite para máximo rendimiento.

## 🎯 Funcionalidades Principales

### Gestión de Tareas
- **Crear tareas**: Formulario con título y descripción opcional
- **Listar tareas**: Mostrar todas las tareas almacenadas
- **Marcar como completada**: Toggle de estado (completada/pendiente)
- **Eliminar tareas**: Remover tareas de la lista
- **Editar tareas**: Modificar título y descripción
- **Filtrar tareas**: Por estado (Todas, Pendientes, Completadas)

### Persistencia
- Almacenar tareas en localStorage del navegador
- Cargar tareas al iniciar la aplicación
- Sincronización automática con cada cambio

## 📊 Modelo de Datos

### Estructura de Tarea
```json
{
  "id": "1728432000000",
  "title": "Ejemplo de tarea",
  "description": "Descripción opcional",
  "completed": false,
  "createdAt": "2026-10-08T10:00:00Z",
  "updatedAt": "2026-10-08T10:00:00Z"
}
```

### Almacenamiento en localStorage
- **Clave**: `todos-app-data`
- **Tipo**: Array de objetos JSON
- **Formato**: `[{id, title, description, completed, createdAt, updatedAt}, ...]`

## 🎨 Diseño y UI/UX

### Componentes Principales
1. **Header**: Logo, título, descripción de la app
2. **InputForm**: Campo para título, descripción y botón agregar
3. **FilterButtons**: Botones para filtrar (Todas, Pendientes, Completadas)
4. **TaskList**: Lista de tareas con contadores
5. **TaskItem**: Tarjeta individual con acciones (completar, editar, eliminar)
6. **Footer**: Información y créditos

### Estilos
- **Tema**: Dark mode moderno
- **Colores**: Paleta profesional (azul, gris, verde para completadas)
- **Tipografía**: Sistema de fuentes legible y moderno
- **Responsive**: Mobile-first, funciona en dispositivos pequeños
- **Animaciones**: Transiciones suaves en interacciones

### Estados Visuales
- Tarea pendiente: Gris claro, checkbox vacío
- Tarea completada: Verde, checkbox marcado, texto tachado
- Hover: Resalta la tarjeta
- Focus: Estilos accesibles para navegación con teclado

## 💻 Stack Técnico

### Frontend
- **Framework**: React 18+
- **Build Tool**: Vite
- **Lenguaje**: JavaScript (JSX)
- **Estilos**: CSS3 (módulos o styled-components)
- **Estado**: React Hooks (useState, useEffect, useContext opcional)
- **Persistencia**: localStorage API nativa

### Dependencias
- react
- react-dom
- vite (dev)

### Sin Dependencias
- Sin librerías de UI (Bootstrap, Material-UI, etc.)
- Sin gestión de estado externa (Redux, Zustand)
- Sin librerías de validación complejas

## 📁 Estructura de Carpetas

```
/poc-test
├── public/
│   └── index.html
├── src/
│   ├── components/
│   │   ├── Header.jsx
│   │   ├── InputForm.jsx
│   │   ├── FilterButtons.jsx
│   │   ├── TaskList.jsx
│   │   └── TaskItem.jsx
│   ├── hooks/
│   │   └── useTodos.js
│   ├── App.jsx
│   ├── App.css
│   ├── main.jsx
│   └── index.css
├── .gitignore
├── vite.config.js
├── package.json
├── SPECIFICATION.md
└── .git/
```

## ⚙️ Funcionalidades Técnicas

### Gestión de Estado
- Usar `useState` para lista de tareas
- `useEffect` para cargar y guardar en localStorage
- Sincronización automática en cada cambio

### Validaciones
- Título no puede estar vacío
- Descripción es opcional
- Máximo 500 caracteres por título
- Máximo 2000 caracteres por descripción

### Rendimiento
- Renderizado eficiente de listas
- Memoización de componentes si es necesario
- Sin re-renders innecesarios

## ✅ Criterios de Aceptación

1. **Crear tareas**: Usuario puede agregar tareas con título (requerido) y descripción (opcional)
2. **Persistencia**: Las tareas se guardan en localStorage y persisten después de refrescar
3. **Marcar completada**: Toggle funciona correctamente y se refleja visualmente
4. **Filtrar**: Los filtros (Todas, Pendientes, Completadas) funcionan sin errores
5. **Eliminar**: Las tareas se eliminan correctamente y se actualiza localStorage
6. **Editar**: Las tareas se pueden editar después de creadas
7. **Responsive**: La interfaz funciona correctamente en desktop, tablet y mobile
8. **Rendimiento**: La app carga en menos de 2 segundos
9. **Accesibilidad**: Navegación con teclado funciona correctamente
10. **Sin errores**: Console limpia, sin warnings

## 📱 Casos de Uso

### Caso 1: Crear tarea
```
Usuario escribe: "Comprar leche"
Usuario presiona: Enter o click en "Agregar"
Resultado: Tarea aparece en la lista, se guarda en localStorage
```

### Caso 2: Marcar como completada
```
Usuario hace click en checkbox de tarea
Resultado: Tarea se marca como completada, cambia estilos, se actualiza localStorage
```

### Caso 3: Filtrar tareas
```
Usuario hace click en "Pendientes"
Resultado: Solo muestra tareas no completadas, contador se actualiza
```

### Caso 4: Eliminar tarea
```
Usuario hace click en botón eliminar
Resultado: Tarea se remueve de la lista y localStorage
```

## 🔒 Consideraciones de Seguridad

- Validar entrada del usuario (evitar inyección de código)
- Sanitizar strings antes de renderizar
- No guardar información sensible en localStorage
- Limpiar datos obsoletos periódicamente

## 📊 Métricas de Éxito

- ✅ Todas las funcionalidades implementadas
- ✅ 0 errores en consola
- ✅ Tiempo de carga < 2 segundos
- ✅ 100% responsive
- ✅ localStorage sincronizado correctamente

## 🚀 Fase de Deployment

1. **Build**: `npm run build` genera carpeta `dist/`
2. **Validación**: Probar la versión buildeada localmente
3. **Hosting**: Puede deployarse en GitHub Pages, Vercel, Netlify, etc.

## 📝 Notas Adicionales

- Código limpio y bien comentado
- Componentes reutilizables
- Funciones puras sin side effects (excepto en useEffect)
- Estructura escalable para futuras mejoras
- README.md con instrucciones de uso y desarrollo
