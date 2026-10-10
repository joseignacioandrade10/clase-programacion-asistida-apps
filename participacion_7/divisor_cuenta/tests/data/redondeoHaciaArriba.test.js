import { describe, it, expect } from 'vitest';
import { redondeoHaciaArriba } from '../../src/data/redondeoHaciaArriba.js';

describe('Estrategia de Redondeo Hacia Arriba', () => {
  it('redondea 3.33 hacia arriba al entero 4', () => {
    expect(redondeoHaciaArriba.aplicar(3.33)).toBe(4);
  });

  it('redondea 27.50 hacia arriba al entero 28', () => {
    expect(redondeoHaciaArriba.aplicar(27.50)).toBe(28);
  });

  it('mantiene enteros exactos como 30 sin alterarlos', () => {
    expect(redondeoHaciaArriba.aplicar(30.00)).toBe(30);
  });

  it('redondea valores con fracciones mínimas hacia arriba', () => {
    expect(redondeoHaciaArriba.aplicar(10.01)).toBe(11);
  });

  it('lanza TypeError si recibe un valor no numérico', () => {
    expect(() => redondeoHaciaArriba.aplicar('abc')).toThrow(TypeError);
    expect(() => redondeoHaciaArriba.aplicar(null)).toThrow(TypeError);
  });
});
