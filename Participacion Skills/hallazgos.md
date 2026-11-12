# Hallazgos de Investigación — `logs_sinteticos.csv`

Informe generado aplicando el Agent Skill [`incident-investigator`](incident-investigator/SKILL.md) y su referencia [`references/detection-rules.md`](incident-investigator/references/detection-rules.md) en modo estrictamente offline y de solo lectura sobre [`logs_sinteticos.csv`](logs_sinteticos.csv).

---

## 1. Alcance y verificación del esquema

- **Archivo analizado:** `logs_sinteticos.csv` (original, sin modificaciones).
- **Total de líneas:** **94** líneas (fila **1** de encabezado + **93** registros de eventos en las filas **2–94**, sin filas malformadas ni campos faltantes).
- **Columnas confirmadas (fila 1):** `timestamp`, `ip`, `user`, `event`, `result`, `detail`.
- **Rango temporal observado:** `2026-11-05T01:01:00-05:00` (fila 2) a `2026-11-05T02:29:00-05:00` (filas 93–94), ya ordenado cronológicamente con granularidad de 1 minuto (`:00`).
- **Conteo verificado por `event/result`:** 56 `login/success`, 28 `login/failed`, 6 `healthcheck/success`, 1 `debug/warning`, 1 `access/denied` y 1 `role_change/success` (total = 93 registros).

---

## 2. Tabla de alertas justificadas

| Alerta | Severidad orientativa | Regla | Timestamp | IP | Usuario | Filas / evidencia | Limitaciones |
|---|---|---|---|---|---|---|---|
| Fuerza bruta probable contra `admin` seguida de inicio de sesión exitoso | **Alta** | `R1-BRUTE-FORCE` | `2026-11-05T01:14:00-05:00` – `2026-11-05T01:18:00-05:00` (fallos); `2026-11-05T01:19:00-05:00` (éxito posterior) | `198.51.100.77` | `admin` | **8** eventos `login/failed` (`incorrect password`) en las filas **17, 19, 20, 22, 23, 25, 26, 27** dentro de una ventana de 4 minutos (≤ 5 min). **Seguimiento separado (`login/success` ≤ 5 min):** fila **28** (`01:19:00-05:00`, `detail=login after multiple failures`), 1 minuto después del último fallo. | Los pares **19–20** (`01:15:00`), **22–23** (`01:16:00`) y **25–26** (`01:17:00`) son idénticos en los 6 campos sin sub-segundos ni ID de evento; se cuentan las 8 filas tal como figuran, pero no es posible distinguir desde el CSV si son reintentos reales en el mismo minuto o duplicados de ingesta (en minutos distintos serían 5). Tampoco constan acciones posteriores de la sesión tras la fila 28. |
| Token potencialmente expuesto en registro de depuración | **Media** | `R3-EXPOSED-TOKEN` | `2026-11-05T01:27:00-05:00` | `192.0.2.44` | `api_service` | Fila **33**: evento `debug/warning` con `detail=token=[REDACTED]; debug output` (coincidencia de `token=`). | El registro evidencia la presencia de `token=` en depuración, pero por sí solo no confirma si es de prueba o productivo, si sigue vigente ni quién tuvo acceso a los logs; requiere revisión externa y rotación si aplica. |
| Escalada de rol exitosa con `approved=false` | **Alta** | `R4-UNAPPROVED-PRIVILEGE-ESCALATION` | `2026-11-05T01:50:00-05:00` (contexto previo: `01:49:00-05:00`) | `203.0.113.42` | `guest` | Fila **59**: evento `role_change/success` con `detail=role=user->admin; approved=false`. **Contexto relacionado (no dispara regla por sí solo):** fila **57** (`01:49:00-05:00`, misma IP y usuario) con `access/denied` sobre `resource=/admin`. | El log únicamente muestra que `role_change/success` ocurrió con `approved=false`; no permite inferir culpabilidad, intención ni qué componente o mecanismo autorizó la operación. No hay eventos `login` previos ni acciones posteriores para `guest` o `203.0.113.42`. |
| Password spraying probable contra múltiples cuentas (sin éxito observado) | **Media** | `R2-PASSWORD-SPRAYING` | `2026-11-05T02:01:00-05:00` – `2026-11-05T02:03:00-05:00` | `203.0.113.89` | `ana`, `carlos`, `luisa`, `diego`, `maria`, `sofia` (6 cuentas distintas) | **6** eventos `login/failed` (`incorrect password`) contra **6 usuarios distintos** en una ventana de 2 minutos (≤ 5 min): filas **67** (`ana`), **68** (`carlos`), **70** (`luisa`), **71** (`diego`), **73** (`maria`) y **74** (`sofia`). No aparece ningún `login/success` desde `203.0.113.89`. | Resolución temporal de 1 minuto y ausencia de contexto externo de red/proxy. Los `login/success` cercanos de algunos de esos usuarios (filas 69, 72, 75–77) corresponden a otras IPs (`192.0.2.10`, `192.0.2.11`, `192.0.2.13`). |

