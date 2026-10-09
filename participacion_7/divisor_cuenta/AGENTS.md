# Instrucciones del Proyecto - Divisor de Cuenta

## Descripción
Aplicación en Flutter de una sola pantalla diseñada para dividir la cuenta entre varias personas de forma clara y equitativa.

## Estructura y Arquitectura
El código se organiza bajo una arquitectura en capas dentro de `lib/`:

- `lib/presentation`: Widgets, componentes visuales y manejo del estado de la pantalla.
- `lib/domain`: Entidades, lógica de cálculo y reglas de negocio puras.
- `lib/data`: Modelos de datos y repositorios o fuentes locales (si aplica).

### Reglas de Dependencias
- Flujo: `presentation -> domain <- data`.
- **Restricción:** La capa `domain` es Dart puro y **NO debe importar nada de `package:flutter`**.

## Estándares
- **Null safety:** Obligatorio y estricto en todo el proyecto.
- **Idioma:** Nombres de clases, métodos, variables y comentarios en español.
- **Sin paquetes externos:** Utilizar únicamente los paquetes nativos del SDK de Flutter y Dart (sin agregar librerías de terceros a `pubspec.yaml`).

## Restricciones (Qué NO tocar)
- **NO modificar `test/`** a menos que sea solicitado expresamente.
- **NO agregar dependencias** al `pubspec.yaml` sin avisar previamente.
- **NO tocar las carpetas nativas:** `android/` ni `ios/`.

## Comandos Útiles
- `flutter pub get`: Obtener dependencias.
- `flutter run`: Ejecutar la aplicación.
- `flutter analyze`: Analizar el código en busca de errores o advertencias.
- `flutter test`: Ejecutar la suite de pruebas.
