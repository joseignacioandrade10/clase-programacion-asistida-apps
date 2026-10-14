# Respuestas - Deber 3

1. **Rojo antes de verde.** 
El mensaje de error que me mostró `flutter test` en la Parte 2 fue que se esperaba el texto `'La propina no puede superar el 100%'`, pero el resultado actual fue `<null>` (no devolvió un String). Era muy importante ver la prueba fallar primero (rojo) para comprobar que el test realmente funciona y es capaz de detectar cuando la regla no existe o está rota. Si siempre estuviera en verde, no sabríamos si la prueba sirve.

2. **Linter vs. IA.** 
El linter de `flutter analyze` me mostró avisos de reglas estáticas, como variables declaradas pero no usadas (`unused_local_variable`). Por su parte, la IA me señaló un code smell de diseño: "Método de construcción largo (Long Build Method / God Widget)" en `lib/presentation/pantalla_divisor.dart`. El linter no encontró este code smell porque solo es un programa que lee sintaxis básica y reglas predefinidas de Dart, pero no tiene la capacidad de analizar la "sobrecarga cognitiva", el diseño, ni la dificultad para leer un widget tan largo como sí lo hace la IA.

3. **Tu refactorización.** 
Elegí el code smell "Método de construcción largo (Long Build Method)" en `lib/presentation/pantalla_divisor.dart`. El código cambió modularizando ese método gigante de 150 líneas contiguas dividiéndolo en componentes o métodos extractores más pequeños (como `_construirFormulario()` o `_construirResultado()`). Sé con total seguridad que la app sigue haciendo exactamente lo mismo porque, inmediatamente después del refactor, ejecuté `flutter test` y todas las pruebas pasaron en verde.

4. **Coverage.** 
El archivo con el porcentaje más bajo fue `[PON_AQUÍ_EL_ARCHIVO_CON_MENOS_PORCENTAJE, ej: lib/main.dart]`. Que tenga el porcentaje bajo no significa para nada que tenga errores o que funcione mal. Simplemente significa que las líneas de código de ese archivo no fueron ejecutadas por nuestras pruebas automatizadas durante el comando `flutter test`.