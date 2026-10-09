# Divisor de Cuenta

Aplicación móvil en Flutter de una sola pantalla diseñada para dividir la cuenta de un restaurante de manera equitativa, transparente y sin conexión a internet.

---

## 🚀 Características

- **Cálculo instantáneo:** Ingrese el monto total, número de comensales y porcentaje de propina para calcular la cuota por persona y el total a pagar con dos decimales.
- **Estrategias de redondeo:**
  - **Exacto:** Mantiene la división exacta con dos cifras decimales estándar.
  - **Hacia arriba:** Redondea la cuota por persona al entero superior más cercano para evitar centavos.
- **Validación flexible:** Acepta tanto punto (`.`) como coma (`,`) como separador decimal.
- **Control de errores amigable:** Notificaciones inline si el monto es inválido, si el número de personas es menor a 1 o si la propina no fue especificada.
- **100% Offline:** Funciona de forma totalmente local, sin llamadas de red ni base de datos externa.

---

## 🏛️ Arquitectura y Principios SOLID

El proyecto sigue una arquitectura en capas desacoplada y estricta bajo el flujo:
`presentation -> domain <- data`

- **`lib/domain`**: Entidades inmutables (`Cuenta`, `Resultado`), reglas de negocio (`CalcularDivision`, `ValidarEntrada`) y contratos abstractos (`EstrategiaRedondeo`). Es Dart puro sin ninguna dependencia de `package:flutter`.
- **`lib/data`**: Implementaciones concretas de las estrategias de cálculo (`RedondeoExacto`, `RedondeoHaciaArriba`).
- **`lib/presentation`**: Interfaz de usuario (`PantallaDivisor`), controlador de estado desacoplado (`DivisorController`) y utilidades visuales (`FormateadorMoneda`).
- **`lib/main.dart`**: Único punto de composición e inyección de dependencias (DIP).

---

## 🛠️ Comandos de Desarrollo

```bash
# Obtener dependencias (solo SDK Flutter)
flutter pub get

# Ejecutar análisis estático (0 advertencias)
flutter analyze

# Ejecutar suite completa de pruebas unitarias y de widgets
flutter test

# Iniciar la aplicación
flutter run
```

---

## 🧪 Pruebas Automatizadas

La suite de pruebas en `test/` incluye:
- **Pruebas unitarias de dominio:** Validación de reglas de negocio y cálculo matemático con y sin propina.
- **Pruebas unitarias de datos:** Comprobación de estrategias de redondeo exacto y superior.
- **Pruebas de presentación:** Pruebas de formateo de moneda a dos decimales.
- **Pruebas de widgets:** Verificación automatizada de los 6 escenarios de aceptación y validaciones en pantalla.
