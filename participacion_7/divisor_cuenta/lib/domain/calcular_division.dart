import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

/// Caso de uso que aplica la lógica matemática para dividir una cuenta.
/// No valida cadenas de texto ni formatea para la pantalla (SRP).
class CalcularDivision {
  /// Ejecuta el cálculo sumando la propina y dividiendo equitativamente entre los comensales,
  /// aplicando la [estrategia] de redondeo suministrada.
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
