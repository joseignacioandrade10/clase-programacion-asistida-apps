# Contrato de Interfaz de Usuario: PantallaDivisor (React)

**Capa**: `src/presentation/PantallaDivisor.jsx`

---

## Estructura de la Pantalla Única

La interfaz se compone de los siguientes elementos visuales, accesibles mediante `id` y `data-testid` para pruebas con React Testing Library / Vitest:

1. **Campo Monto Total**:
   - `id="campo_monto"`, `data-testid="campo_monto"`
   - Etiqueta: "Monto total"
   - Tipo: `<input type="text" />` o `<input type="number" step="any" />`
   - Contenedor de error: `data-testid="error_monto"` con el texto `"Monto inválido"` ante formato incorrecto o valor $\le 0$.

2. **Campo Número de Personas**:
   - `id="campo_personas"`, `data-testid="campo_personas"`
   - Etiqueta: "Número de personas"
   - Tipo: `<input type="number" min="1" step="1" />`
   - Contenedor de error: `data-testid="error_personas"` con el texto `"Debe haber al menos una persona"` si el valor es $< 1$ o no entero.

3. **Campo Porcentaje de Propina**:
   - `id="campo_propina"`, `data-testid="campo_propina"`
   - Etiqueta: "Porcentaje de propina (%)"
   - Tipo: `<input type="number" min="0" step="any" />`
   - Contenedor de error: `data-testid="error_propina"` con el texto `"La propina es requerida"` si se deja vacío o valor $< 0$.

4. **Selector de Modo de Redondeo**:
   - `data-testid="selector_redondeo"`
   - Opciones:
     - "Exacto": `data-testid="opcion_redondeo_exacto"` (`value="exacto"`)
     - "Hacia arriba al entero más cercano": `data-testid="opcion_redondeo_arriba"` (`value="haciaArriba"`)

5. **Botón Calcular**:
   - `data-testid="boton_calcular"`
   - Texto: "Calcular"

6. **Área de Resultado**:
   - `data-testid="texto_resultado"`
   - Formato visual: Muestra el importe por persona formateado con dos decimales mediante `formateadorMoneda` (ej. `27.50`).
   - Visibilidad: Oculto o vacío si hubo algún error de validación.
