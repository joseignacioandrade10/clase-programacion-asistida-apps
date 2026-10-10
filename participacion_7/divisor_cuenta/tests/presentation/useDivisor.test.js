import { describe, it, expect } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useDivisor } from '../../src/presentation/useDivisor.js';
import { calcularDivision } from '../../src/domain/calcularDivision.js';
import * as validarEntrada from '../../src/domain/validarEntrada.js';
import { redondeoExacto } from '../../src/data/redondeoExacto.js';
import { redondeoHaciaArriba } from '../../src/data/redondeoHaciaArriba.js';

describe('Hook: useDivisor', () => {
  const dependencias = {
    calcularDivision,
    validarEntrada,
    estrategias: {
      exacto: redondeoExacto,
      haciaArriba: redondeoHaciaArriba
    }
  };

  it('inicializa con valores por defecto y sin errores ni resultado', () => {
    const { result } = renderHook(() => useDivisor(dependencias));

    expect(result.current.monto).toBe('');
    expect(result.current.personas).toBe('');
    expect(result.current.propina).toBe('');
    expect(result.current.modoRedondeo).toBe('exacto');
    expect(result.current.errores.monto).toBeNull();
    expect(result.current.resultado).toBeNull();
  });

  it('calcula la cuenta exitosamente cuando los datos son válidos', () => {
    const { result } = renderHook(() => useDivisor(dependencias));

    act(() => {
      result.current.setMonto('100.00');
      result.current.setPersonas('4');
      result.current.setPropina('10');
    });

    act(() => {
      result.current.calcular();
    });

    expect(result.current.errores.monto).toBeNull();
    expect(result.current.resultado).not.toBeNull();
    expect(result.current.resultado.totalPagar).toBe(110);
    expect(result.current.resultado.cuotaPorPersona).toBe(27.50);
  });

  it('actualiza errores y no genera resultado cuando los datos son inválidos', () => {
    const { result } = renderHook(() => useDivisor(dependencias));

    act(() => {
      result.current.setMonto('abc');
      result.current.setPersonas('0');
      result.current.setPropina('');
    });

    act(() => {
      result.current.calcular();
    });

    expect(result.current.errores.monto).toBe('Monto inválido');
    expect(result.current.errores.personas).toBe('Debe haber al menos una persona');
    expect(result.current.errores.propina).toBe('La propina es requerida');
    expect(result.current.resultado).toBeNull();
  });

  it('calcula en modo haciaArriba correctamente', () => {
    const { result } = renderHook(() => useDivisor(dependencias));

    act(() => {
      result.current.setMonto('10.00');
      result.current.setPersonas('3');
      result.current.setPropina('0');
      result.current.setModoRedondeo('haciaArriba');
    });

    act(() => {
      result.current.calcular();
    });

    expect(result.current.resultado.cuotaPorPersona).toBe(4);
  });
});
