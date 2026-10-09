# Quickstart & Guía de Validación: División de Cuenta

**Feature**: `specs/001-dividir-cuenta` | **Fecha**: 2026-10-01

Esta guía describe cómo ejecutar y verificar integralmente el divisor de cuentas en base a los criterios de aceptación especificados.

---

## 1. Requisitos Previos

- Flutter SDK 3.x estable instalado.
- Dispositivo móvil, emulador o navegador web disponible (Chrome o Edge).

---

## 2. Comandos de Verificación Automatizada

```bash
# 1. Obtener dependencias
flutter pub get

# 2. Análisis estático (debe reportar 0 issues)
flutter analyze

# 3. Ejecutar suite de pruebas unitarias y de widgets
flutter test
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
# Para ejecutar en el navegador Chrome:
flutter run -d chrome

# Para ejecutar en Edge:
flutter run -d edge
```
