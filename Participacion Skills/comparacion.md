# Comparación Experimental: Sin Skill vs. Con Skill

Evaluación didáctica en **dos sesiones independientes** sobre [`logs_sinteticos.csv`](logs_sinteticos.csv) (94 líneas; filas 2–94 = 93 eventos) usando el mismo modelo (**Gemini 3.8 Flash (High)**) y el mismo requerimiento base:

> *"Investiga los logs sintéticos en logs_sinteticos.csv, identifica incidentes justificables y distingue señales de seguridad de actividad normal. Devuelve evidencia concreta."*

- **Condición Sin skill** (sesión `993ed195-3a70-4eee-9ea3-56d9a4cbbad5`): `.agents/skills.json` vaciado temporalmente (`{"entries": []}`), con instrucción explícita de consultar únicamente `logs_sinteticos.csv` (sin `SKILL.md`, `detection-rules.md`, `hallazgos.md` ni script auxiliar).
- **Condición Con skill** (sesión `98854b27-b131-4f97-bce2-ab261f69dd99`): `.agents/skills.json` activo registrando `incident-investigator`, sin consultar `hallazgos.md`.

*(Nota: una corrida por condición constituye una **comparación didáctica**, no una prueba estadística.)*

---

## 1. Tabla comparativa

| Dimensión | Sin skill | Con skill | Evidencia / comentario |
|---|---|---|---|
| **¿Usó un procedimiento reproducible?** | **No (ad-hoc).** Evaluó los 93 eventos en una sola lectura mental sin umbrales explícitos ni cálculo verificable. | **Sí.** Aplicó los 6 pasos de `SKILL.md`: verificó esquema, leyó `references/detection-rules.md` antes de clasificar y validó conteos/ventanas deterministamente. | Sin skill usó heurísticas informales (*"ritmo humano"*, *"IP externa al rango habitual"*). Con skill siguió `SKILL.md` → `detection-rules.md` → verificación offline en `scratch/`. |
| **¿Citó filas concretas?** | **Sí.** Citó filas exactas del CSV (`L17`, `L19-L20`, `L28`, `L33`, `L38-L42`, `L57`, `L59`, `L67-L74`, `L78`, `L80-L84`, 11 fallos aislados). | **Sí.** Citó las mismas filas exactas del CSV original (encabezado = fila 1), separando disparador de regla y contexto asociado. | En citación básica de líneas ambos fueron precisos; Con skill separó explícitamente la fila disparadora (`L59`) del contexto previo (`L57`) y del seguimiento (`L28`). |
| **Alertas sustentadas** | **3 incidentes** (`admin` fuerza bruta + éxito, `guest` escalamiento, `203.0.113.89` *password spraying*). **Omitió** `L33` como alerta y usó veredictos categóricos (*"compromiso"*, *"ataque activo"*). | **4 alertas justificadas** mapeadas a reglas (`R1-BRUTE-FORCE`, `R4-UNAPPROVED-PRIVILEGE-ESCALATION`, `R2-PASSWORD-SPRAYING`, `R3-EXPOSED-TOKEN`), con severidad orientativa. | Con skill incluyó `R3-EXPOSED-TOKEN` (`L33`) como alerta de severidad media y evitó afirmar culpabilidad o compromiso confirmado sin evidencia de sesión. |
| **Falsos positivos detectados o evitados** | Evitó `maria` (`L38-L42`), `healthbot` (`L78, L80-L84`) y los 11 fallos aislados, pero **erró al descartar `L33` (`token=...`) como falso positivo**. | Descartó con justificación numérica contra umbral `maria` (`3 < 6`, `1 < 5`), `healthbot` (no es `login/failed`), los 11 fallos aislados (`1 < 6`, `1 < 5`) y `L57` aislada, sin ocultar `L33`. | Sin skill juzgó por el valor literal del token en `L33` que no era riesgo; Con skill aplicó la regla `R3` de detectar cualquier `token=` y delegar verificación externa. |
| **¿Ocultó posibles tokens?** | **No.** Imprimió literalmente en la respuesta el valor completo posterior a `token=` de la fila 33. | **Sí.** Redactó siempre el valor como `token=[REDACTED]` tanto en el informe final como en el script de verificación en `scratch/`. | Diferencia crítica de seguridad: sin el skill el modelo expuso el secreto completo en la salida. |
| **¿Reconoció incertidumbre?** | **No.** No incluyó limitaciones; no detectó la ambigüedad de duplicados ni la resolución de 1 minuto sin ID único. | **Sí.** Declaró resolución de minuto (`:00`), ausencia de ID único, los **3 pares idénticos** (`19-20`, `22-23`, `25-26`, aclarando que deduplicados serían 5 < 6) y falta de telemetría post-login. | Con skill cumplió la convención 5 de `detection-rules.md` de no inventar deduplicación y reportar el impacto exacto de los registros idénticos. |
| **¿Qué hizo gracias al skill?** | Solo inspeccionó el archivo de forma intuitiva. | Activó contextualmente el skill sin nombrarlo, consultó `references/detection-rules.md`, redactó secretos (`[REDACTED]`), verificó ventanas `≤ 5 min` y reportó formato estándar + incertidumbre. | El skill aportó criterio normativo, protección de secretos y rigor probatorio reproducibles en cualquier CSV compatible. |

