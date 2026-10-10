import React from 'react';
import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { PantallaDivisor } from '../../src/presentation/PantallaDivisor.jsx';
import { calcularDivision } from '../../src/domain/calcularDivision.js';
import * as validarEntrada from '../../src/domain/validarEntrada.js';
import { redondeoExacto } from '../../src/data/redondeoExacto.js';
import { redondeoHaciaArriba } from '../../src/data/redondeoHaciaArriba.js';

describe('Pruebas de Componente: PantallaDivisor (Escenarios de Aceptación)', () => {
  const props = {
    calcularDivision,
    validarEntrada,
    estrategias: {
      exacto: redondeoExacto,
      haciaArriba: redondeoHaciaArriba
    }
  };

  const llenarFormulario = ({ monto, personas, propina, modo = 'exacto' }) => {
    const inputMonto = screen.getByTestId('campo_monto');
    const inputPersonas = screen.getByTestId('campo_personas');
    const inputPropina = screen.getByTestId('campo_propina');
    const botonCalcular = screen.getByTestId('boton_calcular');

    fireEvent.change(inputMonto, { target: { value: monto } });
    fireEvent.change(inputPersonas, { target: { value: personas } });
    fireEvent.change(inputPropina, { target: { value: propina } });

    if (modo === 'haciaArriba') {
      const radioArriba = screen.getByTestId('opcion_redondeo_arriba');
      fireEvent.click(radioArriba);
    } else {
      const radioExacto = screen.getByTestId('opcion_redondeo_exacto');
      fireEvent.click(radioExacto);
    }

    fireEvent.click(botonCalcular);
  };

  it('Escenario 1 (US1): Monto 100.00, 4 personas, 10% propina, exacto -> 27.50', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '100.00',
      personas: '4',
      propina: '10',
      modo: 'exacto'
    });

    const resultado = screen.getByTestId('texto_resultado');
    expect(resultado).toBeInTheDocument();
    expect(resultado).toHaveTextContent('$27.50');
  });

  it('Escenario 2 (US1): Monto 90.00, 3 personas, 0% propina, exacto -> 30.00', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '90.00',
      personas: '3',
      propina: '0',
      modo: 'exacto'
    });

    const resultado = screen.getByTestId('texto_resultado');
    expect(resultado).toBeInTheDocument();
    expect(resultado).toHaveTextContent('$30.00');
  });

  it('Escenario 3 (US1): Monto 10.00, 3 personas, 0% propina, exacto -> 3.33', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '10.00',
      personas: '3',
      propina: '0',
      modo: 'exacto'
    });

    const resultado = screen.getByTestId('texto_resultado');
    expect(resultado).toBeInTheDocument();
    expect(resultado).toHaveTextContent('$3.33');
  });

  it('Escenario 4 (US1): Monto con coma 100,00, 4 personas, 10% propina, exacto -> 27.50', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '100,00',
      personas: '4',
      propina: '10',
      modo: 'exacto'
    });

    const resultado = screen.getByTestId('texto_resultado');
    expect(resultado).toBeInTheDocument();
    expect(resultado).toHaveTextContent('$27.50');
  });

  it('Escenario 5 (US2): Monto 10.00, 3 personas, 0% propina, hacia arriba -> 4.00', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '10.00',
      personas: '3',
      propina: '0',
      modo: 'haciaArriba'
    });

    const resultado = screen.getByTestId('texto_resultado');
    expect(resultado).toBeInTheDocument();
    expect(resultado).toHaveTextContent('$4.00');
  });

  it('Escenario 6 (US2): Monto 100.00, 4 personas, 10% propina, hacia arriba -> 28.00', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '100.00',
      personas: '4',
      propina: '10',
      modo: 'haciaArriba'
    });

    const resultado = screen.getByTestId('texto_resultado');
    expect(resultado).toBeInTheDocument();
    expect(resultado).toHaveTextContent('$28.00');
  });

  it('Escenario 7 (US3): Monto 50.00 y 0 personas -> "Debe haber al menos una persona" y sin resultado', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '50.00',
      personas: '0',
      propina: '10'
    });

    expect(screen.getByTestId('error_personas')).toHaveTextContent('Debe haber al menos una persona');
    expect(screen.queryByTestId('texto_resultado')).not.toBeInTheDocument();
  });

  it('Escenario 8 (US3): Monto "abc" -> "Monto inválido" y sin resultado', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: 'abc',
      personas: '2',
      propina: '10'
    });

    expect(screen.getByTestId('error_monto')).toHaveTextContent('Monto inválido');
    expect(screen.queryByTestId('texto_resultado')).not.toBeInTheDocument();
  });

  it('Escenario 9 (US3): Propina vacía -> "La propina es requerida" y sin resultado', () => {
    render(<PantallaDivisor {...props} />);

    llenarFormulario({
      monto: '50.00',
      personas: '2',
      propina: ''
    });

    expect(screen.getByTestId('error_propina')).toHaveTextContent('La propina es requerida');
    expect(screen.queryByTestId('texto_resultado')).not.toBeInTheDocument();
  });
});
