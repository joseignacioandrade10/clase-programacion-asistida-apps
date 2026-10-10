# Tasks: División de Cuenta de Restaurante (React + Vite)

**Feature**: `specs/001-dividir-cuenta` | **Branch**: `sdd` | **Date**: 2026-10-09

**Input Artifacts**:
- `specs/001-dividir-cuenta/spec.md`
- `specs/001-dividir-cuenta/plan.md`
- `specs/001-dividir-cuenta/data-model.md`
- `specs/001-dividir-cuenta/research.md`
- `specs/001-dividir-cuenta/contracts/`
- `.specify/memory/constitution.md`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicialización del proyecto React con Vite y estructura de carpetas en capas.

- [X] T001 Configurar entorno React con Vite y dependencias de prueba (Vitest, `@testing-library/react`, `jsdom`) en `package.json` y `vite.config.js`
- [X] T002 [P] Crear estructura de directorios en capas `src/domain/`, `src/data/`, `src/presentation/`, `tests/domain/`, `tests/data/` y `tests/presentation/`

---

## Phase 2: Foundational (Core Entities & Contracts)

**Purpose**: Entidades base inmutables del dominio, contratos de interfaces y utilitarios compartidos.

**⚠️ CRITICAL**: Ningún desarrollo de historias de usuario puede comenzar hasta que esta fase esté completa.

- [X] T003 [P] Implementar entidad inmutable `Cuenta` en `src/domain/cuenta.js` con validaciones de tipo (`montoTotal` > 0, `numeroPersonas` >= 1 entero, `porcentajePropina` >= 0)
- [X] T004 [P] Implementar entidad inmutable `Resultado` en `src/domain/resultado.js` conteniendo `totalPagar` y `cuotaPorPersona` congelados con `Object.freeze`
- [X] T005 [P] Implementar contrato conceptual y validador de `EstrategiaRedondeo` que exige el método `aplicar(valor)` en `src/domain/estrategiaRedondeo.js`
- [X] T006 [P] Implementar función utilitaria pura `formatearMoneda` para salida a 2 decimales fijos en `src/presentation/formateadorMoneda.js`

**Checkpoint**: Base foundational lista. La implementación de historias de usuario puede comenzar.

---

## Phase 3: User Story 1 - Cálculo Exacto de la Cuenta (Priority: P1) 🎯 MVP

**Goal**: Permitir al comensal ingresar monto, número de personas y porcentaje de propina para obtener el valor exacto a pagar por persona con dos decimales en modo exacto.

**Independent Test**: Ingresar monto `100.00`, `4` personas, `10%` propina en modo exacto -> `27.50` por persona; monto `90.00`, `3` personas, `0%` propina -> `30.00` por persona; monto `10.00`, `3` personas, `0%` propina -> `3.33` por persona.

### Tests para User Story 1

> **NOTA: Escribir estas pruebas primero y verificar que fallen antes de implementar.**

- [X] T007 [P] [US1] Escribir pruebas unitarias para la estrategia `redondeoExacto` en `tests/data/redondeoExacto.test.js`
- [X] T008 [P] [US1] Escribir pruebas unitarias para el caso de uso `calcularDivision` con redondeo exacto en `tests/domain/calcularDivision.test.js`

### Implementación para User Story 1

- [X] T009 [P] [US1] Implementar estrategia concreta `redondeoExacto` con método `aplicar(valor)` redondeando a 2 decimales estándar en `src/data/redondeoExacto.js`
- [X] T010 [US1] Implementar caso de uso `calcularDivision` aplicando la fórmula total y delegando el redondeo a la estrategia en `src/domain/calcularDivision.js`
- [X] T011 [US1] Implementar hook `useDivisor` con `useState` recibiendo dependencias inyectadas para cálculo exacto en `src/presentation/useDivisor.js`
- [X] T012 [US1] Implementar componente `PantallaDivisor` con campos de entrada, botón de cálculo y visualización del resultado usando `data-testid` en `src/presentation/PantallaDivisor.jsx`
- [X] T013 [US1] Configurar composición e inyección de dependencias en `src/main.jsx` instanciando las dependencias concretas y conectándolas a `PantallaDivisor`

**Checkpoint**: User Story 1 completamente funcional y testeable de forma independiente (MVP completado).

---

## Phase 4: User Story 2 - Redondeo al Entero Superior (Priority: P2)

**Goal**: Permitir al usuario seleccionar el modo de redondeo "hacia arriba al entero más cercano" para evitar centavos y facilitar pagos cerrados.

**Independent Test**: Ingresar monto `10.00`, `3` personas, `0%` propina con redondeo hacia arriba -> `4.00` por persona; monto `100.00`, `4` personas, `10%` propina con redondeo hacia arriba -> `28.00` por persona.

### Tests para User Story 2

- [X] T014 [P] [US2] Escribir pruebas unitarias para la estrategia `redondeoHaciaArriba` en `tests/data/redondeoHaciaArriba.test.js`

### Implementación para User Story 2

- [X] T015 [P] [US2] Implementar estrategia concreta `redondeoHaciaArriba` con método `aplicar(valor)` utilizando `Math.ceil()` en `src/data/redondeoHaciaArriba.js`
- [X] T016 [US2] Incorporar selector de modo de redondeo (`exacto` / `haciaArriba`) en `src/presentation/PantallaDivisor.jsx` y soportar el cambio de modo en `src/presentation/useDivisor.js`
- [X] T017 [US2] Proveer `redondeoHaciaArriba` en la inyección de dependencias de `src/main.jsx`

