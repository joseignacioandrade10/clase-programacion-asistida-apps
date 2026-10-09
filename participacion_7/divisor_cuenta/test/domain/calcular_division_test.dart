import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';

void main() {
  group('CalcularDivision con RedondeoExacto', () {
    late CalcularDivision calcularDivision;
    late RedondeoExacto estrategiaExacto;

    setUp(() {
      calcularDivision = CalcularDivision();
      estrategiaExacto = RedondeoExacto();
    });

    test('Escenario 1: 100.00, 4 personas, 10% propina -> 27.50 por persona y 110.00 total', () {
      const cuenta = Cuenta(
        montoTotal: 100.00,
        numeroPersonas: 4,
        porcentajePropina: 10.0,
      );

      final resultado = calcularDivision.ejecutar(cuenta, estrategiaExacto);

      expect(resultado.totalPagar, equals(110.00));
      expect(resultado.cuotaPorPersona, equals(27.50));
    });

    test('Escenario 2: 90.00, 3 personas, 0% propina -> 30.00 por persona y 90.00 total', () {
      const cuenta = Cuenta(
        montoTotal: 90.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
      );

      final resultado = calcularDivision.ejecutar(cuenta, estrategiaExacto);

      expect(resultado.totalPagar, equals(90.00));
      expect(resultado.cuotaPorPersona, equals(30.00));
    });

    test('Escenario 5: 10.00, 3 personas, 0% propina -> 3.33 por persona y 10.00 total', () {
      const cuenta = Cuenta(
        montoTotal: 10.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
      );

      final resultado = calcularDivision.ejecutar(cuenta, estrategiaExacto);

      expect(resultado.totalPagar, equals(10.00));
      expect(resultado.cuotaPorPersona, equals(3.33));
    });
  });
}
