import { describe, it, expect } from 'vitest';
import {
  validarMonto,
  validarPersonas,
  validarPropina,
  validarEntradas,
  normalizarNumero
} from '../../src/domain/validarEntrada.js';

describe('Caso de Uso: ValidarEntrada', () => {
  describe('normalizarNumero', () => {
    it('convierte comas en puntos', () => {
      expect(normalizarNumero('100,50')).toBe('100.50');
    });

    it('elimina espacios en blanco', () => {
      expect(normalizarNumero('  25.00  ')).toBe('25.00');
    });
  });

  describe('validarMonto', () => {
    it('acepta montos positivos con punto o coma', () => {
      expect(validarMonto('100.00')).toBeNull();
      expect(validarMonto('100,00')).toBeNull();
      expect(validarMonto('50')).toBeNull();
    });

    it('rechaza montos menores o iguales a cero', () => {
      expect(validarMonto('0')).toBe('Monto inválido');
      expect(validarMonto('-15.00')).toBe('Monto inválido');
    });

    it('rechaza entradas no numéricas o vacías', () => {
      expect(validarMonto('abc')).toBe('Monto inválido');
      expect(validarMonto('')).toBe('Monto inválido');
      expect(validarMonto(null)).toBe('Monto inválido');
      expect(validarMonto(undefined)).toBe('Monto inválido');
    });
  });

  describe('validarPersonas', () => {
    it('acepta enteros mayores o iguales a 1', () => {
      expect(validarPersonas('1')).toBeNull();
      expect(validarPersonas('4')).toBeNull();
    });

    it('rechaza comensales menores a 1', () => {
      expect(validarPersonas('0')).toBe('Debe haber al menos una persona');
      expect(validarPersonas('-2')).toBe('Debe haber al menos una persona');
    });

    it('rechaza decimales no enteros y valores no numéricos', () => {
      expect(validarPersonas('2.5')).toBe('Debe haber al menos una persona');
      expect(validarPersonas('abc')).toBe('Debe haber al menos una persona');
      expect(validarPersonas('')).toBe('Debe haber al menos una persona');
    });
  });

  describe('validarPropina', () => {
    it('acepta 0 o propinas positivas con punto o coma', () => {
      expect(validarPropina('0')).toBeNull();
      expect(validarPropina('10')).toBeNull();
      expect(validarPropina('15.5')).toBeNull();
      expect(validarPropina('15,5')).toBeNull();
    });

    it('rechaza propina negativa', () => {
      expect(validarPropina('-5')).toBe('La propina es requerida');
    });

    it('rechaza propina vacía o no numérica', () => {
      expect(validarPropina('')).toBe('La propina es requerida');
      expect(validarPropina('   ')).toBe('La propina es requerida');
      expect(validarPropina('xyz')).toBe('La propina es requerida');
      expect(validarPropina(null)).toBe('La propina es requerida');
    });
  });

  describe('validarEntradas (conjunto)', () => {
    it('retorna esValido: true si todos los campos son correctos', () => {
      const res = validarEntradas({
        monto: '100,00',
        personas: '4',
        propina: '10'
      });
      expect(res.esValido).toBe(true);
      expect(res.errores.monto).toBeNull();
      expect(res.errores.personas).toBeNull();
      expect(res.errores.propina).toBeNull();
    });

    it('retorna esValido: false y todos los mensajes de error correspondientes', () => {
      const res = validarEntradas({
        monto: 'abc',
        personas: '0',
        propina: ''
      });
      expect(res.esValido).toBe(false);
      expect(res.errores.monto).toBe('Monto inválido');
      expect(res.errores.personas).toBe('Debe haber al menos una persona');
      expect(res.errores.propina).toBe('La propina es requerida');
    });
  });
});
