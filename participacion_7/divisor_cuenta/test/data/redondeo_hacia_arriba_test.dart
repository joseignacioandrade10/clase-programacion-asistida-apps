import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';

void main() {
  group('RedondeoHaciaArriba', () {
    late RedondeoHaciaArriba redondeo;

    setUp(() {
      redondeo = RedondeoHaciaArriba();
    });

    test('redondea al entero superior inmediato valores con decimales', () {
      expect(redondeo.redondear(3.3333333), equals(4.00));
      expect(redondeo.redondear(27.50), equals(28.00));
      expect(redondeo.redondear(0.01), equals(1.00));
    });

    test('conserva el valor sin alterar si ya es un entero exacto', () {
      expect(redondeo.redondear(30.00), equals(30.00));
      expect(redondeo.redondear(5.00), equals(5.00));
    });
  });
}
