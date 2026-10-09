import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';

void main() {
  testWidgets('La aplicación inicia correctamente y muestra la pantalla principal',
      (WidgetTester tester) async {
    final controller = DivisorController(
      calcularDivision: CalcularDivision(),
      validarEntrada: ValidarEntrada(),
      estrategiaExacto: RedondeoExacto(),
      estrategiaHaciaArriba: RedondeoHaciaArriba(),
    );

    await tester.pumpWidget(AplicacionDivisorCuenta(controller: controller));

    expect(find.text('Divisor de Cuenta'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
  });
}
