## Escenarios que elegí y por qué

Elegí tres escenarios de solapamiento crítico: solapamiento parcial al inicio (`specs/001-reservas-sala/spec.md:12`), solapamiento parcial al final (`specs/001-reservas-sala/spec.md:18`) y una reserva completamente contenida dentro de otra (`specs/001-reservas-sala/spec.md:24`). Los seleccioné porque cubren todas las combinaciones geométricas posibles de intervalos de tiempo cruzados, garantizando que la regla de negocio no sea ambigua frente a casos borde.

## Riesgo más grave del repositorio

El riesgo más grave es la falta de manejo concurrente de transacciones en la capa de datos (`lib/data/reservas_repository_impl.dart:34`), donde dos solicitudes simultáneas podrían leer la lista vacía al mismo tiempo y aprobar reservas superpuestas antes de que se actualice la base de datos.

## ¿La regla protege la app real?

Sí protege parcialmente la lógica de dominio al rechazar cruces de horarios en memoria (`lib/domain/crear_reserva.dart:18`), pero es insuficiente en producción si no se combina con restricciones de unicidad o bloqueos a nivel de base de datos en Supabase (`supabase/migrations/schema.sql:12`).