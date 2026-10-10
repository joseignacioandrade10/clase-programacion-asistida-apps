import { describe, it, expect } from 'vitest';
import { calcularDivision } from '../../src/domain/calcularDivision.js';
import { crearCuenta } from '../../src/domain/cuenta.js';

describe('Caso de Uso: CalcularDivision', () => {
  const estrategiaExactaDummy = {
    aplicar(valor) {
      return Math.round((valor + Number.EPSILON) * 100) / 100;
    }
  };

  it('calcula correctamente con 100.00, 4 personas y 10% de propina', () => {
    const cuenta = crearCuenta({
      montoTotal: 100.0,
      numeroPersonas: 4,
      porcentajePropina: 10.0
    });

    const resultado = calcularDivision(cuenta, estrategiaExactaDummy);

    expect(resultado.totalPagar).toBe(110.0);
    expect(resultado.cuotaPorPersona).toBe(27.50);
  });

  it('calcula correctamente con 90.00, 3 personas y 0% de propina', () => {
    const cuenta = crearCuenta({
      montoTotal: 90.0,
      numeroPersonas: 3,
      porcentajePropina: 0.0
    });

    const resultado = calcularDivision(cuenta, estrategiaExactaDummy);

    expect(resultado.totalPagar).toBe(90.0);
    expect(resultado.cuotaPorPersona).toBe(30.0);
  });

  it('calcula división periódica con 10.00, 3 personas y 0% propina dando 3.33', () => {
    const cuenta = crearCuenta({
      montoTotal: 10.0,
      numeroPersonas: 3,
      porcentajePropina: 0.0
    });

    const resultado = calcularDivision(cuenta, estrategiaExactaDummy);

    expect(resultado.totalPagar).toBe(10.0);
    expect(resultado.cuotaPorPersona).toBe(3.33);
  });

  it('lanza error si la estrategia no cumple el contrato', () => {
    const cuenta = crearCuenta({
      montoTotal: 50.0,
      numeroPersonas: 2,
      porcentajePropina: 10.0
    });

    expect(() => calcularDivision(cuenta, null)).toThrow();
    expect(() => calcularDivision(cuenta, {})).toThrow();
  });
});
