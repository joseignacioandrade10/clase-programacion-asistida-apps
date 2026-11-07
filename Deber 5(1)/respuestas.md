# Respuestas — Deber 5: MCP Detective

**Estudiante:** José Ignacio Andrade  
**Materia:** Programación Asistida de Aplicaciones · USFQ  
**Agente utilizado:** Antigravity (Google DeepMind)

---

## 1. Arquitectura

- **LLM (Modelo de Lenguaje):** Razona sobre las instrucciones en lenguaje natural del usuario, decide qué herramienta MCP es adecuada para cada objetivo, formula las llamadas con sus argumentos correspondientes e interpreta los resultados devueltos por el servidor para estructurar la respuesta final. El LLM no ejecuta código de Python directamente ni accede por su cuenta al sistema de archivos.
- **Harness / Host (Entorno del Agente - Antigravity):** Gestiona el ciclo de vida de la sesión, coordina la interacción entre el usuario, el LLM y los subsistemas externos, mantiene el contexto de la conversación y proporciona la infraestructura para que el cliente MCP se comunique con el servidor.
- **Cliente MCP:** Reside dentro del host. Lee la configuración del servidor (`mcp_config.json`), lanza el proceso del servidor mediante el transporte configurado (`stdio`), traduce las peticiones de herramientas formuladas por el modelo en mensajes bajo el protocolo MCP (JSON-RPC) y devuelve las respuestas estructuradas o errores al modelo.
- **Servidor MCP (`server.py`):** Es el proceso local en Python que expone el catálogo de herramientas (`@mcp.tool()`), escucha por `stdio`, deserializa los mensajes, ejecuta las funciones correspondientes (`listar_casos`, `consultar_eventos`, `registrar_alerta`), valida de forma determinista los parámetros y almacena las alertas en memoria.
- **¿Cuál ejecutó realmente Python?:** El **servidor MCP** (el intérprete de Python del sistema operativo donde corre el proceso `server.py`). Ni el LLM ni el cliente ejecutan el código de las herramientas.

---

## 2. Evidencia

**¿Por qué `INC-003` merece investigación, pero los logs no permiten afirmar con certeza que hubo una intrusión?**

- **Por qué merece investigación:** En el caso `INC-003` (panel de administración) se observan cuatro intentos consecutivos de autenticación fallida (`LOGIN_FAILED`) a las 03:00, 03:01, 03:02 y 03:03, seguidos inmediatamente de un acceso exitoso (`LOGIN_SUCCESS`) a las 03:04, todos con el usuario privilegiado `admin` y provenientes de la misma dirección IP (`192.0.2.50`) en horas de la madrugada. Este patrón temporal es característico de un ataque de fuerza bruta o adivinación de credenciales (*credential guessing*) que culmina con éxito.
- **Por qué no se puede afirmar con certeza una intrusión:** Los registros de eventos de autenticación solo reflejan transacciones de red y contraseñas ingresadas, no la intención ni la identidad real de quien opera el teclado. Un patrón idéntico puede originarse por un administrador legítimo que olvidó temporalmente su contraseña y la recordó al quinto intento, una prueba de penetración o auditoría interna autorizada, o un script automatizado de mantenimiento con credenciales recién rotadas. Confirmar una intrusión requiere evidencia complementaria.

---

## 3. Validación y Seguridad

**¿Quién rechaza `INC-999` o los parámetros inválidos, y por qué no es seguro confiar solo en que el modelo genere argumentos correctos?**

- **Quién rechaza los casos inválidos:** El **servidor MCP**, mediante validaciones deterministas programadas en Python. Si se solicita un caso inexistente como `INC-999`, el servidor lanza explícitamente un `ValueError`; asimismo, rechaza niveles fuera de `{"bajo", "medio", "alto"}`, motivos vacíos o alertas duplicadas antes de tocar el estado.
- **Por qué no es seguro confiar solo en el modelo:**
  1. Los LLMs son probabilísticos y no garantizan adherencia estricta a esquemas de datos; pueden alucinar identificadores, alterar formatos o generar valores fuera de rango.
  2. El modelo puede ser manipulado mediante ataques de inyección indirecta de prompts (*indirect prompt injection*), donde texto malicioso incrustado en registros o entradas externas engañe al modelo para ejecutar acciones no deseadas o registrar niveles críticos sin justificación.
  3. En seguridad y arquitectura de software, la lógica del servidor es la frontera de confianza inmutable; la validación debe ser siempre estricta y determinista en el backend.

---

## 4. Configuración y Ejecución

### Ide: Antigravity, Agente: Antigravity

### Dependencias requeridas
```bash
pip install "mcp[cli]>=2,<3" pytest
```

### Ejecución de pruebas con Pytest
```bash
pytest mcp-detective -v
```

### Inspección manual con MCP Inspector
```bash
mcp dev mcp-detective/server.py
```
*(O mediante `npx @modelcontextprotocol/inspector <ruta_python> <ruta_server.py>`)*.

### Conexión del servidor al agente (Antigravity)
En el archivo `~/.gemini/config/mcp_config.json`:
```json
{
  "mcpServers": {
    "mcp-detective": {
      "command": "C:\\Users\\Jose Ignacio\\AppData\\Local\\Programs\\Python\\Python314\\python.exe",
      "args": [
        "C:\\Users\\Jose Ignacio\\Desktop\\USFQ 2026\\Repositorio GIT\\Deber 5(1)\\mcp-detective\\server.py"
      ]
    }
  }
}
```

Al abrir una nueva sesión y solicitar el descubrimiento de herramientas, el agente lista y tiene disponibles `listar_casos`, `consultar_eventos` y `registrar_alerta`.

