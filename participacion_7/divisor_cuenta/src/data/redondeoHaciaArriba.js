/**
 * @file redondeoHaciaArriba.js
 * @description Estrategia de redondeo hacia arriba al entero más cercano (Math.ceil).
 * Capa: Data.
 */

/**
 * Objeto que implementa el contrato de EstrategiaRedondeo para redondeo superior.
 */
export const redondeoHaciaArriba = {
  /**
   * Aplica redondeo al siguiente número entero superior.
   * 
   * ¿Qué hace?
   * Toma un valor numérico y aplica la función matemática techo (Math.ceil),
   * asegurando que cualquier fracción residual se eleve al entero inmediato superior.
   * 
   * ¿Por qué existe?
   * Cumple con OCP permitiendo agregar el modo de pago en efectivo redondeado
   * sin modificar los módulos existentes de dominio ni de cálculo.
   * 
   * @param {number} valor - Importe numérico a redondear.
   * @returns {number} Número entero redondeado hacia arriba.
   * @throws {TypeError} Si el valor recibido no es de tipo number.
   */
  aplicar(valor) {
    if (typeof valor !== 'number' || isNaN(valor)) {
      throw new TypeError('El valor a redondear debe ser un número válido');
    }
    return Math.ceil(valor);
  }
};
