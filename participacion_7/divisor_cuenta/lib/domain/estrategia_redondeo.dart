/// Interfaz abstracta para definir algoritmos o reglas de redondeo sobre valores numéricos.
/// Cumple con ISP al contener un único método y con OCP al permitir extender el redondeo
/// sin modificar las clases de dominio existentes.
abstract interface class EstrategiaRedondeo {
  /// Redondea un valor decimal según el criterio de la estrategia concreta.
  double redondear(double valor);
}
