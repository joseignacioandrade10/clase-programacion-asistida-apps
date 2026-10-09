# Tasks: División de Cuenta de Restaurante

**Feature**: `specs/001-dividir-cuenta` | **Branch**: `001-dividir-cuenta` | **Date**: 2026-10-01

**Input Artifacts**:
- `specs/001-dividir-cuenta/spec.md`
- `specs/001-dividir-cuenta/plan.md`
- `specs/001-dividir-cuenta/data-model.md`
- `specs/001-dividir-cuenta/research.md`
- `specs/001-dividir-cuenta/contracts/`
- `.specify/memory/constitution.md`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicialización del proyecto y estructura en capas según la arquitectura definida.

- [X] T001 Crear estructura de directorios en capas `lib/domain/`, `lib/data/`, `lib/presentation/`, `test/domain/`, `test/data/` y `test/presentation/`
- [X] T002 [P] Verificar que `pubspec.yaml` no tenga dependencias externas adicionales y ejecutar `flutter pub get`

---

## Phase 2: Foundational (Core Entities & Interfaces)

**Purpose**: Entidades base del dominio e interfaces abstractas que bloquean las historias de usuario.

- [X] T003 [P] Crear entidad inmutable `Cuenta` en `lib/domain/cuenta.dart` con `montoTotal` (double > 0), `numeroPersonas` (int >= 1) y `porcentajePropina` (double >= 0)
- [X] T004 [P] Crear entidad inmutable `Resultado` en `lib/domain/resultado.dart` con `totalPagar` y `cuotaPorPersona`
- [X] T005 [P] Crear interfaz abstracta `EstrategiaRedondeo` en `lib/domain/estrategia_redondeo.dart` con método único `double redondear(double valor)`
- [X] T006 [P] Crear clase utilitaria `FormateadorMoneda` en `lib/presentation/formateador_moneda.dart` con método estático `formatear(double valor)` que formatea a 2 decimales

**Checkpoint**: Fundamentos listos. El desarrollo de las historias de usuario puede comenzar.

---

## Phase 3: User Story 1 - Cálculo Exacto de la Cuenta (Priority: P1) 🎯 MVP

**Goal**: Permitir al usuario ingresar monto, comensales y propina para obtener el valor exacto a pagar por persona con dos decimales.

**Independent Test**: Probar con 100.00, 4 personas, 10% propina -> 27.50; 90.00, 3 personas, 0% -> 30.00; 10.00, 3 personas, 0% -> 3.33.

### Tests para User Story 1

- [X] T007 [P] [US1] Escribir pruebas unitarias para `RedondeoExacto` en `test/data/redondeo_exacto_test.dart`
- [X] T008 [P] [US1] Escribir pruebas unitarias para `CalcularDivision` con `RedondeoExacto` en `test/domain/calcular_division_test.dart`

### Implementación para User Story 1

- [X] T009 [US1] Implementar clase `RedondeoExacto` que implementa `EstrategiaRedondeo` en `lib/data/redondeo_exacto.dart`
- [X] T010 [US1] Implementar caso de uso `CalcularDivision` en `lib/domain/calcular_division.dart`
- [X] T011 [US1] Implementar `DivisorController` con soporte de cálculo exacto en `lib/presentation/divisor_controller.dart`
- [X] T012 [US1] Implementar interfaz base de `PantallaDivisor` en `lib/presentation/pantalla_divisor.dart` para ingresar datos y ver resultado exacto
- [X] T013 [US1] Configurar composición e inyección de dependencias en `lib/main.dart` conectando controlador y pantalla

**Checkpoint**: User Story 1 completamente funcional e independientemente verificable (MVP alcanzado).

---

## Phase 4: User Story 2 - Redondeo al Entero Superior (Priority: P2)

**Goal**: Permitir seleccionar el modo de redondeo hacia arriba al entero más cercano para evitar centavos.

**Independent Test**: Probar con 10.00, 3 personas, 0% modo hacia arriba -> 4.00; 100.00, 4 personas, 10% modo hacia arriba -> 28.00.

### Tests para User Story 2

- [X] T014 [P] [US2] Escribir pruebas unitarias para `RedondeoHaciaArriba` en `test/data/redondeo_hacia_arriba_test.dart`

### Implementación para User Story 2

