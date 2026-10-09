# Data Model & Entidades: División de Cuenta

**Feature**: `specs/001-dividir-cuenta` | **Fecha**: 2026-10-01

Este documento define las entidades, modelos de datos, interfaces y contratos de tipos que estructuran la aplicación, en estricto apego a las capas `domain`, `data` y `presentation`.

---

## 1. Capa de Dominio (`lib/domain/`)

*Nota: La capa `domain` es Dart puro y no contiene ninguna dependencia de `package:flutter`.*

### 1.1 Entidad `Cuenta`
Representa los datos brutos de la transacción antes del cálculo.

```dart
class Cuenta {
  final double montoTotal;
  final int numeroPersonas;
  final double porcentajePropina;

  const Cuenta({
    required this.montoTotal,
    required this.numeroPersonas,
    required this.porcentajePropina,
  });
}
```

- **Inmutabilidad:** Todos los campos son `final`.
- **Reglas de negocio asociadas:**
  - `montoTotal` debe ser mayor a 0.
  - `numeroPersonas` debe ser mayor o igual a 1.
  - `porcentajePropina` debe ser mayor o igual a 0.

---

### 1.2 Entidad `Resultado`
Representa el producto del cálculo efectuado para la cuenta.

```dart
class Resultado {
  final double totalPagar;
  final double cuotaPorPersona;

  const Resultado({
    required this.totalPagar,
    required this.cuotaPorPersona,
  });
}
```

- **Inmutabilidad:** Todos los campos son `final`.
- **Valores:**
  - `totalPagar`: Corresponde al monto base más el valor de la propina calculada.
  - `cuotaPorPersona`: Corresponde al monto por comensal tras aplicar la estrategia de redondeo especificada.

---

### 1.3 Interfaz `EstrategiaRedondeo`
Contrato abstracto para el redondeo de importes.

```dart
abstract interface class EstrategiaRedondeo {
  double redondear(double valor);
}
```

- **ISP:** Posee un único método enfocado (`redondear`).
- **LSP / OCP:** Permite añadir nuevas formas de redondeo sin alterar `CalcularDivision`.

---

### 1.4 Caso de Uso `CalcularDivision`
Aplica la lógica pura de cálculo sin formateo ni validaciones visuales.

```dart
class CalcularDivision {
  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final propina = cuenta.montoTotal * (cuenta.porcentajePropina / 100.0);
    final total = cuenta.montoTotal + propina;
    final cuotaExacta = total / cuenta.numeroPersonas;
    final cuotaFinal = estrategia.redondear(cuotaExacta);

    return Resultado(
      totalPagar: total,
      cuotaPorPersona: cuotaFinal,
    );
  }
}
```

---

### 1.5 Caso de Uso `ValidarEntrada`
Verifica las entradas del usuario y retorna errores descriptivos si no cumplen las condiciones mínimas.

```dart
class ValidarEntrada {
  String? validarMonto(String? texto) {
    if (texto == null || texto.trim().isEmpty) return 'Monto inválido';
    final normalizado = texto.replaceAll(',', '.').trim();
    final valor = double.tryParse(normalizado);
    if (valor == null || valor <= 0) return 'Monto inválido';
    return null;
  }

  String? validarPersonas(String? texto) {
    if (texto == null || texto.trim().isEmpty) return 'Debe haber al menos una persona';
    final valor = int.tryParse(texto.trim());
    if (valor == null || valor < 1) return 'Debe haber al menos una persona';
    return null;
  }

  String? validarPropina(String? texto) {
    if (texto == null || texto.trim().isEmpty) return 'La propina es requerida';
    final normalizado = texto.replaceAll(',', '.').trim();
    final valor = double.tryParse(normalizado);
    if (valor == null || valor < 0) return 'La propina es requerida';
    return null;
  }
}
```

---

## 2. Capa de Datos (`lib/data/`)

### 2.1 Implementación `RedondeoExacto`
Aplica redondeo decimal estándar a dos cifras decimales.

```dart
import '../domain/estrategia_redondeo.dart';

class RedondeoExacto implements EstrategiaRedondeo {
  @override
  double redondear(double valor) {
    // Redondeo estándar a 2 decimales
    return (valor * 100).roundToDouble() / 100.0;
  }
}
```

---

### 2.2 Implementación `RedondeoHaciaArriba`
Aplica redondeo al entero superior inmediato ($\lceil x \rceil$).

```dart
import '../domain/estrategia_redondeo.dart';

class RedondeoHaciaArriba implements EstrategiaRedondeo {
  @override
  double redondear(double valor) {
    return valor.ceilToDouble();
  }
}
```

---

## 3. Capa de Presentación (`lib/presentation/`)

### 3.1 `FormateadorMoneda`
Formatea números a dos cifras decimales fijas.

```dart
class FormateadorMoneda {
  static String formatear(double valor) {
    return valor.toStringAsFixed(2);
  }
}
```

### 3.2 `DivisorEstado` y `DivisorController`
Encapsula el estado de la vista y coordina validaciones y cálculos sin mezclar lógica en el widget.

```dart
enum ModoRedondeo { exacto, haciaArriba }

class DivisorEstado {
  final String? errorMonto;
  final String? errorPersonas;
  final String? errorPropina;
  final Resultado? resultado;
  final ModoRedondeo modoRedondeo;

  const DivisorEstado({
    this.errorMonto,
    this.errorPersonas,
    this.errorPropina,
    this.resultado,
    this.modoRedondeo = ModoRedondeo.exacto,
  });
}
```
