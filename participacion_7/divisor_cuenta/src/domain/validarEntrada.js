/**
 * @file validarEntrada.js
 * @description Caso de uso para la validación y normalización de datos de entrada del usuario.
 * Capa: Domain (JavaScript puro, sin React ni DOM).
 */

/**
 * Normaliza una cadena de texto numérica limpiando espacios y convirtiendo comas en puntos.
 * 
 * ¿Qué hace?
 * Convierte cualquier separador decimal de coma (`,`) en punto (`.`) y recorta espacios residuales.
 * 
 * ¿Por qué existe?
 * Para soportar teclados móviles en español que ingresan comas, unificando el formato para el motor numérico.
 * 
 * @param {string|any} texto - Texto numérico ingresado por el usuario.
 * @returns {string} Cadena normalizada lista para conversión numérica.
 * @throws No lanza errores. Si no es string, retorna cadena vacía.
 */
export function normalizarNumero(texto) {
  if (typeof texto !== 'string') return '';
  return texto.trim().replace(',', '.');
}

/**
 * Valida el monto total ingresado.
 * 
 * ¿Qué hace?
 * Verifica que el monto sea un valor numérico válido estrictamente mayor a 0.
 * 
 * ¿Por qué existe?
 * Garantiza la regla de negocio que prohíbe cuentas vacías, negativas o con formato no numérico.
 * 
 * @param {string|any} texto - Texto del monto.
 * @returns {string|null} Mensaje de error "Monto inválido" o null si es válido.
 * @throws No lanza errores.
 */
export function validarMonto(texto) {
  const normalizado = normalizarNumero(texto);
  if (!normalizado) return 'Monto inválido';
  const valor = Number(normalizado);
  if (isNaN(valor) || valor <= 0) {
    return 'Monto inválido';
  }
  return null;
}

/**
 * Valida el número de personas comensales.
 * 
 * ¿Qué hace?
 * Verifica que el número de comensales sea un entero mayor o igual a 1.
 * 
 * ¿Por qué existe?
 * Evita la división entre cero o valores negativos/fraccionarios de comensales.
 * 
 * @param {string|any} texto - Texto del número de personas.
 * @returns {string|null} Mensaje de error "Debe haber al menos una persona" o null si es válido.
 * @throws No lanza errores.
 */
export function validarPersonas(texto) {
  const normalizado = normalizarNumero(texto);
  if (!normalizado) return 'Debe haber al menos una persona';
  const valor = Number(normalizado);
  if (isNaN(valor) || !Number.isInteger(valor) || valor < 1) {
    return 'Debe haber al menos una persona';
  }
  return null;
}

/**
 * Valida el porcentaje de propina.
 * 
 * ¿Qué hace?
 * Verifica que la propina no esté vacía y sea un número mayor o igual a 0.
 * 
 * ¿Por qué existe?
 * Garantiza que la propina sea un valor explícito (incluso si es 0%) y no quede sin definir.
 * 
 * @param {string|any} texto - Texto del porcentaje de propina.
 * @returns {string|null} Mensaje de error "La propina es requerida" o null si es válido.
 * @throws No lanza errores.
 */
export function validarPropina(texto) {
  const normalizado = normalizarNumero(texto);
  if (!normalizado) return 'La propina es requerida';
  const valor = Number(normalizado);
  if (isNaN(valor) || valor < 0) {
    return 'La propina es requerida';
  }
  return null;
}

/**
 * Valida en conjunto todas las entradas del formulario.
 * 
 * ¿Qué hace?
 * Ejecuta las validaciones de monto, personas y propina, retornando el estado global
 * y un desglose de errores por campo.
 * 
 * ¿Por qué existe?
 * Permite a la capa de presentación evaluar de forma centralizada la validez antes de calcular.
 * 
 * @param {Object} entradas
 * @param {string} entradas.monto
 * @param {string} entradas.personas
 * @param {string} entradas.propina
 * 
 * @returns {{esValido: boolean, errores: {monto: string|null, personas: string|null, propina: string|null}}}
 * @throws No lanza errores.
 */
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
