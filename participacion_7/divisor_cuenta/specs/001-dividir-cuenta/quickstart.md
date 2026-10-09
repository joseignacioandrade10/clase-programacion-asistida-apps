# Quickstart & Guía de Validación: División de Cuenta (React + Vite)

**Feature**: `specs/001-dividir-cuenta` | **Fecha**: 2026-10-09

Esta guía describe cómo ejecutar y verificar integralmente el divisor de cuentas en base a los criterios de aceptación especificados, utilizando **React, Vite y Vitest**.

---

## 1. Requisitos Previos

- Node.js (versión 18+ o 20+ recomendada) y npm instalados.
- Navegador web moderno (Chrome, Edge, Firefox).

---

## 2. Comandos de Verificación Automatizada

```bash
# 1. Instalar dependencias del proyecto
npm install

# 2. Ejecutar la suite de pruebas unitarias y de componentes con Vitest
npm run test
# O para ejecutar una sola vez sin modo watch:
npx vitest run
```

---

## 3. Matriz de Validación de Escenarios de Aceptación

| # | Monto | Personas | Propina | Redondeo | Resultado Esperado | Mensaje de Error |
|---|---|---|---|---|---|---|
| 1 | `100.00` | `4` | `10%` | Exacto | `27.50` por persona | Ninguno |
| 2 | `90.00` | `3` | `0%` | Exacto | `30.00` por persona | Ninguno |
| 3 | `50.00` | `0` | - | - | Sin resultado | `"Debe haber al menos una persona"` |
| 4 | `"abc"` | `2` | `10%` | - | Sin resultado | `"Monto inválido"` |
| 5 | `10.00` | `3` | `0%` | Exacto | `3.33` por persona | Ninguno |
| 6 | `10.00` | `3` | `0%` | Hacia arriba | `4.00` por persona | Ninguno |

---

## 4. Ejecución en Vivo

```bash
# Iniciar el servidor local de desarrollo con Vite:
npm run dev
```

Abre la URL indicada (usualmente `http://localhost:5173/`) en tu navegador web para interactuar con la aplicación.
