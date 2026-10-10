/**
 * @file main.jsx
 * @description Punto único de composición e inyección de dependencias de la aplicación.
 * Conforme a la Constitución (v2.0.0), este es el ÚNICO lugar donde se instancian
 * implementaciones concretas de la capa data y se inyectan hacia la presentación.
 */

import React from 'react';
import ReactDOM from 'react-dom/client';
import { PantallaDivisor } from './presentation/PantallaDivisor.jsx';
import { calcularDivision } from './domain/calcularDivision.js';
import * as validarEntrada from './domain/validarEntrada.js';
import { redondeoExacto } from './data/redondeoExacto.js';
import { redondeoHaciaArriba } from './data/redondeoHaciaArriba.js';

// Composición e instanciación de dependencias
const estrategias = {
  exacto: redondeoExacto,
  haciaArriba: redondeoHaciaArriba
};

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <PantallaDivisor
      calcularDivision={calcularDivision}
      validarEntrada={validarEntrada}
      estrategias={estrategias}
    />
  </React.StrictMode>
);