**Checkpoint**: User Stories 1 y 2 operan de forma conjunta e independiente, satisfaciendo el principio OCP.

---

## Phase 5: User Story 3 - Validación de Datos de Entrada y Manejo de Errores (Priority: P3)

**Goal**: Validar las entradas de usuario (monto > 0, personas >= 1, propina requerida, aceptación de punto y coma decimal), mostrando errores claros y bloqueando el cálculo ante datos inválidos.

**Independent Test**: Ingresar monto `50.00` y `0` personas -> error `"Debe haber al menos una persona"`; monto `"abc"` -> error `"Monto inválido"`; monto `"100,00"` con coma -> cálculo válido `27.50`; propina vacía -> error `"La propina es requerida"`.

### Tests para User Story 3

- [X] T018 [P] [US3] Escribir pruebas unitarias para `validarEntrada` cubriendo errores de monto, personas, propina y normalización de comas en `tests/domain/validarEntrada.test.js`

### Implementación para User Story 3

- [X] T019 [US3] Implementar caso de uso `validarEntrada` (`validarMonto`, `validarPersonas`, `validarPropina`, `validarEntradas`) con normalización de `,` a `.` en `src/domain/validarEntrada.js`
- [X] T020 [US3] Integrar `validarEntrada` en `src/presentation/useDivisor.js` para registrar errores y anular el resultado cuando los datos sean inválidos
- [X] T021 [US3] Conectar mensajes de error visuales (`error_monto`, `error_personas`, `error_propina`) en `src/presentation/PantallaDivisor.jsx`

**Checkpoint**: Todas las historias de usuario (P1, P2, P3) están implementadas, validadas y blindadas contra entradas erróneas.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verificación de calidad, pruebas de componentes, integración completa y validación final de criterios de aceptación.

- [X] T022 [P] Escribir pruebas unitarias para `formatearMoneda` en `tests/presentation/formateadorMoneda.test.js`
- [X] T023 [P] Escribir pruebas unitarias del hook `useDivisor` con `@testing-library/react` en `tests/presentation/useDivisor.test.js`
- [X] T024 Escribir pruebas de integración de componentes para `PantallaDivisor` en `tests/presentation/PantallaDivisor.test.jsx` cubriendo los 6 escenarios de aceptación
- [X] T025 Ejecutar suite completa con Vitest (`npx vitest run`) verificando el 100% de pruebas aprobadas
- [X] T026 Validar escenarios de `specs/001-dividir-cuenta/quickstart.md` en servidor local con `npm run dev`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias previas.
- **Foundational (Phase 2)**: Depende de Phase 1. Bloquea todas las historias de usuario.
- **User Story 1 (Phase 3)**: Depende de Phase 2. Constituye el MVP.
- **User Story 2 (Phase 4)**: Depende de Phase 3 (extiende la UI y agrega una nueva estrategia sin alterar el dominio).
- **User Story 3 (Phase 5)**: Depende de Phase 3 y Phase 4 (incorpora validaciones previas al cálculo).
- **Polish (Phase 6)**: Depende de que todas las historias de usuario estén implementadas.

### User Story Dependencies

- **User Story 1 (P1)**: Puede iniciar inmediatamente tras la fase Foundational.
- **User Story 2 (P2)**: Extiende la UI de US1 agregando la opción de redondeo hacia arriba mediante la estrategia desacoplada.
- **User Story 3 (P3)**: Agrega la capa de validación previa al cálculo de US1/US2.

### Parallel Opportunities

- `T002`, `T003`, `T004`, `T005`, `T006` pueden desarrollarse en paralelo (archivos independientes).
- `T007` y `T008` pueden escribirse en paralelo antes de la implementación de US1.
- `T009` puede implementarse en paralelo a `T010`.
- `T014` y `T015` pueden ejecutarse en paralelo a ajustes de UI.
- `T018` puede escribirse en paralelo a la lógica de presentación.
- `T022` y `T023` pueden ejecutarse en paralelo durante la fase de Polish.

---

## Parallel Example: User Story 1

```bash
# Escribir pruebas en paralelo:
Task: "Escribir pruebas unitarias para redondeoExacto en tests/data/redondeoExacto.test.js"
Task: "Escribir pruebas unitarias para calcularDivision en tests/domain/calcularDivision.test.js"

# Implementar componentes base en paralelo:
Task: "Implementar estrategia redondeoExacto en src/data/redondeoExacto.js"
Task: "Implementar caso de uso calcularDivision en src/domain/calcularDivision.js"
```

---

## Implementation Strategy

### MVP First (User Story 1)
1. Completar Setup (Fase 1) y Foundational (Fase 2).
2. Implementar User Story 1 (Fase 3: cálculo exacto de la cuenta con propina).
3. **Validar MVP**: Probar que la aplicación ya divide cuentas exactas de forma funcional.

### Entrega Incremental
1. Añadir User Story 2 (Fase 4): Soporte de redondeo hacia arriba sin alterar `calcularDivision` (OCP).
2. Añadir User Story 3 (Fase 5): Validaciones exhaustivas de entrada con normalización de comas y mensajes de error.
3. Ejecutar Polish (Fase 6): Pruebas de integración visuales y verificación de quickstart.
