"""Servidor MCP Detective para investigación de incidentes de seguridad.

Expone tres herramientas para listar casos, consultar eventos de un caso
y registrar alertas en memoria.
"""

import json
from pathlib import Path
from mcp.server import MCPServer

# Ruta hacia casos.json resuelta desde la ubicación de este archivo (__file__)
RUTA_CASOS = Path(__file__).resolve().parent / "casos.json"

# Niveles de severidad permitidos para las alertas
NIVELES_PERMITIDOS = {"bajo", "medio", "alto"}

# Almacenamiento en memoria para las alertas (se reinicia al reiniciar el servidor)
_alertas: dict[str, dict] = {}


def cargar_casos(ruta_archivo: Path | str | None = None) -> dict:
    """Carga el archivo casos.json desde la ruta resuelta a partir de __file__."""
    ruta = Path(ruta_archivo) if ruta_archivo is not None else RUTA_CASOS
    if not ruta.is_file():
        raise FileNotFoundError(f"No se encontró el archivo de casos en: {ruta}")
    with open(ruta, "r", encoding="utf-8") as archivo:
        return json.load(archivo)


def reiniciar_alertas() -> None:
    """Limpia el almacenamiento en memoria de las alertas (útil para pruebas)."""
    _alertas.clear()


def obtener_alertas() -> dict[str, dict]:
    """Retorna una copia de las alertas actualmente almacenadas en memoria."""
    return dict(_alertas)


def logica_listar_casos(casos: dict | None = None) -> list[dict]:
    """Retorna el id, sistema y cantidad de eventos de cada caso sin conclusiones."""
    if casos is None:
        casos = cargar_casos()

    return [
        {
            "id": caso_id,
            "sistema": datos.get("sistema", ""),
            "cantidad_eventos": len(datos.get("eventos", [])),
        }
        for caso_id, datos in casos.items()
    ]


def logica_consultar_eventos(caso_id: str, casos: dict | None = None) -> list[dict]:
    """Retorna la lista de eventos exactos del caso especificado.

    Lanza ValueError si el caso no existe en casos.json.
    """
    if not isinstance(caso_id, str):
        raise ValueError("El identificador del caso debe ser una cadena de texto.")

    if casos is None:
        casos = cargar_casos()

    if caso_id not in casos:
        raise ValueError(f"El caso '{caso_id}' no existe en el sistema.")

    return list(casos[caso_id].get("eventos", []))


def logica_registrar_alerta(
    caso_id: str,
    nivel: str,
    motivo: str,
    casos: dict | None = None,
    alertas: dict[str, dict] | None = None,
) -> dict:
    """Guarda una alerta en memoria validando existencia del caso, nivel y motivo.

    Rechaza duplicados si ya existe una alerta para el caso.
    """
    if casos is None:
        casos = cargar_casos()

    if alertas is None:
        alertas = _alertas

    # 1. Validación de caso_id
    if not isinstance(caso_id, str) or not caso_id.strip():
        raise ValueError("El identificador del caso es inválido o no puede estar vacío.")

    if caso_id not in casos:
        raise ValueError(
            f"El caso '{caso_id}' no existe en el sistema. No se puede registrar la alerta."
        )

    # 2. Validación de duplicados (una única alerta por caso)
    if caso_id in alertas:
        raise ValueError(f"Ya existe una alerta registrada para el caso '{caso_id}'.")

    # 3. Validación de nivel (exclusivamente bajo, medio o alto)
    if not isinstance(nivel, str) or nivel not in NIVELES_PERMITIDOS:
        raise ValueError(
            f"Nivel de alerta inválido: '{nivel}'. Debe ser exclusivamente 'bajo', 'medio' o 'alto'."
        )

    # 4. Validación de motivo (debe tener al menos un carácter no blanco)
    if not isinstance(motivo, str) or not motivo.strip():
        raise ValueError(
            "El motivo no puede estar vacío ni contener solo espacios en blanco."
        )

    registro = {
        "caso_id": caso_id,
        "nivel": nivel,
        "motivo": motivo,
        "estado": "registrada",
    }

    alertas[caso_id] = registro
    return registro


# Instancia del servidor MCP
mcp = MCPServer("MCP Detective")


@mcp.tool()
def listar_casos() -> list[dict]:
    """Lista los casos disponibles con su id, sistema y cantidad de eventos. Sin conclusiones."""
    return logica_listar_casos()


@mcp.tool()
def consultar_eventos(caso_id: str) -> list[dict]:
    """Consulta los eventos exactos de un caso. Lanza ValueError si el caso no existe."""
    return logica_consultar_eventos(caso_id)


@mcp.tool()
def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict:
    """Registra una alerta en memoria para un caso si cumple con todas las validaciones.

    Rechaza duplicados y valida que el nivel sea bajo, medio o alto y el motivo no sea vacío.
    """
    return logica_registrar_alerta(caso_id, nivel, motivo)


if __name__ == "__main__":
    mcp.run(transport="stdio")

