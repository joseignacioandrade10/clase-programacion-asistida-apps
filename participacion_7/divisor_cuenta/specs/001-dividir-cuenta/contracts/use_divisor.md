# Contrato: useDivisor

**Capa**: `src/presentation/useDivisor.js`

---

## Definición

El hook `useDivisor` gestiona el estado local de la pantalla única mediante `useState` y **RECIBE sus dependencias** como parámetros (cumpliendo con DIP y la Constitución):

```javascript
/**
 * Hook de presentación que gestiona el estado del formulario de división de cuenta.
 *
 * @param {Object} dependencias
 * @param {function(Object, Object): Object} dependencias.calcularDivision - Función de cálculo del dominio.
 * @param {Object} dependencias.validarEntrada - Objeto o funciones de validación del dominio ({ validarMonto, validarPersonas, validarPropina, validarEntradas }).
 * @param {Object} dependencias.estrategias - Objeto con las implementaciones ({ exacto, haciaArriba }).
 *
 * @returns {Object} Estado y manejadores:
 *   - monto: string
 *   - personas: string
 *   - propina: string
 *   - modoRedondeo: 'exacto' | 'haciaArriba'
 *   - errores: { monto: string|null, personas: string|null, propina: string|null }
 *   - resultado: { totalPagar: number, cuotaPorPersona: number } | null
 *   - setMonto: function(string)
 *   - setPersonas: function(string)
 *   - setPropina: function(string)
 *   - setModoRedondeo: function(string)
 *   - calcular: function() - Valida y calcula o actualiza errores.
 */
```

### Comportamiento del método `calcular()`:
1. Valida los valores actuales usando `validarEntrada`.
2. Si hay errores:
   - Actualiza el estado de `errores` con los mensajes correspondientes.
   - Establece `resultado` en `null`.
3. Si los datos son válidos:
   - Limpia los `errores`.
   - Crea la entidad `Cuenta` con los valores numéricos normalizados.
   - Selecciona la estrategia correspondiente según `modoRedondeo`.
   - Invoca a `calcularDivision(cuenta, estrategia)`.
   - Actualiza `resultado` con la entidad calculada.
