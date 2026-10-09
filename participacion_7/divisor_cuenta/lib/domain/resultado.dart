/// Entidad inmutable que encapsula el resultado del cálculo de división de la cuenta.
class Resultado {
  /// Monto total general a pagar, incluyendo el valor de la propina calculada.
  final double totalPagar;

  /// Monto individual que corresponde pagar a cada persona tras aplicar la estrategia de redondeo.
  final double cuotaPorPersona;

  const Resultado({
    required this.totalPagar,
    required this.cuotaPorPersona,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resultado &&
          runtimeType == other.runtimeType &&
          totalPagar == other.totalPagar &&
          cuotaPorPersona == other.cuotaPorPersona;

  @override
  int get hashCode => totalPagar.hashCode ^ cuotaPorPersona.hashCode;

  @override
  String toString() => 'Resultado(totalPagar: $totalPagar, cuotaPorPersona: $cuotaPorPersona)';
}
