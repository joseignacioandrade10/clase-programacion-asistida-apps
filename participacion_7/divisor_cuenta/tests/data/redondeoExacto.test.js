import { describe, it, expect } from 'vitest';
import { redondeoExacto } from '../../src/data/redondeoExacto.js';

describe('Estrategia de Redondeo Exacto', () => {
  it('debe mantener valores que ya tienen dos decimales exactos', () => {
    expect(redondeoExacto.aplicar(27.50)).toBe(27.50);
  });

  it('debe redondear decimales periódicos a dos decimales', () => {
    expect(redondeoExacto.aplicar(10 / 3)).toBe(3.33);
  });

  it('debe redondear enteros correctamente', () => {
    expect(redondeoExacto.aplicar(30.00)).toBe(30.00);
  });

  it('debe redondear hacia arriba el medio centavo estándar', () => {
    expect(redondeoExacto.aplicar(12.345)).toBe(12.35);
  });
});
