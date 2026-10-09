# Contrato: DivisorController

**Capa**: `lib/presentation/divisor_controller.dart`

---

## Definición

```dart
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

  /// Ejecuta el proceso de validación y cálculo.
  /// 
  /// Si alguna validación falla, retorna un [DivisorEstado] con los mensajes de error
  /// correspondientes y con [resultado] en null.
  /// 
  /// Si todas las validaciones son exitosas, crea la entidad [Cuenta], invoca a 
  /// [calcularDivision] con la estrategia de redondeo activa y devuelve el nuevo estado.
  DivisorEstado calcular({
    required String? textoMonto,
    required String? textoPersonas,
    required String? textoPropina,
    required ModoRedondeo modoRedondeo,
  });
}
```
