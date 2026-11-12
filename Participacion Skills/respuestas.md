# Respuestas — Misión 6

## 1. Skill frente a plugin

**¿Por qué `incident-investigator` es un skill?**
Porque solo contiene instrucciones reutilizables (`SKILL.md`) y conocimiento de dominio (`references/detection-rules.md`) que el agente carga bajo demanda cuando necesita investigar un CSV de logs. No levanta servicios externos ni ejecuta scripts automáticos ante eventos del sistema; únicamente le enseña al agente cuándo activarse, qué pasos seguir, qué reglas aplicar y cómo entregar la evidencia.

**¿Qué otros componentes podrían empaquetarse para distribuirlo como plugin?**
En mi plataforma (Antigravity), un plugin sirve para empaquetar varias piezas juntas en una sola carpeta instalable y compartible:
- **Manifiesto (`plugin.json`):** declara el nombre y los metadatos del plugin para poder instalarlo, activarlo o desactivarlo como una unidad.
- **El skill (`skills/incident-investigator/`):** el `SKILL.md` junto con `references/detection-rules.md` (y scripts opcionales si hubiera).
- **Reglas (`rules/AGENTS.md`):** reglas generales que se cargan con el plugin, por ejemplo para recordar en todo el proyecto que nunca se deben modificar los CSV originales ni consultar IPs por red.
- **Hooks (`hooks.json`):** automatizaciones ante eventos del ciclo de vida del agente, por ejemplo revisar automáticamente la salida antes de guardarla para bloquear cualquier `token=` que no haya quedado como `[REDACTED]` o verificar que el CSV siga intacto.
- **MCP (`mcp_config.json`):** la configuración para conectar un servidor MCP local (por ejemplo, el servidor `mcp-detective` para listar casos, consultar eventos y registrar alertas estructuradas).

---

## 2. Ralph Loop

Si quisiéramos repetir el análisis para corregir fallos detectados automáticamente sin fabricar evidencia nueva, el bucle funcionaría así:

1. **Ejecución inicial:** el agente analiza `logs_sinteticos.csv` aplicando `incident-investigator` y genera un borrador de `hallazgos.md`.
2. **Comprobaciones verificables (automáticas):** al terminar cada intento, se corren chequeos objetivos sobre el informe generado y el CSV original:
   - Que no exista ningún valor real después de `token=` (todo token debe aparecer como `token=[REDACTED]`).
   - Que todos los números de fila citados existan en `logs_sinteticos.csv` (dentro de las filas `2` a `94`) y coincidan con la IP, usuario y evento reportados.
   - Que la tabla tenga todas las columnas requeridas y que no se hayan omitido las exclusiones obligatorias (los 3 fallos aislados y los `healthcheck`) ni las limitaciones de duplicados.
   - Que `logs_sinteticos.csv` siga sin cambios (mismo contenido/hash).
3. **Reintento acotado (máximo 3 iteraciones) sin inventar datos:** si alguna comprobación falla, se le pasa al agente únicamente la lista puntual de errores encontrados para que vuelva a revisar el CSV original y `references/detection-rules.md` y corrija solo lo que falló (por ejemplo, redactar un token olvidado o corregir una fila mal citada), prohibiendo agregar eventos o suposiciones que no estén literalmente en las filas del archivo.
4. **Criterio de parada explícito:** el ciclo se detiene en cuanto **todas las comprobaciones pasan**, o al llegar a la **iteración 3**, lo que ocurra primero. Si tras la tercera iteración todavía falla alguna verificación, el proceso se detiene igual y reporta exactamente qué chequeo no pasó para revisarlo manualmente.