---

## 3. Falsos positivos y actividad normal evaluada

### Por qué los 3 fallos aislados NO son una alerta de fuerza bruta
- **Evidencia en el CSV:** filas **38** (`01:35:00`), **39** (`01:36:00`) y **41** (`01:37:00`) desde la IP `192.0.2.25` para el usuario `maria` (`login/failed`, `detail=mistyped password`), seguidas de la fila **42** (`01:38:00`, `login/success`, `detail=legitimate user`).
- **Justificación según las reglas (`FP-EXCLUSIONS`):**
  1. Para activar **`R1-BRUTE-FORCE`**, se requieren **6 o más** eventos `login/failed` desde la misma IP hacia el mismo usuario en ≤ 5 minutos. Aquí solo existen **3** fallos (`3 < 6`), por lo que no alcanzan el umbral de la regla.
  2. Tampoco activan **`R2-PASSWORD-SPRAYING`**, porque todos los intentos apuntan a **1 solo usuario** (`maria`), muy por debajo del umbral de **≥ 5 usuarios distintos** (`1 < 5`).
  3. Aunque van seguidos por un `login/success` en el minuto siguiente (fila 42), el patrón coincide con un error de digitación del usuario legítimo y no con fuerza bruta probable; tratarlo como incidente sería un **falso positivo**.

### Otros descartes verificados
- **Eventos de monitoreo (`healthcheck/success`):** filas **78, 80, 81, 82, 83 y 84** (`02:10:00`–`02:15:00`, IP `192.0.2.200`, usuario `healthbot`, `detail=scheduled monitoring`). Aunque suman 6 eventos en 5 minutos, su combinación exacta es `healthcheck/success` y **no** `login/failed`, por lo que se excluyen de `R1` y `R2` como actividad operativa programada.
- **Fallos `login/failed` puntuales en IPs ordinarias (`192.0.2.10`–`192.0.2.13`):**
  - `192.0.2.10`: fila **14** (`carlos`, `01:12`), fila **34** (`maria`, `01:28`), fila **60** (`diego`, `01:53`, con éxito en fila **61** a las `01:54`).
  - `192.0.2.11`: fila **3** (`sofia`, `01:02`), fila **46** (`diego`, `01:43`), fila **87** (`maria`, `02:24`, con éxito en fila **88** a las `02:24`).
  - `192.0.2.12`: fila **7** (`luisa`, `01:05`), filas **24** (`01:17`) y **31** (`01:25`, ambas `maria`, separadas por 8 min > 5 min), fila **51** (`carlos`, `01:47`, con éxito en fila **53** a las `01:47`).
  - `192.0.2.13`: fila **47** (`luisa`, `01:45`).
  - Ninguna de estas IPs supera 1 fallo en ninguna ventana de 5 minutos, por lo que no alcanzan `R1` ni `R2`.
- **Resto de actividad ordinaria:** los **54** eventos `login/success` restantes (además de las filas **28** y **42** ya contextualizadas) corresponden a tráfico normal (`ordinary login`).

---

## 4. Verificación manual contra las filas originales de `logs_sinteticos.csv`

Para no confiar únicamente en el resumen del modelo, se contrastaron manualmente las alertas directamente con las líneas crudas del archivo original `logs_sinteticos.csv`:

