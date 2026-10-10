/**
 * @file calcularDivision.js
 * @description Caso de uso que aplica la fórmula matemática de la división de cuenta.
 * Capa: Domain (JavaScript puro, sin React ni DOM).
 */

import { crearResultado } from './resultado.js';
import { validarContratoEstrategia } from './estrategiaRedondeo.js';

/**
 * Calcula la división de la cuenta delegando el redondeo a la estrategia inyectada.
 * 
 * ¿Qué hace?
 * Calcula el monto total sumando el subtotal y el porcentaje de propina,
 * divide equitativamente entre los comensales y delega el redondeo en la estrategia provista.
 * 
 * ¿Por qué existe?
 * Cumple con SRP al encapsular exclusivamente la lógica matemática de la cuenta,
 * sin ocuparse de validaciones de formularios de usuario ni de formateos visuales.
 * 
 * @param {Object} cuenta - Objeto inmutable Cuenta ({ montoTotal, numeroPersonas, porcentajePropina }).
 * @param {Object} estrategia - Objeto que implementa { aplicar(valor) }.
 * 
 * @returns {Readonly<{totalPagar: number, cuotaPorPersona: number}>}
 * Objeto inmutable Resultado con el total consolidado y la cuota individual.
 * 
 * @throws {TypeError} Si la estrategia no implementa el método aplicar.
 * @throws {Error} Si la cuenta no es válida.
 */
export function calcularDivision(cuenta, estrategia) {
  if (!cuenta || typeof cuenta !== 'object') {
    throw new Error('Se requiere un objeto cuenta válido');
  }

  validarContratoEstrategia(estrategia);

  const propina = cuenta.montoTotal * (cuenta.porcentajePropina / 100.0);
  const total = cuenta.montoTotal + propina;
  const cuotaExacta = total / cuenta.numeroPersonas;
  const cuotaFinal = estrategia.aplicar(cuotaExacta);

  return crearResultado({
    totalPagar: total,
    cuotaPorPersona: cuotaFinal
  });
}
