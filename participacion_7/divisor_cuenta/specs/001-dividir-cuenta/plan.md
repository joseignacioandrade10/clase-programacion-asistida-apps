# Implementation Plan: División de Cuenta de Restaurante (React + Vite)

**Branch**: `sdd` | **Date**: 2026-10-09 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-dividir-cuenta/spec.md`

---

## Summary

Implementar una aplicación web de pantalla única en **React con Vite y JavaScript** para dividir la cuenta de un restaurante entre varios comensales, aplicando la fórmula $\text{Total} = \text{Monto} + (\text{Monto} \times \frac{\text{Propina}}{100})$ y dividiendo equitativamente con soporte para dos modos de redondeo: exacto y hacia arriba al entero más cercano.

La solución respeta estrictamente la Constitución del proyecto (v2.0.0), organizándose en tres capas limpias (`src/presentation -> src/domain <- src/data`), donde `src/domain/` es JavaScript puro (sin React ni DOM), el estado se gestiona localmente con `useState` dentro de un hook desacoplado que recibe sus dependencias por inyección, y `src/main.jsx` es el único punto de composición donde se instancian las dependencias concretas. La suite de pruebas automatizadas utiliza **Vitest**.

---

## Technical Context

**Language/Version**: JavaScript (ES Modules, ECMAScript 2022+).

**Framework & Build Tool**: React 18+ / 19+ con Vite.

**Primary Dependencies**: `react`, `react-dom` (sin librerías externas de gestión de estado ni paquetes UI de terceros).

**Storage**: N/A (100% en memoria en cliente, sin base de datos ni red).

**Testing**: Vitest (`@testing-library/react`, `jsdom`).

**Target Platform**: Navegadores web modernos (Chrome, Edge, Safari, Firefox).

**Project Type**: Single Page Application (SPA de pantalla única con estado local `useState`).

**Performance Goals**: Cálculo y actualización del DOM en menos de 50 ms tras presionar "Calcular".

**Constraints**:
- 100% offline (sin llamadas a API ni persistencia remota).
- La capa `src/domain/` no importa nada de React ni del DOM.
- Formateo estricto a 2 cifras decimales.
- Manejo de dependencias por inyección en `useDivisor.js` y composición centralizada en `src/main.jsx`.

---

## Constitution Check

*GATE: Evaluado y verificado conforme a la Constitución v2.0.0.*

- [x] **SOLID - SRP**:
  * `calcularDivision.js` solo calcula; no valida ni formatea.
  * `validarEntrada.js` solo valida y genera errores; no calcula.
  * `formateadorMoneda.js` solo formatea a dos decimales.
- [x] **SOLID - OCP**: Agregar una nueva regla de redondeo no obliga a editar los módulos existentes (solo crear un nuevo archivo en `src/data/` con `aplicar(valor)`).
- [x] **SOLID - LSP**: `redondeoExacto` y `redondeoHaciaArriba` satisfacen el contrato `aplicar(valor)` y son sustituibles sin verificar su tipo.
- [x] **SOLID - ISP**: Contrato mínimo `estrategiaRedondeo`: una única función `aplicar(valor)`. Nadie depende de funciones que no usa.
- [x] **SOLID - DIP**: `useDivisor.js` (presentation) recibe sus dependencias de casos de uso y estrategias abstractas; no importa directamente implementaciones concretas de `src/data/`.
- [x] **Arquitectura en Capas**: `src/presentation` / `src/domain` / `src/data`.
- [x] **Regla de Dependencia**: `presentation -> domain <- data`.
- [x] **Independencia de Dominio**: `src/domain/` NO importa React ni nada del DOM (es JavaScript puro).
- [x] **Punto Único de Composición**: `src/main.jsx` es el ÚNICO lugar donde se instancian implementaciones concretas.
- [x] **Seguridad**: Ningún secreto ni API key almacenado en el repositorio.
- [x] **Calidad y Pruebas**: Todos los criterios de aceptación de la spec se convierten en pruebas ejecutables con Vitest.
- [x] **Regla de la Materia**: Toda función generada puede ser explicada por el estudiante (qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce).

---

## Project Structure

### Documentation (`specs/001-dividir-cuenta/`)

```text
specs/001-dividir-cuenta/
├── spec.md              # Requisitos funcionales y escenarios de aceptación (NO modificado)
├── plan.md              # Este plan de arquitectura e implementación
├── research.md          # Decisiones de diseño técnico y justificación (Fase 0)
├── data-model.md        # Modelos, entidades y contratos en JavaScript (Fase 1)
├── quickstart.md        # Guía paso a paso de ejecución y verificación (Fase 1)
├── contracts/           # Contratos de interfaz
│   ├── estrategia_redondeo.md  # Contrato aplicar(valor)
│   ├── use_divisor.md          # Contrato del hook useDivisor
│   └── ui_contract.md          # Contrato visual de PantallaDivisor
└── tasks.md             # Tareas ordenadas para implementación
```

### Source Code Layout (`src/` & `tests/`)

```text
src/
├── domain/
│   ├── cuenta.js                # Entidad inmutable ({ montoTotal, numeroPersonas, porcentajePropina })
│   ├── resultado.js             # Entidad inmutable ({ totalPagar, cuotaPorPersona })
│   ├── estrategiaRedondeo.js    # Contrato conceptual: función aplicar(valor)
│   ├── calcularDivision.js      # Lógica matemática pura de cálculo
│   └── validarEntrada.js        # Validación de campos y normalización de decimales (, y .)
├── data/
│   ├── redondeoExacto.js        # Implementación con aplicar(valor) a 2 decimales estándar
│   └── redondeoHaciaArriba.js   # Implementación con aplicar(valor) usando Math.ceil()
├── presentation/
│   ├── useDivisor.js            # Hook React con useState; RECIBE sus dependencias
│   ├── formateadorMoneda.js     # Formateo numérico a cadena con 2 decimales
│   └── PantallaDivisor.jsx      # Componente visual de la pantalla única
└── main.jsx                     # ÚNICO punto de composición e inyección de dependencias

tests/
├── domain/
│   ├── calcularDivision.test.js # Pruebas unitarias del cálculo matemático
│   └── validarEntrada.test.js   # Pruebas unitarias de validación y errores
├── data/
│   ├── redondeoExacto.test.js   # Pruebas unitarias de redondeo exacto
│   └── redondeoHaciaArriba.test.js # Pruebas unitarias de redondeo hacia arriba
└── presentation/
    ├── formateadorMoneda.test.js# Pruebas unitarias del formateador
    ├── useDivisor.test.js       # Pruebas unitarias del hook de presentación
    └── PantallaDivisor.test.jsx # Pruebas de integración de componentes (escenarios de aceptación)
```

---

## Complexity Tracking

> **Sin violaciones ni complejidad innecesaria.** El diseño cumple estrictamente los principios SOLID y la Constitución v2.0.0, manteniendo el código modular, fácilmente testeable y 100% explicable por el estudiante.
