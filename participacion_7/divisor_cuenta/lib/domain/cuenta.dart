/// Entidad inmutable que representa los datos necesarios para realizar el cálculo de la cuenta.
class Cuenta {
  /// Monto total de la factura antes del cálculo.
  final double montoTotal;

  /// Número de comensales entre los que se divide la cuenta.
  final int numeroPersonas;

  /// Porcentaje de propina a aplicar sobre el monto total.
  final double porcentajePropina;

  const Cuenta({
    required this.montoTotal,
    required this.numeroPersonas,
    required this.porcentajePropina,
  });
}
