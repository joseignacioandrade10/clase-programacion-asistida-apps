import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';

void main() {
  group('RedondeoExacto', () {
    late RedondeoExacto redondeo;

    setUp(() {
      redondeo = RedondeoExacto();
    });

    test('mantiene dos decimales exactos cuando no hay residuo periódico', () {
      expect(redondeo.redondear(27.50), equals(27.50));
      expect(redondeo.redondear(30.00), equals(30.00));
    });

    test('redondea a 2 decimales estándar en divisiones periódicas como 10/3', () {
      final valor = 10.0 / 3.0; // 3.3333333333333335
      expect(redondeo.redondear(valor), equals(3.33));
    });

    test('redondea hacia arriba el segundo decimal cuando el tercer decimal es >= 5', () {
      expect(redondeo.redondear(3.335), equals(3.34));
    });
  });
}
