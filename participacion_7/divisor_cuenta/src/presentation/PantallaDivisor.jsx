/**
 * @file PantallaDivisor.jsx
 * @description Componente visual de la pantalla única para dividir la cuenta del restaurante.
 * Capa: Presentation.
 */

import React from 'react';
import { useDivisor } from './useDivisor.js';
import { formatearMoneda } from './formateadorMoneda.js';

/**
 * Pantalla principal de la aplicación Divisor de Cuenta.
 * 
 * ¿Qué hace?
 * Renderiza el formulario interactivo para la captura de monto, personas, propina
 * y modo de redondeo, desplegando los mensajes de validación y el resultado calculado.
 * 
 * ¿Por qué existe?
 * Es la vista responsable de la interfaz de usuario en React. Consume el hook `useDivisor`,
 * manteniendo la capa visual totalmente desacoplada de los cálculos y las entidades del dominio.
 * 
 * @param {Object} props - Propiedades inyectadas desde el punto de composición.
 * @param {function} props.calcularDivision - Caso de uso de cálculo inyectado.
 * @param {Object} [props.validarEntrada] - Módulo de validación inyectado.
 * @param {Object} props.estrategias - Estrategias de redondeo disponibles.
 * 
 * @returns {JSX.Element}
 */
export function PantallaDivisor({ calcularDivision, validarEntrada, estrategias }) {
  const {
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
  } = useDivisor({
    calcularDivision,
    validarEntrada,
    estrategias
  });

  return (
    <div style={styles.container}>
      <header style={styles.header}>
        <h1 style={styles.title}>Divisor de Cuenta</h1>
        <p style={styles.subtitle}>Divide equitativamente los consumos y propinas de tu mesa</p>
      </header>

      <main style={styles.card}>
        {/* Campo Monto Total */}
        <div style={styles.inputGroup}>
          <label htmlFor="campo_monto" style={styles.label}>
            Monto total
          </label>
          <input
            id="campo_monto"
            data-testid="campo_monto"
            type="text"
            placeholder="0.00"
            value={monto}
            onChange={(e) => setMonto(e.target.value)}
            style={{
              ...styles.input,
              borderColor: errores.monto ? '#e53e3e' : '#cbd5e0'
            }}
          />
          {errores.monto && (
            <span data-testid="error_monto" style={styles.errorText}>
              {errores.monto}
            </span>
          )}
        </div>

        {/* Campo Número de Personas */}
        <div style={styles.inputGroup}>
          <label htmlFor="campo_personas" style={styles.label}>
            Número de personas
          </label>
          <input
            id="campo_personas"
            data-testid="campo_personas"
            type="number"
            min="1"
            step="1"
            placeholder="1"
            value={personas}
            onChange={(e) => setPersonas(e.target.value)}
            style={{
              ...styles.input,
              borderColor: errores.personas ? '#e53e3e' : '#cbd5e0'
            }}
          />
          {errores.personas && (
            <span data-testid="error_personas" style={styles.errorText}>
              {errores.personas}
            </span>
          )}
        </div>

        {/* Campo Porcentaje de Propina */}
        <div style={styles.inputGroup}>
          <label htmlFor="campo_propina" style={styles.label}>
            Porcentaje de propina (%)
          </label>
          <input
            id="campo_propina"
            data-testid="campo_propina"
            type="number"
            min="0"
            step="any"
            placeholder="10"
            value={propina}
            onChange={(e) => setPropina(e.target.value)}
            style={{
              ...styles.input,
              borderColor: errores.propina ? '#e53e3e' : '#cbd5e0'
            }}
          />
          {errores.propina && (
            <span data-testid="error_propina" style={styles.errorText}>
              {errores.propina}
            </span>
          )}
        </div>

        {/* Selector de Modo de Redondeo */}
        <div style={styles.inputGroup} data-testid="selector_redondeo">
          <span style={styles.label}>Modo de Redondeo</span>
          <div style={styles.radioGroup}>
            <label style={styles.radioLabel}>
              <input
                type="radio"
                name="modoRedondeo"
                value="exacto"
                data-testid="opcion_redondeo_exacto"
                checked={modoRedondeo === 'exacto'}
                onChange={() => setModoRedondeo('exacto')}
              />
              <span style={styles.radioText}>Exacto</span>
            </label>
            <label style={styles.radioLabel}>
              <input
                type="radio"
                name="modoRedondeo"
                value="haciaArriba"
                data-testid="opcion_redondeo_arriba"
                checked={modoRedondeo === 'haciaArriba'}
                onChange={() => setModoRedondeo('haciaArriba')}
              />
              <span style={styles.radioText}>Hacia arriba al entero más cercano</span>
            </label>
          </div>
        </div>

        {/* Botón Calcular */}
        <button
          type="button"
          data-testid="boton_calcular"
          onClick={calcular}
          style={styles.button}
        >
          Calcular
        </button>

        {/* Área de Resultado */}
        {resultado && (
          <section style={styles.resultBox} aria-label="Resultado del cálculo">
            <h2 style={styles.resultTitle}>Resumen de Pago</h2>
            <div style={styles.resultRow}>
              <span>Total a pagar (con propina):</span>
              <strong data-testid="total_pagar">
                ${formatearMoneda(resultado.totalPagar)}
              </strong>
            </div>
            <div style={styles.resultRowHighlight}>
              <span>Paga cada persona:</span>
              <span data-testid="texto_resultado" style={styles.resultCuota}>
                ${formatearMoneda(resultado.cuotaPorPersona)}
              </span>
            </div>
          </section>
        )}
      </main>
    </div>
  );
}

