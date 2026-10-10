/**
 * @file resultado.js
 * @description Entidad inmutable que representa el resultado final del cálculo de una cuenta.
 * Capa: Domain (JavaScript puro, sin React ni DOM).
 */

/**
 * Crea una entidad inmutable de Resultado.
 * 
 * ¿Qué hace?
 * Encapsula el importe total consolidado (con propina) y la cuota individual por comensal
 * en un objeto inmutable congelado.
 * 
 * ¿Por qué existe?
 * Para transportar el resultado del cálculo desde la lógica de dominio hacia la presentación
 * sin riesgo de modificaciones externas accidentales.
 * 
 * @param {Object} params
 * @param {number} params.totalPagar - Monto total a pagar (monto + propina). Debe ser un número >= 0.
 * @param {number} params.cuotaPorPersona - Importe individual a pagar por cada comensal. Debe ser un número >= 0.
 * 
 * @returns {Readonly<{totalPagar: number, cuotaPorPersona: number}>}
 * Objeto congelado con las propiedades totalPagar y cuotaPorPersona.
 * 
 * @throws {Error} Si totalPagar no es un número mayor o igual a 0.
 * @throws {Error} Si cuotaPorPersona no es un número mayor o igual a 0.
 */
export function crearResultado({ totalPagar, cuotaPorPersona }) {
  if (typeof totalPagar !== 'number' || isNaN(totalPagar) || totalPagar < 0) {
    throw new Error('El total a pagar debe ser un número mayor o igual a 0');
  }

  if (typeof cuotaPorPersona !== 'number' || isNaN(cuotaPorPersona) || cuotaPorPersona < 0) {
    throw new Error('La cuota por persona debe ser un número mayor o igual a 0');
  }

  return Object.freeze({
    totalPagar,
    cuotaPorPersona
  });
}
