# Feature Specification: División de Cuenta de Restaurante

**Feature Directory**: `specs/001-dividir-cuenta`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar 'Calcular' ve cuánto paga cada persona con dos decimales. Hay dos modos de redondeo que el usuario elige: exacto, o hacia arriba al entero más cercano. La app funciona sin conexión: no hay red ni base de datos."

## Clarifications

### Session 2026-10-01

- Q: ¿Cómo debe comportarse el campo de propina si el usuario lo deja en blanco al presionar "Calcular"? → A: Mostrar un mensaje de error indicando que la propina es requerida y no mostrar resultado.
- Q: ¿Debe la aplicación aceptar tanto punto (.) como coma (,) como separador decimal en el monto? → A: Aceptar tanto punto (.) como coma (,) convirtiéndolos internamente a punto decimal para el cálculo.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cálculo Exacto de la Cuenta (Priority: P1)

Como comensal en un restaurante, quiero ingresar el monto total de la cuenta, el número de personas y el porcentaje de propina para conocer el valor exacto con dos decimales que le corresponde pagar a cada persona.

**Why this priority**: Es la funcionalidad central y el caso de uso primordial de la aplicación. Sin este cálculo la app no aporta valor.

**Independent Test**: Puede probarse ingresando montos válidos con propina y modo exacto, verificando que se muestre el desglose y el monto por persona con 2 decimales sin requerir redondeo.

**Acceptance Scenarios**:

1. **Given** un monto de `100.00`, `4` personas, `10%` de propina y modo `exacto`, **When** el usuario presiona "Calcular", **Then** el sistema muestra `27.50` por persona.
2. **Given** un monto de `90.00`, `3` personas, `0%` de propina y modo `exacto`, **When** el usuario presiona "Calcular", **Then** el sistema muestra `30.00` por persona.
3. **Given** un monto de `10.00`, `3` personas, `0%` de propina y modo `exacto`, **When** el usuario presiona "Calcular", **Then** el sistema muestra `3.33` por persona.
4. **Given** un monto con coma decimal `100,00`, `4` personas, `10%` de propina y modo `exacto`, **When** el usuario presiona "Calcular", **Then** el sistema interpreta la coma como punto y muestra `27.50` por persona.

---

### User Story 2 - Redondeo al Entero Superior (Priority: P2)

Como comensal que paga en efectivo o prefiere cifras cerradas, quiero poder seleccionar el modo de redondeo "hacia arriba al entero más cercano" para evitar pagar o transferir fracciones de centavos.

**Why this priority**: Facilita el pago en efectivo y evita conflictos con monedas pequeñas entre comensales.

**Independent Test**: Puede probarse seleccionando la opción de redondeo hacia arriba y verificando que el resultado fraccionario se eleve al entero inmediato superior con dos decimales (`.00`).

**Acceptance Scenarios**:

1. **Given** un monto de `10.00`, `3` personas, `0%` de propina y modo `hacia arriba`, **When** el usuario presiona "Calcular", **Then** el sistema muestra `4.00` por persona.
2. **Given** un monto de `100.00`, `4` personas, `10%` de propina (subtotal por persona 27.50) y modo `hacia arriba`, **When** el usuario presiona "Calcular", **Then** el sistema muestra `28.00` por persona.

---

### User Story 3 - Validación de Datos de Entrada y Manejo de Errores (Priority: P3)

Como usuario, quiero recibir mensajes de error claros cuando ingrese datos incorrectos o incompletos, para poder corregirlos sin que la aplicación muestre resultados engañosos o falle.

**Why this priority**: Garantiza la solidez del sistema, la integridad de los cálculos y una experiencia de usuario guiada y predecible.

**Independent Test**: Puede probarse introduciendo entradas no numéricas, campos vacíos o cero comensales y verificando que aparezca el mensaje de validación correspondiente y no se presente ningún resultado monetario.

**Acceptance Scenarios**:

