/// Caso de uso responsable exclusivamente de verificar la validez de los datos de entrada
/// y producir los mensajes de error correspondientes (SRP).
class ValidarEntrada {
  /// Valida que el [texto] del monto represente un número positivo mayor a cero.
  /// Acepta indistintamente punto (.) y coma (,) como separadores decimales.
  String? validarMonto(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Monto inválido';
    }
    final normalizado = texto.replaceAll(',', '.').trim();
    final valor = double.tryParse(normalizado);
    if (valor == null || valor <= 0) {
      return 'Monto inválido';
    }
    return null;
  }

  /// Valida que el [texto] del número de comensales represente un entero mayor o igual a 1.
  String? validarPersonas(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Debe haber al menos una persona';
    }
    final valor = int.tryParse(texto.trim());
    if (valor == null || valor < 1) {
      return 'Debe haber al menos una persona';
    }
    return null;
  }

  /// Valida que el [texto] de propina sea numérico y no negativo.
  /// Acepta punto (.) y coma (,).
  String? validarPropina(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'La propina es requerida';
    }
    final normalizado = texto.replaceAll(',', '.').trim();
    final valor = double.tryParse(normalizado);
    if (valor == null || valor < 0) {
      return 'La propina es requerida';
    }
    return null;
  }
}
