---
name: incident-investigator
description: >-
  Investiga incidentes de seguridad en archivos CSV de logs de autenticación y
  eventos del sistema (columnas timestamp, ip, user, event, result, detail) para
  detectar fuerza bruta, password spraying, cambios de rol no aprobados y
  posibles tokens expuestos, diferenciando alertas justificadas de falsos
  positivos con evidencia por número de fila. Usar únicamente cuando se pida
  revisar o investigar logs en busca de actividad sospechosa, anomalías de
  acceso, secretos expuestos o señales de seguridad. NO activar para conteos
  descriptivos simples (por ejemplo, eventos por hora o totales), gráficos ni
  consultas estadísticas sin investigación de incidentes ni clasificación de
  amenazas.
---

# Incident Investigator

Skill reutilizable para investigar incidentes de seguridad en archivos CSV de logs compatibles, aplicando reglas deterministas de dominio y reportando alertas justificadas con trazabilidad por fila.

## Cuándo activar y cuándo NO activar

### Activar cuando
- Se solicite investigar un CSV de logs para identificar incidentes de seguridad o señales sospechosas.
- Se pregunte por intentos de acceso anómalos, fuerza bruta, password spraying, escaladas o cambios de rol no aprobados, o posibles secretos/tokens expuestos.
- Se pida distinguir actividad normal o falsos positivos frente a alertas de seguridad con evidencia por fila.

### NO activar cuando
- Se soliciten únicamente conteos descriptivos o agregaciones estadísticas (por ejemplo, cantidad de eventos por hora, totales por usuario o resúmenes de volumen) **sin** investigación de incidentes ni clasificación de amenazas.
- Se pidan conversiones de formato, filtros visuales o gráficas descriptivas sin análisis de seguridad.

## Cuándo abrir `references/detection-rules.md`

Debes abrir y leer [references/detection-rules.md](./references/detection-rules.md) **obligatoriamente antes de evaluar registros o clasificar cualquier evento** cada vez que investigues un archivo CSV compatible.

- Este `SKILL.md` define el flujo de trabajo, los límites operativos y el formato de entrega.
- [references/detection-rules.md](./references/detection-rules.md) contiene los umbrales exactos, la semántica de ventanas temporales, las convenciones de coincidencia exacta y los criterios de falsos positivos.
- Nunca apliques umbrales ni exclusiones de memoria sin consultar primero esa referencia.

## Procedimiento de investigación

1. **Inspeccionar el CSV sin modificarlo**
   - Trabaja siempre en modo solo lectura sobre el archivo original.
   - Verifica la fila 1 (encabezado) y confirma la existencia de las columnas esperadas: `timestamp`, `ip`, `user`, `event`, `result`, `detail`.
   - Conserva el número de fila del CSV original como identificador de evidencia (**encabezado = fila 1**, primer registro = fila 2).
   - Si el archivo no tiene las columnas requeridas o presenta filas malformadas, detén la evaluación de las reglas afectadas y documenta la limitación.

2. **Consultar las reglas de dominio**
   - Lee [references/detection-rules.md](./references/detection-rules.md) en su totalidad antes de contar eventos o definir alertas.

3. **Ordenar y analizar evidencias**
   - Ordena lógicamente los registros por `timestamp` antes de evaluar ventanas temporales, manteniendo adherido a cada registro su **número de fila original**.
   - Utiliza herramientas locales del entorno (lectura de archivos o análisis determinista offline en solo lectura) para verificar cada coincidencia contra las filas reales del CSV; no estimes conteos ni ventanas a ojo.
   - Aplica coincidencia exacta en `event` y `result`, y ventanas temporales inclusivas en ambos extremos según lo especificado en la referencia.

4. **Distinguir alertas justificadas, falsos positivos y hechos confirmados**
   - Clasifica únicamente como **alerta justificada** aquello que cumpla de manera verificable las condiciones de una regla.
   - Evalúa e informa explícitamente los **falsos positivos o actividad normal descartada** (por ejemplo, fallos por debajo del umbral o eventos operativos no pertenecientes a autenticación) indicando por qué no disparan alerta.
   - Distingue siempre entre **hecho observado en el registro** (fila literal) e **inferencia/hipótesis**; no presentes alertas como conclusiones forenses definitivas ni atribuyas culpabilidad.

5. **Redactar la salida estandarizada**
   - Entrega los hallazgos con la estructura definida en la sección **Formato de salida**, citando los números de fila originales exactos.
   - Redacta o enmascara obligatoriamente cualquier posible secreto o token detectado (por ejemplo, `token=[REDACTED]`).

6. **Declarar incertidumbre y limitaciones**
   - Si existen registros duplicados ambiguos (mismo timestamp, IP, usuario, evento, resultado y detalle), timestamps con resolución insuficiente o ausencia de contexto externo al CSV, decláralo explícitamente en la tabla y en la sección de incertidumbre en lugar de inventar reglas de deduplicación o contexto faltante.

## Formato de salida estandarizado

Todo informe producido con este skill debe incluir:

1. **Alcance y verificación del esquema**: archivo analizado, total de filas, rango temporal observado y confirmación de columnas.
2. **Tabla de alertas justificadas**:

| Alerta | Severidad orientativa | Regla | Timestamp | IP | Usuario | Filas / evidencia | Limitaciones |
|---|---|---|---|---|---|---|---|
| Descripción corta del hallazgo | Alta / Media / Baja (orientativa) | ID y nombre de regla | Inicio–fin o timestamp exacto | IP observada | Usuario(s) afectado(s) | Números de fila del CSV original y detalle relevante (tokens redactados) | Ambigüedades, falta de sub-segundos o contexto no verificable |

3. **Falsos positivos y actividad normal evaluada**: lista breve de patrones descartados con sus filas y la razón objetiva (umbral no alcanzado o tipo de evento distinto).
4. **Incertidumbre y limitaciones generales**: restricciones de los datos analizados y advertencia de que los hallazgos son alertas basadas en registros, no atribución ni veredicto forense.

## Seguridad y límites operativos

- **Offline estricto**: no uses red ni realices consultas externas (WHOIS, DNS, geolocalización, APIs) sobre las direcciones IP ni sobre ningún campo del CSV.
- **IPs de documentación**: trata direcciones reservadas para documentación o entornos sintéticos como simples identificadores del registro, nunca como infraestructura real.
- **Cero invenciones**: no fabriques filas, timestamps, eventos ni intenciones. Toda afirmación debe apuntar a filas verificadas del CSV analizado.
- **Protección de secretos**: nunca imprimas el valor completo de un token o credencial detectada en el campo `detail`; reemplázalo siempre por `[REDACTED]`.
- **Integridad del material**: nunca modifiques el archivo CSV original ni generalices hallazgos específicos de un archivo como si fueran reglas universales.

