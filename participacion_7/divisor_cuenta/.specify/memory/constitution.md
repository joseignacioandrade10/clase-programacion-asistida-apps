<!--
Sync Impact Report:
- Version change: Unversioned (Template) → 1.0.0
- List of principles defined:
  - I. Calidad de Código (SOLID)
  - II. Arquitectura y Reglas de Dependencia
  - III. Seguridad
  - IV. Calidad y Pruebas
  - V. Regla de la Materia (Explicabilidad)
- Added sections: Core Principles, Governance
- Removed sections: Placeholder sections 2 and 3 (consolidated into core principles as requested)
- Follow-up TODOs: None
-->

# Divisor de Cuenta Constitution

## Core Principles

### I. Calidad de Código (SOLID)
El código debe respetar estrictamente los principios SOLID:
- **SRP (Single Responsibility Principle):** Una clase debe tener una única razón de cambio. La lógica de cálculo no valida entradas ni formatea salidas.
- **OCP (Open/Closed Principle):** Agregar una nueva regla de redondeo no debe obligar a editar las clases ya existentes.
- **LSP (Liskov Substitution Principle):** Cualquier implementación de una interfaz puede sustituir a otra sin que quien la usa deba consultar de qué tipo concreto se trata.
- **ISP (Interface Segregation Principle):** Interfaces pequeñas y específicas; ningún cliente debe depender de métodos que no utiliza.
- **DIP (Dependency Inversion Principle):** La capa `presentation` depende de abstracciones de `domain`, nunca de clases concretas de `data`.

### II. Arquitectura y Reglas de Dependencia
- La estructura del proyecto se organiza en tres capas estrictas: `presentation`, `domain` y `data`.
- Regla de dependencias unidireccional: `presentation -> domain <- data`.
- La capa `lib/domain/` es código Dart puro y **NO** debe importar nada proveniente de `package:flutter`.
- `main.dart` es el **ÚNICO** lugar del sistema donde se instancian implementaciones concretas.

### III. Seguridad
- Queda estrictamente prohibido almacenar secretos, credenciales o API keys en el repositorio.

### IV. Calidad y Pruebas
- Toda funcionalidad crítica debe contar con pruebas automatizadas.
- Los criterios de aceptación de cada especificación (spec) deben convertirse en pruebas ejecutables y verificables.

### V. Regla de la Materia (Explicabilidad y Comprensión)
- Toda función generada por el agente debe poder ser explicada cabalmente por el estudiante: qué hace, por qué existe, qué parámetros recibe, qué valor devuelve y qué errores o excepciones produce.

## Governance

- **Supremacía:** Esta constitución rige todas las decisiones de diseño, arquitectura e implementación del proyecto.
- **Cumplimiento:** Toda modificación y revisión de código debe validar el cumplimiento estricto de estos principios.
- **Procedimiento de Enmienda:** Las modificaciones o ampliaciones de principios requieren justificación documentada y consenso explícito.
- **Política de Versionado:** Se aplica versionado semántico (MAJOR para cambios incompatibles de principios, MINOR para adición o expansión de principios, PATCH para aclaraciones o correcciones de redacción).

**Version**: 1.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-01
