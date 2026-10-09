# Data Model & Entidades: División de Cuenta (JavaScript / React)

**Feature**: `specs/001-dividir-cuenta` | **Fecha**: 2026-10-09

Este documento define las entidades, modelos de datos, contratos y tipos de datos que estructuran la aplicación en **JavaScript**, organizados bajo las tres capas arquitectónicas: `domain`, `data` y `presentation`.

---

## 1. Capa de Dominio (`src/domain/`)

*Nota: La capa `domain` es JavaScript puro (ES Modules) y NO contiene ninguna importación de React ni referencias al DOM.*

### 1.1 Entidad `Cuenta` (`src/domain/cuenta.js`)
Representa los datos brutos de la transacción antes del cálculo.

```javascript
/**
 * Crea una entidad inmutable de Cuenta.
 * @param {Object} params
 * @param {number} params.montoTotal - Monto base de la cuenta (> 0).
 * @param {number} params.numeroPersonas - Cantidad de personas (entero >= 1).
 * @param {number} params.porcentajePropina - Porcentaje de propina (>= 0).
 * @returns {Readonly<{montoTotal: number, numeroPersonas: number, porcentajePropina: number}>}
 */
export function crearCuenta({ montoTotal, numeroPersonas, porcentajePropina }) {
  return Object.freeze({
    montoTotal,
    numeroPersonas,
    porcentajePropina
  });
}
```

- **Inmutabilidad:** Objeto congelado con `Object.freeze`.
- **Reglas de negocio asociadas:**
  - `montoTotal`: número mayor a 0.
  - `numeroPersonas`: entero mayor o igual a 1.
  - `porcentajePropina`: número mayor o igual a 0.

---

### 1.2 Entidad `Resultado` (`src/domain/resultado.js`)
Representa el producto del cálculo efectuado para la cuenta.

```javascript
/**
 * Crea una entidad inmutable de Resultado.
 * @param {Object} params
 * @param {number} params.totalPagar - Monto total incluyendo propina.
 * @param {number} params.cuotaPorPersona - Monto individual tras aplicar la estrategia de redondeo.
 * @returns {Readonly<{totalPagar: number, cuotaPorPersona: number}>}
 */
export function crearResultado({ totalPagar, cuotaPorPersona }) {
  return Object.freeze({
    totalPagar,
    cuotaPorPersona
  });
}
```

- **Inmutabilidad:** Objeto congelado con `Object.freeze`.
- **Valores:**
  - `totalPagar`: Corresponde al monto base más el valor de la propina calculada.
  - `cuotaPorPersona`: Corresponde a la cuota individual tras aplicar la estrategia de redondeo.

---

### 1.3 Contrato `EstrategiaRedondeo` (`src/domain/estrategiaRedondeo.js`)
Contrato claro para las estrategias de redondeo en JavaScript.

```javascript
/**
 * Contrato de Estrategia de Redondeo.
 * Cualquier estrategia válida DEBE ser un objeto con un método `aplicar(valor)`.
 *
 * @typedef {Object} IEstrategiaRedondeo
 * @property {function(number): number} aplicar - Recibe el valor numérico y retorna el redondeado.
 */

/**
 * Valida en tiempo de ejecución que un objeto satisfaga el contrato de EstrategiaRedondeo.
 * @param {any} estrategia
 * @returns {boolean}
 */
export function esEstrategiaValida(estrategia) {
  return (
    typeof estrategia === 'object' &&
    estrategia !== null &&
    typeof estrategia.aplicar === 'function'
  );
}
```

- **ISP:** Interfaz pequeña y precisa: una única función `aplicar(valor)`.
- **LSP / OCP:** Permite añadir nuevas estrategias sin modificar `calcularDivision.js`.

---

### 1.4 Caso de Uso `CalcularDivision` (`src/domain/calcularDivision.js`)
Aplica la lógica pura de cálculo matemático sin formateo ni validaciones de UI.

