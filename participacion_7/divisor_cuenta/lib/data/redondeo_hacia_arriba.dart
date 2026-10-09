import '../domain/estrategia_redondeo.dart';

/// Implementación concreta de [EstrategiaRedondeo] que redondea hacia arriba al entero más cercano (techo o ceil).
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  @override
  double redondear(double valor) {
    return valor.ceilToDouble();
  }
}