const styles = {
  container: {
    maxWidth: '540px',
    margin: '40px auto',
    padding: '24px',
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
    color: '#1a202c',
    backgroundColor: '#f7fafc',
    minHeight: '100vh'
  },
  header: {
    textAlign: 'center',
    marginBottom: '28px'
  },
  title: {
    fontSize: '2rem',
    fontWeight: '700',
    color: '#2b6cb0',
    margin: '0 0 8px 0'
  },
  subtitle: {
    fontSize: '0.95rem',
    color: '#718096',
    margin: 0
  },
  card: {
    backgroundColor: '#ffffff',
    borderRadius: '12px',
    padding: '28px',
    boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)'
  },
  inputGroup: {
    display: 'flex',
    flexDirection: 'column',
    marginBottom: '18px'
  },
  label: {
    fontSize: '0.9rem',
    fontWeight: '600',
    color: '#4a5568',
    marginBottom: '6px'
  },
  input: {
    padding: '10px 14px',
    borderRadius: '8px',
    border: '1.5px solid #cbd5e0',
    fontSize: '1rem',
    outline: 'none',
    transition: 'border-color 0.2s',
    boxSizing: 'border-box',
    width: '100%'
  },
  errorText: {
    color: '#e53e3e',
    fontSize: '0.85rem',
    marginTop: '5px',
    fontWeight: '500'
  },
  radioGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
    marginTop: '6px'
  },
  radioLabel: {
    display: 'flex',
    alignItems: 'center',
    cursor: 'pointer',
    fontSize: '0.95rem'
  },
  radioText: {
    marginLeft: '8px',
    color: '#2d3748'
  },
  button: {
    width: '100%',
    padding: '12px',
    backgroundColor: '#3182ce',
    color: '#ffffff',
    fontSize: '1.05rem',
    fontWeight: '600',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
    marginTop: '10px',
    transition: 'background-color 0.2s',
    boxShadow: '0 4px 6px rgba(49, 130, 206, 0.2)'
  },
  resultBox: {
    marginTop: '28px',
    padding: '20px',
    backgroundColor: '#ebf8ff',
    borderRadius: '8px',
    border: '1.5px solid #bee3f8'
  },
  resultTitle: {
    fontSize: '1.1rem',
    fontWeight: '700',
    color: '#2b6cb0',
    margin: '0 0 14px 0',
    textAlign: 'center'
  },
  resultRow: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: '0.95rem',
    marginBottom: '10px',
    color: '#2d3748'
  },
  resultRowHighlight: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingTop: '10px',
    borderTop: '1px solid #bee3f8'
  },
  resultCuota: {
    fontSize: '1.5rem',
    fontWeight: '800',
    color: '#2b6cb0'
  }
};
