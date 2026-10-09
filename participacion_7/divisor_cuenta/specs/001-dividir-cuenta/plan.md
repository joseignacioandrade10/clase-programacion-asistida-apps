# Implementation Plan: División de Cuenta de Restaurante

**Branch**: `001-dividir-cuenta` | **Date**: 2026-10-01 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-dividir-cuenta/spec.md`

---

## Summary

Implementar una aplicación en Flutter de pantalla única para dividir la cuenta de un restaurante entre varios comensales, aplicando la fórmula $\text{Total} = \text{Monto} + (\text{Monto} \times \frac{\text{Propina}}{100})$ y dividiendo equitativamente con soporte de dos modos de redondeo (Exacto y Hacia arriba al entero más cercano).

El diseño sigue una arquitectura limpia en tres capas estrictas (`presentation -> domain <- data`), donde `domain` es Dart puro sin importaciones de Flutter, las estrategias de redondeo son abiertas a extensión pero cerradas a modificación (OCP/LSP), y `main.dart` es el único punto de composición e inyección de dependencias.

---

## Technical Context

**Language/Version**: Dart 3.x / Flutter SDK Estable.

**Primary Dependencies**: Ninguna dependencia de terceros (100% SDK nativo de Dart y Flutter).

**Storage**: N/A (aplicación en memoria, sin base de datos ni persistencia requerida).

**Testing**: `flutter_test` (pruebas unitarias para `domain` y `data`, y pruebas de widgets para `presentation`).

**Target Platform**: Multiplataforma (Web Chrome/Edge, Android, iOS, Windows).

**Project Type**: Mobile / Web Application (pantalla única con `setState`).

**Performance Goals**: Cálculo y renderizado en menos de 50 milisegundos tras pulsar "Calcular".

**Constraints**:
- 100% offline (sin llamadas de red ni secretos).
- La capa `domain` no debe importar nada de `package:flutter`.
- Formateo estricto a 2 cifras decimales.

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **SOLID - SRP**: `CalcularDivision` solo calcula. `ValidarEntrada` solo valida. `FormateadorMoneda` solo formatea.
- [x] **SOLID - OCP**: `EstrategiaRedondeo` es una interfaz abstracta que permite nuevas reglas de redondeo sin modificar código existente.
- [x] **SOLID - LSP**: `RedondeoExacto` y `RedondeoHaciaArriba` implementan `EstrategiaRedondeo` y son mutuamente sustituibles.
- [x] **SOLID - ISP**: `EstrategiaRedondeo` contiene un único método (`double redondear(double valor)`).
- [x] **SOLID - DIP**: `DivisorController` depende de la interfaz `EstrategiaRedondeo` y casos de uso de `domain`, nunca de clases concretas de `data`.
- [x] **Arquitectura en Capas**: Estructura `presentation -> domain <- data`.
- [x] **Independencia de Dominio**: `lib/domain/` es Dart puro y no importa `package:flutter`.
- [x] **Punto Único de Composición**: `main.dart` es el único lugar donde se instancian las implementaciones concretas.
- [x] **Seguridad**: No existen API keys ni secretos almacenados.
- [x] **Calidad y Pruebas**: Todos los 6 criterios de aceptación de la spec se traducen en pruebas ejecutables.
- [x] **Regla de la Materia**: Cada función y clase tiene responsabilidades explícitas, parámetros tipados y comportamiento comprensible para el estudiante.

---

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── spec.md              # Requisitos funcionales y escenarios de aceptación
├── plan.md              # Este plan de implementación arquitectónico
├── research.md          # Decisiones de diseño y evaluación de alternativas
├── data-model.md        # Definición de entidades, casos de uso y contratos
├── quickstart.md        # Guía de verificación paso a paso
├── contracts/           # Interfaces y contratos de presentación y dominio
│   ├── estrategia_redondeo.md
│   ├── divisor_controller.md
│   └── ui_contract.md
├── checklists/
│   └── requirements.md  # Checklist de calidad de la especificación
└── tasks.md             # Tareas ordenadas para implementación (/speckit-tasks)
```

### Source Code Layout

```text
lib/
├── domain/
│   ├── cuenta.dart                  # Entidad inmutable de la cuenta
│   ├── resultado.dart               # Entidad inmutable del resultado calculado
│   ├── estrategia_redondeo.dart     # Interfaz abstracta con método redondear()
│   ├── calcular_division.dart       # Lógica matemática de división y propina
│   └── validar_entrada.dart         # Validación de campos y generación de errores
├── data/
│   ├── redondeo_exacto.dart         # Implementación de redondeo estándar (2 dec.)
│   └── redondeo_hacia_arriba.dart   # Implementación de redondeo ceil()
├── presentation/
│   ├── divisor_controller.dart      # Controlador inyectado que coordina cálculo
│   ├── formateador_moneda.dart      # Formateo visual con dos decimales
│   └── pantalla_divisor.dart        # StatefulWidget de la pantalla única
└── main.dart                        # Composición e inyección de dependencias

test/
├── domain/
│   ├── calcular_division_test.dart  # Pruebas unitarias de cálculo matemático
│   └── validar_entrada_test.dart    # Pruebas unitarias de validación de campos
├── data/
│   ├── redondeo_exacto_test.dart    # Pruebas unitarias de redondeo exacto
│   └── redondeo_hacia_arriba_test.dart # Pruebas unitarias de redondeo hacia arriba
└── presentation/
    ├── formateador_moneda_test.dart # Pruebas unitarias de formateo
    └── pantalla_divisor_test.dart   # Pruebas de widgets (los 6 escenarios de aceptación)
```

**Structure Decision**: Se adopta la estructura en capas solicitada por la constitución del proyecto y el usuario, garantizando total separación entre la lógica pura (Dart) y los componentes visuales (Flutter).

---

## Complexity Tracking

> Ninguna violación a la constitución. El diseño es minimalista, desacoplado y directo.
