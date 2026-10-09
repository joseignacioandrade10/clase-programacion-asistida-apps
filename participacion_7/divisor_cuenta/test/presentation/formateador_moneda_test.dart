import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';

void main() {
  group('FormateadorMoneda', () {
    test('formatea valores decimales a exactamente dos decimales', () {
      expect(FormateadorMoneda.formatear(27.5), equals('27.50'));
      expect(FormateadorMoneda.formatear(30.0), equals('30.00'));
      expect(FormateadorMoneda.formatear(3.333), equals('3.33'));
      expect(FormateadorMoneda.formatear(4.0), equals('4.00'));
      expect(FormateadorMoneda.formatear(0.0), equals('0.00'));
    });
  });
}
