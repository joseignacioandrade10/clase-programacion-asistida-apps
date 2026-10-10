/**
 * @file cuenta.js
 * @description Entidad inmutable que representa los datos de consumo de una mesa.
 * Capa: Domain (JavaScript puro, sin React ni DOM).
 */

/**
 * Crea una entidad inmutable de Cuenta.
 * 
 * ¿Qué hace?
 * Valida y encapsula los datos brutos necesarios para dividir una cuenta: monto total,
 * comensales y porcentaje de propina, devolviendo un objeto congelado.
 * 
 * ¿Por qué existe?
 * Para garantizar la integridad de los datos antes de procesar el cálculo en el dominio,
 * asegurando inmutabilidad y evitando datos corruptos.
 * 
 * @param {Object} params
 * @param {number} params.montoTotal - Monto base de la cuenta. Debe ser un número mayor a 0.
 * @param {number} params.numeroPersonas - Cantidad de comensales. Debe ser un entero mayor o igual a 1.
 * @param {number} params.porcentajePropina - Porcentaje de propina. Debe ser un número mayor o igual a 0.
 * 
 * @returns {Readonly<{montoTotal: number, numeroPersonas: number, porcentajePropina: number}>}
 * Objeto congelado con las propiedades de la cuenta.
 * 
 * @throws {Error} Si montoTotal no es un número mayor a 0.
 * @throws {Error} Si numeroPersonas no es un número entero mayor o igual a 1.
 * @throws {Error} Si porcentajePropina no es un número mayor o igual a 0.
 */
export function crearCuenta({ montoTotal, numeroPersonas, porcentajePropina }) {
  if (typeof montoTotal !== 'number' || isNaN(montoTotal) || montoTotal <= 0) {
    throw new Error('El monto total debe ser un número mayor a 0');
  }

  if (
    typeof numeroPersonas !== 'number' ||
    isNaN(numeroPersonas) ||
    !Number.isInteger(numeroPersonas) ||
    numeroPersonas < 1
  ) {
    throw new Error('El número de personas debe ser un entero mayor o igual a 1');
  }

  if (
    typeof porcentajePropina !== 'number' ||
    isNaN(porcentajePropina) ||
    porcentajePropina < 0
  ) {
    throw new Error('El porcentaje de propina debe ser un número mayor o igual a 0');
  }

  return Object.freeze({
    montoTotal,
    numeroPersonas,
    porcentajePropina
  });
}
