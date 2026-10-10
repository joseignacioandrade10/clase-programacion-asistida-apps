/**
 * @file redondeoExacto.js
 * @description Estrategia de redondeo exacto estándar a 2 decimales.
 * Capa: Data.
 */

/**
 * Objeto que implementa el contrato de EstrategiaRedondeo para redondeo aritmético estándar.
 */
export const redondeoExacto = {
  /**
   * Aplica redondeo estándar a 2 decimales.
   * 
   * ¿Qué hace?
   * Redondea un valor en coma flotante a dos cifras decimales usando redondeo estándar
   * asistido con Number.EPSILON para evitar sesgos de precisión binaria.
   * 
   * ¿Por qué existe?
   * Permite satisfacer el requerimiento de modo "Exacto" respetando el principio OCP/LSP.
   * 
   * @param {number} valor - Importe numérico a redondear.
   * @returns {number} Valor numérico redondeado a dos cifras decimales.
   * @throws {TypeError} Si el valor recibido no es de tipo number.
   */
  aplicar(valor) {
    if (typeof valor !== 'number' || isNaN(valor)) {
      throw new TypeError('El valor a redondear debe ser un número válido');
    }
    return Math.round((valor + Number.EPSILON) * 100) / 100;
  }
};
