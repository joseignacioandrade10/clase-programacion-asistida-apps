# Contrato de Interfaz: EstrategiaRedondeo

**Capa**: `lib/domain/estrategia_redondeo.dart`

---

## Definición

```dart
abstract interface class EstrategiaRedondeo {
  /// Recibe un valor decimal en coma flotante y devuelve el valor redondeado
  /// según la estrategia concreta implementada.
  /// 
  /// - Parámetro: [valor] (double positivo)
  /// - Retorna: [double] redondeado
  /// - Excepciones: Ninguna esperada con valores numéricos válidos.
  double redondear(double valor);
}
```

## Implementaciones Concretas Esperadas (`lib/data/`)

1. **`RedondeoExacto`**:
   - `redondear(27.50)` $\rightarrow$ `27.50`
   - `redondear(3.33333...)` $\rightarrow$ `3.33`
2. **`RedondeoHaciaArriba`**:
   - `redondear(3.33)` $\rightarrow$ `4.00`
   - `redondear(27.50)` $\rightarrow$ `28.00`
   - `redondear(30.00)` $\rightarrow$ `30.00` (los enteros cerrados se conservan)