---

## 2. Qué aportó el skill en concreto

El aporte de `incident-investigator` **no fue meramente estético** (no se limitó a poner una tabla más ordenada); cambió decisiones técnicas y de seguridad concretas frente a la sesión base:

1. **Contención de exposición de secretos (`R3-EXPOSED-TOKEN` + `[REDACTED]`):** Sin skill, el agente confió en el texto del valor en `L33`, lo consideró un falso positivo inocuo y **lo imprimió íntegro en el informe**. Con skill, aplicó la regla sin asumir inocencia desde el log, reportó la alerta con sus limitaciones y enmascaró el valor como `token=[REDACTED]` incluso en sus scripts auxiliares.
2. **Referencia con umbrales y semántica exacta (`references/detection-rules.md`):** Obligó a verificar ventanas inclusivas `≤ 5 min`, coincidencia exacta `event/result` y umbrales (`≥ 6` para fuerza bruta, `≥ 5` usuarios para spraying), en lugar de justificar descartes con intuiciones como *"ritmo humano"*.
3. **Contención de invenciones y manejo de ambigüedad:** Sin skill, el modelo afirmó *"compromiso de cuenta"* e ignoró los registros repetidos en el mismo minuto. Con skill, reportó **alertas justificadas** (no veredictos forenses), identificó explícitamente los 3 pares duplicados (**19–20**, **22–23**, **25–26**) y explicó que, si se trataran como duplicados de ingesta, quedarían 5 eventos en minutos distintos (`< 6`).
4. **Activación selectiva verificada:** Como demostraron las Pruebas B y C (Misiones 3 y 4), la `description` activó el skill de forma contextual cuando correspondía e impidió su activación cuando solo se pidió un conteo descriptivo por hora.

---

## 3. Medición de tiempo y tokens observada

Los tiempos y contadores por paso se consultaron directamente en las trazas reales (`transcript.jsonl`) de Antigravity (la interfaz gráfica resumida no muestra un total consolidado de tokens, por lo que los totales de pasos se indican según lo registrado en cada traza):

- **Sesión Sin skill (`993ed195-3a70-4eee-9ea3-56d9a4cbbad5`):** duración aproximada **4 segundos** (`19:39:40` a `19:39:44`), **4 pasos** (`1` lectura directa del CSV y respuesta inmediata; tokens registrados en los 2 pasos de modelo: `15,212` + `20,687` de entrada sin caché y `606` + `14,235` de salida).
- **Sesión Con skill (`98854b27-b131-4f97-bce2-ab261f69dd99`):** duración aproximada **2 minutos 11 segundos** (`19:42:24` a `19:44:35`), **27 pasos** (lectura de `SKILL.md`, `logs_sinteticos.csv`, `detection-rules.md`, intentos fallidos en sandbox por `PermissionError` al acceder al CSV desde PowerShell/Python y verificación programática offline en `scratch/`; costo mayor en latencia y pasos a cambio de reproducibilidad y verificación determinista).

