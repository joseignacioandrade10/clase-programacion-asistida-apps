import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/pantalla_divisor.dart';

Widget _crearPantallaPrueba() {
  final controller = DivisorController(
    calcularDivision: CalcularDivision(),
    validarEntrada: ValidarEntrada(),
    estrategiaExacto: RedondeoExacto(),
    estrategiaHaciaArriba: RedondeoHaciaArriba(),
  );

  return MaterialApp(
    home: PantallaDivisor(controller: controller),
  );
}

void main() {
  group('PantallaDivisor - Pruebas de Widgets y Escenarios de Aceptación', () {
    testWidgets(
        'Escenario 1: 100.00, 4 personas, 10% propina, modo exacto -> 27.50',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '100.00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '4');
      await tester.enterText(find.byKey(const Key('campo_propina')), '10');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.byKey(const Key('texto_resultado')), findsOneWidget);
      expect(find.text('27.50'), findsOneWidget);
      expect(find.textContaining('Total a pagar: \$ 110.00'), findsOneWidget);
    });

    testWidgets(
        'Escenario 2: 90.00, 3 personas, 0% propina, modo exacto -> 30.00',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '90.00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '3');
      await tester.enterText(find.byKey(const Key('campo_propina')), '0');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.byKey(const Key('texto_resultado')), findsOneWidget);
      expect(find.text('30.00'), findsOneWidget);
      expect(find.textContaining('Total a pagar: \$ 90.00'), findsOneWidget);
    });

    testWidgets(
        'Escenario 3: 50.00 y 0 personas -> "Debe haber al menos una persona" y sin resultado',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '50.00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '0');
      await tester.enterText(find.byKey(const Key('campo_propina')), '10');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.text('Debe haber al menos una persona'), findsOneWidget);
      expect(find.byKey(const Key('texto_resultado')), findsNothing);
    });

    testWidgets(
        'Escenario 4: Monto "abc" -> "Monto inválido" y sin resultado',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), 'abc');
      await tester.enterText(find.byKey(const Key('campo_personas')), '2');
      await tester.enterText(find.byKey(const Key('campo_propina')), '10');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.text('Monto inválido'), findsOneWidget);
      expect(find.byKey(const Key('texto_resultado')), findsNothing);
    });

    testWidgets(
        'Escenario 5: 10.00, 3 personas, 0% propina, modo exacto -> 3.33',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '10.00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '3');
      await tester.enterText(find.byKey(const Key('campo_propina')), '0');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.byKey(const Key('texto_resultado')), findsOneWidget);
      expect(find.text('3.33'), findsOneWidget);
    });

    testWidgets(
        'Escenario 6: 10.00, 3 personas, 0% propina, modo hacia arriba -> 4.00',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '10.00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '3');
      await tester.enterText(find.byKey(const Key('campo_propina')), '0');

      // Seleccionar modo hacia arriba
      await tester.tap(find.text('Hacia arriba al entero más cercano'));
      await tester.pump();

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.byKey(const Key('texto_resultado')), findsOneWidget);
      expect(find.text('4.00'), findsOneWidget);
    });

    testWidgets(
        'Soporte de coma decimal: 100,00 con 4 personas y 10% propina -> 27.50',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '100,00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '4');
      await tester.enterText(find.byKey(const Key('campo_propina')), '10');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.byKey(const Key('texto_resultado')), findsOneWidget);
      expect(find.text('27.50'), findsOneWidget);
    });

    testWidgets(
        'Validación de propina vacía o inválida: muestra error y oculta resultado',
        (WidgetTester tester) async {
      await tester.pumpWidget(_crearPantallaPrueba());

      await tester.enterText(find.byKey(const Key('campo_monto')), '100.00');
      await tester.enterText(find.byKey(const Key('campo_personas')), '4');
      await tester.enterText(find.byKey(const Key('campo_propina')), '');

      await tester.tap(find.byKey(const Key('boton_calcular')));
      await tester.pump();

      expect(find.text('La propina es requerida'), findsOneWidget);
      expect(find.byKey(const Key('texto_resultado')), findsNothing);
    });
  });
}
