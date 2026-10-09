import 'package:flutter/material.dart';
import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // main.dart es el ÚNICO lugar donde se instancian las implementaciones concretas
  // respetando el principio de Inversión de Dependencias (DIP) y la constitución del proyecto.
  final estrategiaExacto = RedondeoExacto();
  final estrategiaHaciaArriba = RedondeoHaciaArriba();
  final calcularDivision = CalcularDivision();
  final validarEntrada = ValidarEntrada();

  final controller = DivisorController(
    calcularDivision: calcularDivision,
    validarEntrada: validarEntrada,
    estrategiaExacto: estrategiaExacto,
    estrategiaHaciaArriba: estrategiaHaciaArriba,
  );

  runApp(AplicacionDivisorCuenta(controller: controller));
}

/// Widget raíz de la aplicación.
class AplicacionDivisorCuenta extends StatelessWidget {
  final DivisorController controller;

  const AplicacionDivisorCuenta({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de Cuenta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
      ),
      home: PantallaDivisor(controller: controller),
    );
  }
}
