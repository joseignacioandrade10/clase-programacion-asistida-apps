# Contrato de Interfaz de Usuario: PantallaDivisor

**Capa**: `lib/presentation/pantalla_divisor.dart`

---

## Estructura de la Pantalla Única

La interfaz se compone de los siguientes elementos visuales y claves (Keys) para pruebas de widgets:

1. **Campo Monto Total**:
   - `Key('campo_monto')`
   - Etiqueta: "Monto total"
   - Tipo de teclado: Numérico decimal.
   - Mensaje de error: `"Monto inválido"` ante formato incorrecto o valor $\le 0$.

2. **Campo Número de Personas**:
   - `Key('campo_personas')`
   - Etiqueta: "Número de personas"
   - Tipo de teclado: Numérico entero.
   - Mensaje de error: `"Debe haber al menos una persona"` si el valor es $< 1$.

3. **Campo Porcentaje de Propina**:
   - `Key('campo_propina')`
   - Etiqueta: "Porcentaje de propina (%)"
   - Tipo de teclado: Numérico decimal.
   - Mensaje de error: `"La propina es requerida"` si se deja vacío o valor $< 0$.

4. **Selector de Modo de Redondeo**:
   - `Key('selector_redondeo')`
   - Opciones:
     - "Exacto" (`Key('opcion_redondeo_exacto')`)
     - "Hacia arriba al entero más cercano" (`Key('opcion_redondeo_arriba')`)

5. **Botón Calcular**:
   - `Key('boton_calcular')`
   - Texto: "Calcular"

6. **Área de Resultado**:
   - `Key('texto_resultado')`
   - Formato visual: Muestra el importe con dos decimales formateado por `FormateadorMoneda` (ej. `27.50`).
   - Visibilidad: Oculto o vacío si hubo algún error de validación.
