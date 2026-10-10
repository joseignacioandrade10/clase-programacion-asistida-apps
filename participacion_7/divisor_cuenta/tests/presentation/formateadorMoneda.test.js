import { describe, it, expect } from 'vitest';
import { formatearMoneda } from '../../src/presentation/formateadorMoneda.js';

describe('Formateador de Moneda', () => {
  it('formatea números con dos decimales', () => {
    expect(formatearMoneda(27.5)).toBe('27.50');
    expect(formatearMoneda(4)).toBe('4.00');
    expect(formatearMoneda(3.33333)).toBe('3.33');
    expect(formatearMoneda(0)).toBe('0.00');
  });

  it('retorna 0.00 ante valores nulos, no numéricos o NaN', () => {
    expect(formatearMoneda(null)).toBe('0.00');
    expect(formatearMoneda(undefined)).toBe('0.00');
    expect(formatearMoneda('abc')).toBe('0.00');
    expect(formatearMoneda(NaN)).toBe('0.00');
  });
});
