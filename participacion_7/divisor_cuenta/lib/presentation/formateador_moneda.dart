/// Utilidad encargada exclusivamente del formateo visual de valores monetarios con 2 decimales.
class FormateadorMoneda {
  /// Devuelve el valor numérico en una cadena de texto formateada con exactamente dos decimales.
  static String formatear(double valor) {
    return valor.toStringAsFixed(2);
  }
}
