import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

void main() {
  group('ValidarEntrada', () {
    late ValidarEntrada validador;

    setUp(() {
      validador = ValidarEntrada();
    });

    group('validarMonto', () {
      test('acepta números válidos con punto decimal', () {
        expect(validador.validarMonto('100.00'), isNull);
        expect(validador.validarMonto('25.5'), isNull);
      });

      test('acepta números válidos con coma decimal', () {
        expect(validador.validarMonto('100,00'), isNull);
        expect(validador.validarMonto('25,5'), isNull);
      });

      test('retorna "Monto inválido" para valores no numéricos como "abc"', () {
        expect(validador.validarMonto('abc'), equals('Monto inválido'));
        expect(validador.validarMonto('12a'), equals('Monto inválido'));
      });

      test('retorna "Monto inválido" para valores nulos, vacíos o espacios', () {
        expect(validador.validarMonto(null), equals('Monto inválido'));
        expect(validador.validarMonto(''), equals('Monto inválido'));
        expect(validador.validarMonto('   '), equals('Monto inválido'));
      });

      test('retorna "Monto inválido" para montos cero o negativos', () {
        expect(validador.validarMonto('0'), equals('Monto inválido'));
        expect(validador.validarMonto('-10.00'), equals('Monto inválido'));
      });
    });

    group('validarPersonas', () {
      test('acepta números de comensales válidos mayores o iguales a 1', () {
        expect(validador.validarPersonas('1'), isNull);
        expect(validador.validarPersonas('4'), isNull);
        expect(validador.validarPersonas('10'), isNull);
      });

      test('retorna "Debe haber al menos una persona" si el número es 0 o negativo', () {
        expect(validador.validarPersonas('0'), equals('Debe haber al menos una persona'));
        expect(validador.validarPersonas('-1'), equals('Debe haber al menos una persona'));
      });

      test('retorna "Debe haber al menos una persona" si está vacío, nulo o no es entero', () {
        expect(validador.validarPersonas(null), equals('Debe haber al menos una persona'));
        expect(validador.validarPersonas(''), equals('Debe haber al menos una persona'));
        expect(validador.validarPersonas('abc'), equals('Debe haber al menos una persona'));
        expect(validador.validarPersonas('2.5'), equals('Debe haber al menos una persona'));
      });
    });

    group('validarPropina', () {
      test('acepta porcentajes válidos mayores o iguales a 0', () {
        expect(validador.validarPropina('0'), isNull);
        expect(validador.validarPropina('10'), isNull);
        expect(validador.validarPropina('15.5'), isNull);
        expect(validador.validarPropina('15,5'), isNull);
      });

      test('retorna "La propina es requerida" si está vacía, nula o no es numérica', () {
        expect(validador.validarPropina(null), equals('La propina es requerida'));
        expect(validador.validarPropina(''), equals('La propina es requerida'));
        expect(validador.validarPropina('xyz'), equals('La propina es requerida'));
      });

      test('retorna "La propina es requerida" para porcentajes negativos', () {
        expect(validador.validarPropina('-5'), equals('La propina es requerida'));
      });
    });
  });
}
