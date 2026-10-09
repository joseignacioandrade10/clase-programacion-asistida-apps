# Contrato de Interfaz: EstrategiaRedondeo

**Capa**: `src/domain/estrategiaRedondeo.js`

---

## Definición

En JavaScript, el contrato de estrategia de redondeo se define como un objeto que expone una función `aplicar(valor)`:

```javascript
/**
 * @typedef {Object} EstrategiaRedondeo
 * @property {function(number): number} aplicar - Aplica la regla de redondeo al valor numérico recibido.
 */
```

### Especificación de la función `aplicar`:
- **Parámetro**: `valor` (`number` positivo).
- **Retorno**: `number` redondeado según la regla concreta.
- **Excepciones / Errores**: Ninguno con entradas numéricas válidas.

---

## Implementaciones Concretas (`src/data/`)

1. **`redondeoExacto.js`**:
   - `aplicar(27.50)` $\rightarrow$ `27.50`
   - `aplicar(3.33333...)` $\rightarrow$ `3.33`

2. **`redondeoHaciaArriba.js`**:
   - `aplicar(3.33)` $\rightarrow$ `4` (o `4.00`)
   - `aplicar(27.50)` $\rightarrow$ `28` (o `28.00`)
   - `aplicar(30.00)` $\rightarrow$ `30` (los enteros cerrados se conservan)
