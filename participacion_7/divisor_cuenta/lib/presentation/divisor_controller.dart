import '../domain/calcular_division.dart';
import '../domain/cuenta.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/resultado.dart';
import '../domain/validar_entrada.dart';

/// Modos de redondeo disponibles para el usuario.
enum ModoRedondeo {
  exacto,
  haciaArriba,
}

/// Estado inmutable de la pantalla del divisor de cuentas.
class DivisorEstado {
  final String? errorMonto;
  final String? errorPersonas;
  final String? errorPropina;
  final Resultado? resultado;
  final ModoRedondeo modoRedondeo;

  const DivisorEstado({
    this.errorMonto,
    this.errorPersonas,
    this.errorPropina,
    this.resultado,
    this.modoRedondeo = ModoRedondeo.exacto,
  });

  bool get tieneErrores =>
      errorMonto != null || errorPersonas != null || errorPropina != null;
}

/// Controlador de presentación que coordina la validación y el cálculo.
/// Recibe todas sus dependencias mediante el constructor (DIP).
class DivisorController {
  final CalcularDivision calcularDivision;
  final ValidarEntrada validarEntrada;
  final EstrategiaRedondeo estrategiaExacto;
  final EstrategiaRedondeo estrategiaHaciaArriba;

  DivisorController({
    required this.calcularDivision,
    required this.validarEntrada,
    required this.estrategiaExacto,
    required this.estrategiaHaciaArriba,
  });

  /// Procesa los textos ingresados, ejecuta las validaciones y, si todo es válido,
  /// realiza el cálculo según el [modoRedondeo] seleccionado.
  DivisorEstado calcular({
    required String? textoMonto,
    required String? textoPersonas,
    required String? textoPropina,
    required ModoRedondeo modoRedondeo,
  }) {
    final errorMonto = validarEntrada.validarMonto(textoMonto);
    final errorPersonas = validarEntrada.validarPersonas(textoPersonas);
    final errorPropina = validarEntrada.validarPropina(textoPropina);

    if (errorMonto != null || errorPersonas != null || errorPropina != null) {
      return DivisorEstado(
        errorMonto: errorMonto,
        errorPersonas: errorPersonas,
        errorPropina: errorPropina,
        resultado: null,
        modoRedondeo: modoRedondeo,
      );
    }

    final monto = double.parse(textoMonto!.replaceAll(',', '.').trim());
    final personas = int.parse(textoPersonas!.trim());
    final propina = double.parse(textoPropina!.replaceAll(',', '.').trim());

    final cuenta = Cuenta(
      montoTotal: monto,
      numeroPersonas: personas,
      porcentajePropina: propina,
    );

    final estrategia = modoRedondeo == ModoRedondeo.exacto
        ? estrategiaExacto
        : estrategiaHaciaArriba;

    final resultado = calcularDivision.ejecutar(cuenta, estrategia);

    return DivisorEstado(
      errorMonto: null,
      errorPersonas: null,
      errorPropina: null,
      resultado: resultado,
      modoRedondeo: modoRedondeo,
    );
  }
}
