# Research & Decisiones Técnicas: División de Cuenta

**Feature**: `specs/001-dividir-cuenta` | **Fecha**: 2026-10-01

Este documento consolida las decisiones de diseño arquitectónico y técnico para la implementación del divisor de cuentas conforme a la constitución del proyecto y los requerimientos especificados.

---

## 1. Separación de Responsabilidades y Capas (SOLID)

### Decisión
Organizar el código en tres capas estrictas dentro de `lib/`:
1. `lib/domain/`:
   - **`Cuenta`**: Entidad inmutable que representa los datos de entrada (monto total, comensales, porcentaje de propina).
   - **`Resultado`**: Entidad inmutable que contiene el monto total consolidado y la cuota individual por comensal.
   - **`EstrategiaRedondeo`**: Interfaz abstracta con un único método `double redondear(double valor)` (ISP y OCP).
   - **`CalcularDivision`**: Caso de uso que aplica la fórmula matemática y delega el redondeo a `EstrategiaRedondeo`. No valida ni formatea (SRP).
   - **`ValidarEntrada`**: Caso de uso dedicado exclusivamente a verificar que los datos de entrada sean coherentes (monto > 0, comensales >= 1, propina >= 0) y producir mensajes de error claros (SRP).
2. `lib/data/`:
   - **`RedondeoExacto`**: Implementación concreta que conserva dos decimales mediante redondeo aritmético o truncado estándar.
   - **`RedondeoHaciaArriba`**: Implementación concreta que eleva el valor fraccionario al entero inmediato superior ($\lceil x \rceil$).
3. `lib/presentation/`:
   - **`DivisorController`**: Orquestador de la presentación que recibe `CalcularDivision`, `ValidarEntrada` y las estrategias de redondeo por inyección en su constructor (DIP).
   - **`FormateadorMoneda`**: Clase utilitaria para formatear números de coma flotante a cadenas con exactamente dos decimales (`0.00`) (SRP).
   - **`PantallaDivisor`**: `StatefulWidget` que renderiza la pantalla única y actualiza la UI mediante `setState`.
4. `lib/main.dart`:
   - Único punto de composición e instanciación concreta. Instancia las estrategias de `data/`, los casos de uso de `domain/` y el controlador de `presentation/`, inyectándolos hacia la vista.

### Rationale
- Cumple 100% con la constitución del proyecto.
- `domain/` permanece como código Dart puro (sin `package:flutter`), lo cual permite probar toda la lógica de negocio con pruebas unitarias instantáneas sin dependencias de framework.
- Si en el futuro se desea agregar una nueva estrategia de redondeo (por ejemplo, redondeo bancario o al múltiplo de 5 más cercano), basta con agregar una nueva clase en `data/` que implemente `EstrategiaRedondeo`, sin modificar ninguna clase de `domain/` ni de `presentation/` (OCP).

### Alternativas Consideradas
- **Tener la lógica de cálculo dentro del Widget**: Rechazado tajantemente por violar SRP, acoplar la lógica al framework Flutter e incumplir la constitución.
- **Utilizar paquetes externos como Riverpod o Bloc**: Rechazado porque la especificación indica explícitamente "sin paquetes externos" y "estado local con setState (es una sola pantalla)".

---

## 2. Estrategia de Manejo de Estado

### Decisión
Utilizar `setState` en el estado de `PantallaDivisor` en conjunto con `DivisorController` para desacoplar el estado de la vista.

### Rationale
- La aplicación consta de una sola pantalla sin navegación ni persistencia offline compleja.
- `setState` es nativo del SDK de Flutter, no agrega dependencias externas y es trivial de auditar y explicar por un estudiante.

---

## 3. Conversión y Normalización de Separadores Decimales

### Decisión
La capa de presentación o validación normalizará las cadenas reemplazando comas (`,`) por puntos (`.`) antes de pasarlas al analizador numérico `double.tryParse()`.

### Rationale
- En teclados móviles configurados en español, el teclado numérico suele colocar una coma.
- La conversión asegura que entradas como `100,00` se interpreten idénticamente a `100.00` sin errores para el usuario final.
