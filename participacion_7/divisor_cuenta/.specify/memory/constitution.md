<!--
Sync Impact Report:
- Version change: 1.0.0 → 2.0.0
- List of modified principles:
  - I. Calidad de Código (adaptado a funciones y módulos JavaScript)
  - II. Arquitectura (adaptado de Flutter/Dart a React/Vite/JS puro: src/presentation, src/domain, src/data, src/main.jsx)
  - III. Seguridad (mantenido)
  - IV. Calidad y Pruebas (adaptado a pruebas con Vitest)
  - V. Regla de la Materia (mantenido)
- Added sections: None
- Removed sections: None
- Follow-up TODOs: None
-->

# Divisor de Cuenta Constitution

## Core Principles

### I. Calidad de Código
El código respeta SOLID:
- **SRP (Single Responsibility Principle):** Una función o módulo, una razón de cambio. El cálculo no valida ni formatea.
- **OCP (Open/Closed Principle):** Agregar una nueva regla de redondeo no obliga a editar los módulos que ya existen.
- **LSP (Liskov Substitution Principle):** Cualquier implementación de la estrategia de redondeo puede sustituir a otra sin que quien la usa pregunte de qué tipo es.
- **ISP (Interface Segregation Principle):** Interfaces pequeñas (en JS/JS modules, contratos claros); nadie depende de funciones que no usa.
- **DIP (Dependency Inversion Principle):** `presentation` depende de abstracciones de `domain`, nunca de implementaciones concretas de `data`.

### II. Arquitectura
- **Capas:** `src/presentation` / `src/domain` / `src/data`.
- **Regla de dependencia:** `presentation -> domain <- data`.
- `src/domain/` **NO** importa react ni nada del DOM: es JavaScript puro.
- `src/main.jsx` es el **ÚNICO** lugar donde se instancian implementaciones concretas.

### III. Seguridad
- Nunca guardar secretos ni API keys en el repositorio.

### IV. Calidad y Pruebas
- Toda funcionalidad crítica tiene pruebas.
- Los criterios de aceptación de la spec se convierten en pruebas ejecutables (Vitest).

### V. Regla de la Materia
- Toda función generada por el agente debe poder explicarla el estudiante: qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.

## Governance

- **Supremacía:** Esta constitución rige todas las decisiones de diseño, arquitectura e implementación del proyecto.
- **Cumplimiento:** Toda modificación y revisión de código debe validar el cumplimiento estricto de estos principios.
- **Procedimiento de Enmienda:** Las modificaciones o ampliaciones de principios requieren justificación documentada y consenso expĺícito.
- **Política de Versionado:** Se aplica versionado semántico (MAJOR para cambios incompatibles de principios o adaptaciones arquitectónicas, MINOR para adición o expansión de principios, PATCH para aclaraciones o correcciones de redacción).

**Version**: 2.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-09
