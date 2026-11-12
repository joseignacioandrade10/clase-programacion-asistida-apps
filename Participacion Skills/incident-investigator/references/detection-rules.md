# Reglas de Detección — Incident Investigator

Documento de referencia de dominio para investigar archivos CSV compatibles con el esquema:
`timestamp,ip,user,event,result,detail`.

---

## 1. Convenciones obligatorias

1. **Ordenamiento previo**: ordena todos los registros cronológicamente por `timestamp` antes de evaluar ventanas temporales.
2. **Semántica de ventana temporal**: una ventana de `≤ 5 minutos` es **inclusiva en ambos extremos** (`t_fin - t_inicio <= 5 minutos`).
3. **Coincidencia exacta de eventos**: una regla solo cuenta un evento cuando `event` y `result` coinciden exactamente con el patrón indicado (en notación `event/result`, p. ej., `login/failed` equivale a `event == "login"` y `result == "failed"`).
4. **Citación por fila original**: reporta siempre los números de fila del CSV original, donde **el encabezado es la fila 1** y el primer evento de datos es la fila 2. El reordenamiento temporal nunca debe alterar el número de fila citado.
5. **Ambigüedad y duplicados**: si existen múltiples registros con valores idénticos en el mismo `timestamp` y el CSV no incluye identificador único ni resolución de sub-segundos para distinguir reintentos reales de duplicados de ingesta, cuenta los registros tal como aparecen pero **declara esa limitación explícitamente**; nunca inventes una regla de deduplicación no documentada.
6. **Alcance probatorio**: los resultados son **alertas justificadas** derivadas de los registros disponibles, **no conclusiones forenses definitivas** ni pruebas de culpabilidad.

---

## 2. Reglas de detección

### `R1-BRUTE-FORCE` — Fuerza bruta probable
- **Condición principal**: **6 o más** eventos `login/failed` procedentes de la **misma `ip`** hacia el **mismo `user`** dentro de una ventana de **≤ 5 minutos**.
- **Verificación posterior obligatoria**: comprueba si existe un evento `login/success` con esa **misma `ip`** y ese **mismo `user`** dentro de los **5 minutos siguientes** a los fallos. Si existe, **anótalo por separado** como contexto de posible compromiso posterior dentro del mismo hallazgo (sin asumir qué acciones ejecutó la sesión si el log no las registra).
- **Severidad orientativa**:
  - **Alta** si va seguida de `login/success` en los 5 minutos siguientes.
  - **Media** si no hay `login/success` posterior observado.

### `R2-PASSWORD-SPRAYING` — Password spraying probable
- **Condición principal**: eventos `login/failed` procedentes de una **misma `ip`** contra **al menos 5 valores distintos de `user`** dentro de una ventana de **≤ 5 minutos**.
- **Criterio de conteo**: cuenta usuarios únicos (`user`) afectados por `login/failed` desde esa IP dentro de la ventana; anota por separado si alguna cuenta registró `login/success` desde la misma IP en una ventana cercana.
- **Severidad orientativa**:
  - **Alta** si se observa `login/success` asociado desde la misma IP.
  - **Media** si todos los intentos observados fallaron.

### `R3-EXPOSED-TOKEN` — Token potencialmente expuesto
- **Condición principal**: cualquier registro (sin importar `event` o `result`) cuyo campo `detail` contenga la subcadena `token=`.
- **Regla de sanitización obligatoria**: **nunca imprimas ni copies el valor completo del token** en informes, tablas ni trazas. Enmascara el valor como `token=[REDACTED]`.
- **Limitaciones a declarar**: el log suele indicar la presencia del patrón `token=` en un mensaje (por ejemplo de depuración), pero no permite confirmar por sí solo si el token era de prueba, si sigue activo o quién tuvo acceso al archivo/consola donde se registró.
- **Severidad orientativa**: **Media** (requiere verificación fuera del log sobre vigencia y rotación).

### `R4-UNAPPROVED-PRIVILEGE-ESCALATION` — Escalada no autorizada según el registro
- **Condición principal**: evento `role_change/success` (`event == "role_change"` y `result == "success"`) cuyo campo `detail` contenga `approved=false`.
- **Contexto relacionado**: puedes citar eventos cercanos del mismo `user` o `ip` (por ejemplo, `access/denied` previos) como **contexto adicional**, diferenciándolos claramente de la condición que dispara la regla.
- **Límite de interpretación**: **no inferir culpabilidad** ni atribuir intención maliciosa; el registro solo evidencia que el cambio de rol tuvo éxito figurando `approved=false` en `detail`.
- **Severidad orientativa**: **Alta**.

---

## 3. Falsos positivos y exclusiones (`FP-EXCLUSIONS`)

Al investigar un archivo compatible, debes verificar y descartar explícitamente los siguientes casos para no inflar alertas:

1. **Fallos de inicio de sesión por debajo del umbral**:
   - **3 fallos aislados** (`login/failed`) de una misma IP y usuario —incluso si son seguidos por un `login/success`— **no alcanzan el umbral de `R1-BRUTE-FORCE` (≥ 6)** ni afectan a suficientes cuentas distintas para `R2-PASSWORD-SPRAYING` (≥ 5 usuarios distintos).
   - Repórtalos en la sección de falsos positivos / actividad normal explicando numéricamente por qué no cumplen el umbral.
2. **Eventos de monitoreo (`healthcheck`)**:
   - Registros con `event == "healthcheck"` (por ejemplo `healthcheck/success`) **no son eventos `login/failed`** ni intentos de autenticación fallidos, aunque ocurran de forma repetida o periódica en una ventana corta.
   - Exclúyelos de `R1` y `R2` y menciónalos brevemente como actividad operativa normal si el análisis revisa toda la línea temporal.
3. **Eventos aislados `login/failed` o `access/denied`**:
   - Un fallo puntual aislado sin repetición ni cambio de rol exitoso no dispara por sí solo `R1`, `R2` ni `R4`. Solo se menciona como contexto si se vincula a otra alerta justificada o en el apartado de descartes.

