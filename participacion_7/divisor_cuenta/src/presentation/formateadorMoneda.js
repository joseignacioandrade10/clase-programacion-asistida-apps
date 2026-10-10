/**
 * @file formateadorMoneda.js
 * @description Función utilitaria para formatear importes numéricos a texto con dos decimales.
 * Capa: Presentation.
 */

/**
 * Formatea un valor numérico a una representación en cadena con exactamente dos decimales.
 * 
 * ¿Qué hace?
 * Convierte un número en coma flotante en una cadena de texto con formato de moneda estándar (`0.00`).
 * 
 * ¿Por qué existe?
 * Cumple con SRP aislando la responsabilidad de presentación y formateo visual de la lógica matemática.
 * 
 * @param {number} valor - Importe numérico a formatear.
 * 
 * @returns {string} Cadena formateada con dos cifras decimales fijas (ej. "27.50", "4.00").
 * 
 * @throws No lanza excepciones. Si recibe un valor no numérico o NaN, retorna "0.00".
 */
export function formatearMoneda(valor) {
  if (typeof valor !== 'number' || isNaN(valor)) {
    return '0.00';
  }
  return valor.toFixed(2);
}