```javascript
import { crearResultado } from './resultado.js';

/**
 * Calcula la división de la cuenta delegando el redondeo en la estrategia.
 * @param {Object} cuenta - Objeto Cuenta ({ montoTotal, numeroPersonas, porcentajePropina }).
 * @param {Object} estrategia - Objeto que implementa { aplicar(valor) }.
 * @returns {Readonly<{totalPagar: number, cuotaPorPersona: number}>}
 */
export function calcularDivision(cuenta, estrategia) {
  const propina = cuenta.montoTotal * (cuenta.porcentajePropina / 100.0);
  const total = cuenta.montoTotal + propina;
  const cuotaExacta = total / cuenta.numeroPersonas;
  const cuotaFinal = estrategia.aplicar(cuotaExacta);

  return crearResultado({
    totalPagar: total,
    cuotaPorPersona: cuotaFinal
  });
}
```

---

### 1.5 Caso de Uso `ValidarEntrada` (`src/domain/validarEntrada.js`)
Valida los datos de entrada en formato texto provenientes del usuario y retorna mensajes de error claros o `null` si son válidos.

```javascript
export function normalizarNumero(texto) {
  if (typeof texto !== 'string') return '';
  return texto.trim().replace(',', '.');
}

export function validarMonto(texto) {
  const normalizado = normalizarNumero(texto);
  if (!normalizado) return 'Monto inválido';
  const valor = Number(normalizado);
  if (isNaN(valor) || valor <= 0) {
    return 'Monto inválido';
  }
  return null;
}

export function validarPersonas(texto) {
  const normalizado = normalizarNumero(texto);
  if (!normalizado) return 'Debe haber al menos una persona';
  const valor = Number(normalizado);
  if (isNaN(valor) || !Number.isInteger(valor) || valor < 1) {
    return 'Debe haber al menos una persona';
  }
  return null;
}

export function validarPropina(texto) {
  const normalizado = normalizarNumero(texto);
  if (!normalizado) return 'La propina es requerida';
  const valor = Number(normalizado);
  if (isNaN(valor) || valor < 0) {
    return 'La propina es requerida';
  }
  return null;
}

export function validarEntradas({ monto, personas, propina }) {
  const errorMonto = validarMonto(monto);
  const errorPersonas = validarPersonas(personas);
  const errorPropina = validarPropina(propina);

  const esValido = !errorMonto && !errorPersonas && !errorPropina;

  return {
    esValido,
    errores: {
      monto: errorMonto,
      personas: errorPersonas,
      propina: errorPropina
    }
  };
}
```

---

## 2. Capa de Datos (`src/data/`)

### 2.1 `RedondeoExacto` (`src/data/redondeoExacto.js`)
```javascript
export const redondeoExacto = {
  /**
   * Redondea a 2 decimales estándar.
   * @param {number} valor
   * @returns {number}
   */
  aplicar(valor) {
    return Math.round((valor + Number.EPSILON) * 100) / 100;
  }
};
```

### 2.2 `RedondeoHaciaArriba` (`src/data/redondeoHaciaArriba.js`)
```javascript
export const redondeoHaciaArriba = {
  /**
   * Redondea hacia arriba al entero más cercano (ceil).
   * @param {number} valor
   * @returns {number}
   */
  aplicar(valor) {
    return Math.ceil(valor);
  }
};
```

---

## 3. Capa de Presentación (`src/presentation/`)

### 3.1 Hook `useDivisor` (`src/presentation/useDivisor.js`)
Recibe dependencias inyectadas y maneja el estado local de la pantalla única.

```javascript
/**
 * Hook de gestión de estado para la pantalla divisora.
 * RECIBE sus dependencias como parámetros (DIP).
 *
 * @param {Object} dependencias
 * @param {function} dependencias.calcularDivision
 * @param {Object} dependencias.validarEntrada
 * @param {Object} dependencias.estrategias - { exacto, haciaArriba }
 */
export function useDivisor({ calcularDivision, validarEntrada, estrategias }) { ... }
```

### 3.2 Formateador de Moneda (`src/presentation/formateadorMoneda.js`)
```javascript
/**
 * Formatea un valor numérico a cadena con exactamente dos decimales.
 * @param {number} valor
 * @returns {string}
 */
export function formatearMoneda(valor) {
  if (typeof valor !== 'number' || isNaN(valor)) {
    return '0.00';
  }
  return valor.toFixed(2);
}
```

### 3.3 Componente UI (`src/presentation/PantallaDivisor.jsx`)
Renderiza el formulario y los resultados consumiendo los datos provistos por `useDivisor`.
