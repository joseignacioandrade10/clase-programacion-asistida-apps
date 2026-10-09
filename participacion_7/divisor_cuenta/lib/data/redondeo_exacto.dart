import '../domain/estrategia_redondeo.dart';

/// Implementación concreta de [EstrategiaRedondeo] que realiza redondeo aritmético a 2 decimales.
class RedondeoExacto implements EstrategiaRedondeo {
  @override
  double redondear(double valor) {
    return (valor * 100).roundToDouble() / 100.0;
  }
}