- [X] T015 [US2] Implementar clase `RedondeoHaciaArriba` que implementa `EstrategiaRedondeo` en `lib/data/redondeo_hacia_arriba.dart`
- [X] T016 [US2] Agregar selector de `ModoRedondeo` (Exacto / Hacia Arriba) en `lib/presentation/pantalla_divisor.dart` e integrarlo en `lib/presentation/divisor_controller.dart`

**Checkpoint**: User Stories 1 y 2 funcionan e interactúan de manera independiente y verificable.

---

## Phase 5: User Story 3 - Validación de Datos de Entrada y Manejo de Errores (Priority: P3)

**Goal**: Validar las entradas de usuario (monto > 0, personas >= 1, propina requerida, punto y coma decimal) mostrando errores claros y ocultando resultados inválidos.

**Independent Test**: Probar con 50.00 y 0 personas -> "Debe haber al menos una persona"; monto "abc" -> "Monto inválido"; monto con coma 100,00 -> cálculo válido sin error.

### Tests para User Story 3

- [X] T017 [P] [US3] Escribir pruebas unitarias para `ValidarEntrada` en `test/domain/validar_entrada_test.dart`

### Implementación para User Story 3

- [X] T018 [US3] Implementar caso de uso `ValidarEntrada` en `lib/domain/validar_entrada.dart` con soporte de punto/coma y validaciones de negocio
- [X] T019 [US3] Integrar `ValidarEntrada` dentro de `DivisorController` en `lib/presentation/divisor_controller.dart` para retornar mensajes de error en `DivisorEstado`
- [X] T020 [US3] Conectar mensajes de error en `PantallaDivisor` en `lib/presentation/pantalla_divisor.dart` suprimiendo el área de resultado si hay errores activos

**Checkpoint**: Todas las historias de usuario (P1, P2, P3) están implementadas y validadas contra sus criterios de aceptación.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verificación de calidad, pruebas de integración y cumplimiento de estándares constitucionales.

- [X] T021 [P] Crear pruebas unitarias para `FormateadorMoneda` en `test/presentation/formateador_moneda_test.dart`
- [X] T022 [P] Crear pruebas de widgets completas en `test/presentation/pantalla_divisor_test.dart` verificando los 6 escenarios de aceptación
- [X] T023 Ejecutar análisis estático con `flutter analyze` asegurando cero advertencias y cero errores
- [X] T024 Ejecutar toda la suite con `flutter test` verificando que pasen el 100% de las pruebas unitarias y de widgets
- [X] T025 Actualizar documentación y enlaces en `README.md`

---

## Dependencies & Execution Order

### Phase Dependencies
1. **Setup (Phase 1)**: Sin dependencias previas.
2. **Foundational (Phase 2)**: Depende de Phase 1. Bloquea todas las historias de usuario.
3. **User Story 1 (Phase 3)**: Depende de Phase 2. MVP central.
4. **User Story 2 (Phase 4)**: Depende de Phase 3 (utiliza la interfaz `EstrategiaRedondeo` y la pantalla base).
5. **User Story 3 (Phase 5)**: Depende de Phase 3 y Phase 4 (incorpora validaciones antes del cálculo).
6. **Polish (Phase 6)**: Depende de la finalización de las historias de usuario.

### Parallel Opportunities
- T002, T003, T004, T005, T006 pueden ejecutarse en paralelo (archivos independientes).
- T007 y T008 pueden ejecutarse en paralelo antes de la implementación de US1.
- T014 puede escribirse en paralelo a las tareas de UI de US1.
- T017 puede ejecutarse en paralelo.
- T021 y T022 pueden ejecutarse en paralelo.

---

## Implementation Strategy

### MVP First (User Story 1)
1. Completar Phase 1 y Phase 2 (Entidades e Interfaces).
2. Implementar Phase 3 (Cálculo exacto).
3. **Verificar MVP**: La aplicación ya calcula divisiones de cuenta exactas con propina.

### Entrega Incremental
1. Añadir Phase 4: Capacidad de redondeo hacia arriba sin alterar las clases de dominio existentes (OCP).
2. Añadir Phase 5: Validaciones robustas de entrada y manejo de errores con mensajes específicos.
3. Finalizar con Phase 6: Pruebas automatizadas de extremo a extremo y análisis estático.
