import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';

Widget _crearAplicacion() {
  final controller = DivisorController(
    calcularDivision: CalcularDivision(),
    validarEntrada: ValidarEntrada(),
    estrategiaExacto: RedondeoExacto(),
    estrategiaHaciaArriba: RedondeoHaciaArriba(),
  );

  return AplicacionDivisorCuenta(controller: controller);
}

void main() {
  testWidgets(
      '1. Escribo 100, 4 y 10, toco "Calcular" y aparece "27.50" en pantalla',
      (WidgetTester tester) async {
    await tester.pumpWidget(_crearAplicacion());

    await tester.enterText(find.byKey(const Key('campo_monto')), '100');
    await tester.enterText(find.byKey(const Key('campo_personas')), '4');
    await tester.enterText(find.byKey(const Key('campo_propina')), '10');

    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('27.50'), findsOneWidget);
  });

  testWidgets(
      '2. Escribo 50 y 0 personas, toco "Calcular" y aparece "Debe haber al menos una persona", y NO aparece ningún resultado',
      (WidgetTester tester) async {
    await tester.pumpWidget(_crearAplicacion());

    await tester.enterText(find.byKey(const Key('campo_monto')), '50');
    await tester.enterText(find.byKey(const Key('campo_personas')), '0');

    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const Key('texto_resultado')), findsNothing);
    expect(find.text('Cada persona paga:'), findsNothing);
  });

  testWidgets(
      '3. Escribo "abc" en el monto, toco "Calcular" y aparece "Monto inválido"',
      (WidgetTester tester) async {
    await tester.pumpWidget(_crearAplicacion());

    await tester.enterText(find.byKey(const Key('campo_monto')), 'abc');

    await tester.tap(find.text('Calcular'));
    await tester.pump();

    expect(find.text('Monto inválido'), findsOneWidget);
    expect(find.byKey(const Key('texto_resultado')), findsNothing);
  });
}
