/**
 * @file useDivisor.js
 * @description Custom Hook de React para la gestión del estado de la pantalla divisora.
 * Capa: Presentation.
 */

import { useState } from 'react';
import { crearCuenta } from '../domain/cuenta.js';

/**
 * Hook de presentación que encapsula el estado local y las acciones de la pantalla divisora.
 * 
 * ¿Qué hace?
 * Gestiona los valores de los campos de entrada, los errores de validación y el resultado
 * del cálculo, coordinando la validación y el caso de uso inyectado.
 * 
 * ¿Por qué existe?
 * Cumple con DIP al RECIBIR sus dependencias por inyección en lugar de importarlas
 * directamente de data/ o acoplarlas a una única implementación. Desacopla la lógica de UI del componente visual.
 * 
 * @param {Object} dependencias - Dependencias inyectadas.
 * @param {function(Object, Object): Object} dependencias.calcularDivision - Función del dominio que calcula la división.
 * @param {Object} [dependencias.validarEntrada] - Módulo o funciones de validación de dominio ({ validarEntradas }).
 * @param {Object} dependencias.estrategias - Estrategias disponibles ({ exacto, haciaArriba }).
 * 
 * @returns {Object} Estado y despachadores:
 *  - monto {string}
 *  - personas {string}
 *  - propina {string}
 *  - modoRedondeo {string} ('exacto' | 'haciaArriba')
 *  - errores {Object} ({ monto, personas, propina })
 *  - resultado {Object|null} ({ totalPagar, cuotaPorPersona } o null)
 *  - setMonto {function(string)}
 *  - setPersonas {function(string)}
 *  - setPropina {function(string)}
 *  - setModoRedondeo {function(string)}
 *  - calcular {function()}
 * 
 * @throws No lanza excepciones no controladas hacia el componente React; captura y refleja errores en el estado.
 */
export function useDivisor({ calcularDivision, validarEntrada, estrategias }) {
  const [monto, setMonto] = useState('');
  const [personas, setPersonas] = useState('');
  const [propina, setPropina] = useState('');
  const [modoRedondeo, setModoRedondeo] = useState('exacto');
  const [errores, setErrores] = useState({
    monto: null,
    personas: null,
    propina: null
  });
  const [resultado, setResultado] = useState(null);

  const calcular = () => {
    // 1. Si existe validador de dominio, validar entradas
    if (validarEntrada && typeof validarEntrada.validarEntradas === 'function') {
      const validacion = validarEntrada.validarEntradas({ monto, personas, propina });
      if (!validacion.esValido) {
        setErrores(validacion.errores);
        setResultado(null);
        return;
      }
    }

    // 2. Normalizar entradas y construir la cuenta
    try {
      const montoNormalizado = Number(String(monto).trim().replace(',', '.'));
      const personasNormalizadas = Number(String(personas).trim());
      const propinaNormalizada = Number(String(propina).trim().replace(',', '.'));

      const cuenta = crearCuenta({
        montoTotal: montoNormalizado,
        numeroPersonas: personasNormalizadas,
        porcentajePropina: propinaNormalizada
      });

      // 3. Seleccionar la estrategia de redondeo
      const estrategia =
        modoRedondeo === 'haciaArriba'
          ? estrategias.haciaArriba
          : estrategias.exacto;

      // 4. Ejecutar el caso de uso de cálculo
      const res = calcularDivision(cuenta, estrategia);

      setErrores({ monto: null, personas: null, propina: null });
      setResultado(res);
    } catch (error) {
      setResultado(null);
      setErrores((prev) => ({
        ...prev,
        general: error.message
      }));
    }
  };

  return {
    monto,
    personas,
    propina,
    modoRedondeo,
    errores,
    resultado,
    setMonto,
    setPersonas,
    setPropina,
    setModoRedondeo,
    calcular
  };
}
