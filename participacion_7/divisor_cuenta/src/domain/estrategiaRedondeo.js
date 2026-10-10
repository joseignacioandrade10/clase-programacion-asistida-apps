/**
 * @file estrategiaRedondeo.js
 * @description Contrato y validación para las estrategias de redondeo.
 * Capa: Domain (JavaScript puro, sin React ni DOM).
 */

/**
 * Contrato de Estrategia de Redondeo.
 * En JavaScript, cualquier objeto o módulo que actúe como estrategia de redondeo
 * debe implementar una función `aplicar(valor)`.
 * 
 * @typedef {Object} EstrategiaRedondeo
 * @property {function(number): number} aplicar - Función que recibe un número y devuelve el número redondeado.
 */

/**
 * Valida si un objeto cumple con el contrato de EstrategiaRedondeo.
 * 
 * ¿Qué hace?
 * Comprueba en tiempo de ejecución que el objeto provisto no sea nulo y contenga
 * una función llamada `aplicar`.
 * 
 * ¿Por qué existe?
 * Para hacer valer el principio de sustitución de Liskov (LSP) y segregación de interfaz (ISP)
 * en JavaScript sin recurrir a tipos estáticos del lenguaje.
 * 
 * @param {any} estrategia - El objeto a validar como estrategia de redondeo.
 * 
 * @returns {boolean} Retorna true si cumple el contrato, false en caso contrario.
 * 
 * @throws {TypeError} Si la estrategia no cumple el contrato y se invoca validarContratoEstrategia.
 */
export function esEstrategiaValida(estrategia) {
  return (
    typeof estrategia === 'object' &&
    estrategia !== null &&
    typeof estrategia.aplicar === 'function'
  );
}

/**
 * Asegura que una estrategia cumpla el contrato, lanzando un error si no lo hace.
 * 
 * ¿Qué hace?
 * Valida la estrategia y lanza una excepción si no cumple con la interfaz esperada.
 * 
 * ¿Por qué existe?
 * Para fallar tempranamente si se inyecta una dependencia incorrecta en el cálculo.
 * 
 * @param {any} estrategia - Estrategia a verificar.
 * @throws {TypeError} Si la estrategia no implementa el método aplicar.
 */
export function validarContratoEstrategia(estrategia) {
  if (!esEstrategiaValida(estrategia)) {
    throw new TypeError('La estrategia de redondeo debe ser un objeto con un método aplicar(valor)');
  }
}