1. **Verificación de `R1-BRUTE-FORCE` (filas 17, 19, 20, 22, 23, 25, 26, 27 y seguimiento en fila 28):**
   ```text
   17: 2026-11-05T01:14:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   19: 2026-11-05T01:15:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   20: 2026-11-05T01:15:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   22: 2026-11-05T01:16:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   23: 2026-11-05T01:16:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   25: 2026-11-05T01:17:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   26: 2026-11-05T01:17:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   27: 2026-11-05T01:18:00-05:00,198.51.100.77,admin,login,failed,incorrect password
   28: 2026-11-05T01:19:00-05:00,198.51.100.77,admin,login,success,login after multiple failures
   ```
   Confirmado manualmente: 8 `login/failed` entre `01:14:00` y `01:18:00` (4 min ≤ 5 min), seguidos por `login/success` en la fila 28 a las `01:19:00` (1 min después), y se verificó también la duplicidad literal de los pares 19–20, 22–23 y 25–26.

2. **Verificación de `R4-UNAPPROVED-PRIVILEGE-ESCALATION` (filas 57 y 59) y `R3-EXPOSED-TOKEN` (fila 33, redactada):**
   ```text
   33: 2026-11-05T01:27:00-05:00,192.0.2.44,api_service,debug,warning,token=[REDACTED]; debug output
   57: 2026-11-05T01:49:00-05:00,203.0.113.42,guest,access,denied,resource=/admin
   59: 2026-11-05T01:50:00-05:00,203.0.113.42,guest,role_change,success,role=user->admin; approved=false
   ```

3. **Verificación del falso positivo de 3 fallos aislados (filas 38, 39, 41 y 42):**
   ```text
   38: 2026-11-05T01:35:00-05:00,192.0.2.25,maria,login,failed,mistyped password
   39: 2026-11-05T01:36:00-05:00,192.0.2.25,maria,login,failed,mistyped password
   41: 2026-11-05T01:37:00-05:00,192.0.2.25,maria,login,failed,mistyped password
   42: 2026-11-05T01:38:00-05:00,192.0.2.25,maria,login,success,legitimate user
   ```

---

## 5. Registro fiel de instalación y activación (Pruebas A y B)

- **Instalación/registro en Antigravity:** se registró el skill del workspace mediante `.agents/skills.json` (`{"entries": [{"path": "."}]}`) apuntando al directorio de trabajo donde reside `incident-investigator/SKILL.md`.
- **Prueba A — Activación explícita (`evidencias/activacion_explicita.png`, sesión `d248ea81-9981-4f85-ac25-e6b82904e056`):**
  - **Lo observado:** en la captura expandida del panel de herramientas y en la traza real `transcript.jsonl`, el agente invocó `read_file` sobre `incident-investigator/SKILL.md` (líneas 1–88), luego sobre `incident-investigator/references/detection-rules.md` (líneas 1–61) y finalmente sobre `logs_sinteticos.csv` (líneas 1–94).
  - **Nota metodológica observada:** en esa corrida `SKILL.md` estaba abierto como `Active Document` en el editor; además, los comandos PowerShell del sandbox fallaron por permisos (`PermissionError`), por lo que el agente validó el archivo leyendo directamente el CSV completo.
- **Prueba B — Activación contextual sin nombrar el skill (`evidencias/activacion_contextual.png`, sesión `8b964b75-644a-452b-8b08-54f732bd1c79`):**
  - **Lo observado:** con `SKILL.md` fuera de `Active Document` y sin mencionarlo en el prompt, el agente decidió activar el skill por su `description`, ejecutando `read_file` sobre `incident-investigator/SKILL.md`, `incident-investigator/references/detection-rules.md` y `logs_sinteticos.csv`, produciendo las mismas 4 alertas justificadas y exclusiones. *(En el resumen textual de la Prueba B indicó "52 registros `login/success` restantes", mientras que el conteo exacto verificado fila a fila es 54 restantes + fila 28 + fila 42 = 56 `login/success` totales; esto confirma la importancia de verificar los conteos manualmente contra el CSV.)*

---

## 6. Incertidumbre y limitaciones generales

- **Resolución temporal de 1 minuto y duplicados:** todas las marcas de tiempo terminan en `:00` segundos y no hay identificador único por evento; en `198.51.100.77` existen 3 pares de filas idénticas (19–20, 22–23, 25–26) cuya naturaleza (reintento en el mismo minuto vs. duplicación de registro) no puede confirmarse desde el CSV.
- **Sin contexto externo ni acceso a red:** todas las IP pertenecen a rangos RFC 5737 reservados para documentación (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`) y se tratan como identificadores sintéticos.
- **Alcance de los hallazgos:** los resultados corresponden a **alertas justificadas** según las reglas definidas, no a conclusiones forenses definitivas ni atribución de culpabilidad.