1. **Given** un monto de `50.00` y `0` personas, **When** el usuario presiona "Calcular", **Then** el sistema muestra el mensaje `"Debe haber al menos una persona"` y no muestra resultado de cálculo.
2. **Given** un monto con valor de texto `"abc"`, **When** el usuario presiona "Calcular", **Then** el sistema muestra el mensaje `"Monto inválido"` y no muestra resultado de cálculo.
3. **Given** un monto negativo o vacío, **When** el usuario presiona "Calcular", **Then** el sistema muestra el mensaje `"Monto inválido"`.
4. **Given** un campo de propina vacío o con valor inválido, **When** el usuario presiona "Calcular", **Then** el sistema muestra un mensaje de error indicando que la propina es requerida y no muestra resultado de cálculo.

---

### Edge Cases

- **Cero personas**: El sistema rechaza el cálculo con el mensaje de error `"Debe haber al menos una persona"`.
- **Monto no numérico o vacío**: El sistema muestra `"Monto inválido"`.
- **Separador decimal**: Admite tanto coma (`,`) como punto (`.`) sin generar error.
- **Propina vacía o inválida**: El sistema muestra un mensaje indicando que la propina es requerida y no muestra resultado.
- **Porcentaje de propina cero (0%)**: Se calcula únicamente el monto base dividido entre los comensales sin sumar propina.
- **División con decimales periódicos**: En modo exacto, el resultado se trunca o redondea estándar a 2 decimales (ej. 10.00 / 3 = 3.33).
- **Monto exacto que ya es entero**: En modo hacia arriba, si el resultado exacto ya es entero (ej. 30.00), permanece como 30.00.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La interfaz de usuario DEBE consistir en una única pantalla que contenga los campos de entrada: Monto total, Número de personas, Porcentaje de propina y Selector de modo de redondeo.
- **FR-002**: El sistema DEBE ofrecer exactamente dos modos de redondeo: "Exacto" y "Hacia arriba al entero más cercano".
- **FR-003**: El sistema DEBE calcular el monto total a pagar sumando el monto base más la propina: $\text{Total} = \text{Monto} + (\text{Monto} \times \frac{\text{Propina}}{100})$.
- **FR-004**: En modo exacto, el sistema DEBE calcular la cuota individual dividiendo el total entre el número de personas y formatear la salida con exactamente dos decimales.
- **FR-005**: En modo hacia arriba, el sistema DEBE redondear el valor resultante hacia el entero más cercano superior ($\lceil \text{cuota} \rceil$) y formatearlo con dos decimales (`.00`).
- **FR-006**: Si el número de personas es menor a 1, el sistema DEBE mostrar el mensaje `"Debe haber al menos una persona"` y no debe presentar ningún valor de resultado.
- **FR-007**: El sistema DEBE aceptar números con punto (`.`) o coma (`,`) como separador decimal. Si el monto ingresado no es un número válido o es menor o igual a cero, el sistema DEBE mostrar el mensaje `"Monto inválido"` y no debe presentar ningún valor de resultado.
- **FR-008**: Si el campo de propina está vacío o no es un número válido mayor o igual a cero, el sistema DEBE mostrar un mensaje de error indicando que la propina es requerida y no debe presentar ningún valor de resultado.
- **FR-009**: La aplicación DEBE funcionar 100% offline, sin requerir acceso a internet, APIs remotas ni almacenamiento persistente en bases de datos.

### Key Entities

- **Cuenta / Factura**: Representa los datos de consumo de la mesa: monto base, porcentaje de propina y número de comensales.
- **Regla de Redondeo**: Abstracción del cálculo de redondeo con dos implementaciones concretas: Redondeo Exacto (estándar a 2 decimales) y Redondeo al Entero Superior (techo hacia el siguiente entero).
- **Resultado de División**: Representa el importe final que corresponde abonar a cada comensal junto con el total consolidado.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de los escenarios de aceptación descritos ejecutan y pasan satisfactoriamente en las pruebas automatizadas.
- **SC-002**: El usuario obtiene el resultado del cálculo inmediatamente (en menos de 100 milisegundos tras pulsar "Calcular").
- **SC-003**: Cero llamadas a servicios de red o dependencias externas durante el ciclo de vida de la aplicación.
- **SC-004**: Todos los resultados mostrados al usuario se presentan de forma estricta con 2 cifras decimales.

---

## Assumptions

- La moneda utilizada utiliza representación decimal estándar con dos cifras después del separador decimal.
- La aplicación no requiere conservar un historial de cálculos entre sesiones.
