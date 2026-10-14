import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

void main() {
  group('Regla: La propina no puede superar el 100 %', () {
    late ValidarEntrada validador;

    setUp(() {
      validador = ValidarEntrada();
    });

    test(
        'Con monto 100, 4 personas y propina 150, la validación devuelve exactamente "La propina no puede superar el 100%"',
        () {
      final error = validador.validarMonto('100') ??
          validador.validarPersonas('4') ??
          validador.validarPropina('150');

      expect(error, equals('La propina no puede superar el 100%'));
    });

    test(
        'Con monto 100, 4 personas y propina 100, la validación NO devuelve error (el límite exacto sí se permite)',
        () {
      final error = validador.validarMonto('100') ??
          validador.validarPersonas('4') ??
          validador.validarPropina('100');

      expect(error, isNull);
    });
  });
}
