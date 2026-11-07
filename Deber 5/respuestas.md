# Respuestas — Deber 5: MCP Detective

**Estudiante:** José Ignacio Andrade  
**Materia:** Programación Asistida de Aplicaciones · USFQ  
**Agente utilizado:** Antigravity (Google DeepMind)

---

## 1. Arquitectura

- **LLM (Modelo de Lenguaje):** Razona sobre la consulta del usuario, decide qué herramientas son necesarias para responder o actuar y formula las llamadas a las tools con sus argumentos (o interpreta los resultados devueltos). No ejecuta código directamente ni accede a los archivos de datos.
- **Harness / Host (Entorno del Agente):** Orquesta la interacción general, gestiona el ciclo de vida de la conversación, conecta al LLM con el cliente MCP y coordina la ejecución de las acciones solicitadas por el modelo.
- **Cliente MCP:** Recibe la solicitud de llamada a una herramienta propuesta por el modelo a través del host, serializa los parámetros en mensajes del protocolo MCP y los envía al servidor a través del transporte configurado (`stdio`). Luego recibe la respuesta o el error del servidor y lo entrega de vuelta al host.
- **Servidor MCP:** Expone el catálogo de herramientas disponibles mediante `@mcp.tool()`, deserializa las peticiones entrantes, ejecuta las funciones Python correspondientes en su proceso local, realiza la validación determinista de los argumentos y almacena el estado en memoria.
- **¿Cuál ejecutó realmente Python?:** El **servidor MCP** (el intérprete de Python local donde corre el proceso `server.py`). Ni el LLM ni el cliente ejecutan el código de la herramienta.

---

## 2. Evidencia

**¿Por qué `INC-003` merece investigación, pero los logs no permiten afirmar con certeza que hubo una intrusión?**

- **Por qué merece investigación:** Muestra cuatro intentos consecutivos de autenticación fallida (`LOGIN_FAILED`) seguidos inmediatamente de un acceso exitoso (`LOGIN_SUCCESS`) con el usuario privilegiado `admin` desde una misma dirección IP (`192.0.2.50`) a las 03:00–03:04 de la madrugada. Este patrón temporal coincide con un intento de fuerza bruta o adivinación de credenciales que culmina en éxito.
- **Por qué no se puede afirmar con certeza una intrusión:** Los logs únicamente registran eventos de red y autenticación, no la intención del usuario. El patrón observado también podría corresponder a un administrador legítimo que olvidó temporalmente su contraseña, a un script de mantenimiento que reintentó antes de usar la credencial correcta, o a una prueba interna autorizada. Para confirmar una intrusión real se requeriría evidencia adicional (ej. correlación con logs de actividad posterior, ubicación de la IP, cambios en el sistema o telemetría de endpoint).

---

## 3. Validación y Seguridad

**¿Quién rechaza `INC-999` o los parámetros inválidos, y por qué no es seguro confiar solo en que el modelo genere argumentos correctos?**

- **Quién rechaza los casos inválidos:** El **servidor MCP**, a través de su código determinista de validación (comprobando existencia del caso en `casos.json`, validando niveles permitidos y verificando motivos no vacíos antes de alterar cualquier estado).
- **Por qué no es seguro confiar en el modelo:**
  1. Los LLMs son probabilísticos y propensos a alucinaciones, omisiones o generación de parámetros fuera de rango o con formatos no esperados.
  2. El modelo podría ser víctima de *prompt injection* indirecto (si un atacante inyecta instrucciones en logs o datos externos procesados por el agente) que intente registrar alertas falsas o niveles no permitidos.
  3. La seguridad y consistencia de los datos nunca debe delegarse a una capa de lenguaje natural; la lógica del servidor es la última y definitiva barrera de defensa.

---

## 4. Configuración y Ejecución

### Instalación de dependencias
```bash
pip install "mcp[cli]>=2,<3" pytest
```

### Ejecución de pruebas automatizadas
```bash
pytest mcp-detective -q
```

### Inspección manual con MCP Inspector
```bash
mcp dev mcp-detective/server.py
```

### Conexión del servidor al agente (configuración MCP por stdio)
En el archivo de configuración de servidores MCP del host/agente:
```json
{
  "mcpServers": {
    "mcp-detective": {
      "command": "python",
      "args": ["<RUTA_ABSOLUTA>/mcp-detective/server.py"]
    }
  }
}
```
*Comprobación de conexión:* Al iniciar el agente y solicitarle listar herramientas disponibles, el agente detecta y lista `listar_casos`, `consultar_eventos` y `registrar_alerta`.

