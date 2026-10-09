# Research & Decisiones Técnicas: División de Cuenta (React + Vite)

**Feature**: `specs/001-dividir-cuenta` | **Fecha**: 2026-10-09

Este documento consolida las decisiones de diseño arquitectónico y técnico para la implementación del divisor de cuentas en **React con Vite y JavaScript**, en estricto apego a la Constitución del proyecto (v2.0.0) y los requerimientos especificados en `spec.md`.

---

## 1. Separación de Responsabilidades y Capas (SOLID)

### Decisión
Organizar el código en tres capas estrictas dentro de `src/`:

1. **`src/domain/` (JavaScript Puro)**:
   - **`cuenta.js`**: Fabrica / valida la estructura inmutable de la cuenta (`montoTotal`, `numeroPersonas`, `porcentajePropina`).
   - **`resultado.js`**: Fabrica / estructura inmutable del resultado (`totalPagar`, `cuotaPorPersona`).
   - **`estrategiaRedondeo.js`**: Contrato conceptual y función de validación de contrato para la estrategia de redondeo: debe exponer la función `aplicar(valor)` (ISP y OCP).
   - **`calcularDivision.js`**: Caso de uso que aplica la fórmula matemática $\text{Total} = \text{Monto} + (\text{Monto} \times \frac{\text{Propina}}{100})$, divide entre los comensales y delega el redondeo en la estrategia. No valida ni formatea (SRP).
   - **`validarEntrada.js`**: Caso de uso que valida individual y conjuntamente los campos numéricos de entrada, normaliza separadores decimales (coma y punto) y produce los mensajes de error especificados (SRP).
   *Restricción estricta:* Esta capa no importa nada de React, DOM ni librerías externas.

2. **`src/data/`**:
   - **`redondeoExacto.js`**: Implementación concreta de la estrategia que aplica redondeo a 2 decimales estándar mediante `aplicar(valor)`.
   - **`redondeoHaciaArriba.js`**: Implementación concreta de la estrategia que eleva el valor al entero inmediato superior ($\lceil x \rceil$) mediante `aplicar(valor)`.

3. **`src/presentation/`**:
   - **`useDivisor.js`**: Custom Hook de React que encapsula el estado local (`useState`) de la pantalla única. **RECIBE sus dependencias** (`calcularDivision`, `validarEntrada`, estrategias de redondeo) por argumentos, sin importar directamente de `data/` (DIP).
   - **`formateadorMoneda.js`**: Función utilitaria pura para formatear números flotantes a cadenas con exactamente dos cifras decimales (`valor.toFixed(2)`) (SRP).
   - **`PantallaDivisor.jsx`**: Componente de interfaz de usuario de pantalla única que utiliza `useDivisor` y renderiza el formulario y los resultados.

4. **`src/main.jsx`**:
   - **Único punto de composición:** Enlaza las implementaciones concretas de `data/` (`redondeoExacto`, `redondeoHaciaArriba`), los casos de uso de `domain/` (`calcularDivision`, `validarEntrada`) y las inyecta en la aplicación/componentes de `presentation/`.

### Rationale
- Cumple integralmente la Constitución: desacoplamiento absoluto entre la lógica de negocio pura y la interfaz gráfica.
- Facilita agregar futuras estrategias de redondeo (ej. redondeo comercial o truncado) simplemente creando un archivo en `data/` que provea `aplicar(valor)` sin tocar `domain` ni `presentation` (OCP y LSP).

### Alternativas Consideradas
- **Manejar la lógica de cálculo directamente dentro de `PantallaDivisor.jsx`**: Descartado tajantemente por violar SRP, DIP y acoplar el cálculo al ciclo de renderizado de React.
- **Utilizar gestores de estado globales (Redux, Zustand, Recoil)**: Descartado porque la app es de una única pantalla y la spec exige estado local con `useState` sin dependencias externas.

---

## 2. Estrategia de Manejo de Estado

### Decisión
Utilizar `useState` dentro del hook `useDivisor.js`, manteniendo los campos del formulario (`monto`, `personas`, `propina`, `modoRedondeo`), los errores de validación (`errores`) y el objeto `resultado` (o `null`).

### Rationale
- React nativo sin dependencias de terceros.
- El custom hook desacopla la máquina de estado de la representación visual JSX, permitiendo probar la lógica de presentación con Vitest (`renderHook`) de forma directa y limpia.

---

## 3. Normalización de Separadores Decimales

### Decisión
En `validarEntrada.js`, normalizar cualquier cadena reemplazando comas (`,`) por puntos (`.`) antes de la conversión con `Number()` o `parseFloat()`.

### Rationale
- Permite que los usuarios introduzcan tanto `100.00` como `100,00` indistintamente, satisfaciendo el criterio de aceptación y la aclaración de la spec.

---

## 4. Estrategia de Pruebas (Vitest)

### Decisión
- **Unit Tests**: Ejecutar pruebas con Vitest en `tests/domain/` y `tests/data/` (JavaScript puro en entorno Node, ultrarrápidas).
- **Component Tests**: Pruebas con Vitest + `@testing-library/react` + `jsdom` en `tests/presentation/` para simular la interacción del usuario y verificar los criterios de aceptación de la spec.

### Rationale
- Vitest es nativo para Vite, compatible con ESM y ejecuta las pruebas a máxima velocidad sin configuración compleja.
