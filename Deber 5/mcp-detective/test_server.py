"""Pruebas unitarias para el servidor MCP Detective y su lógica de negocio."""

import sys
from pathlib import Path
import pytest

# Asegurar que el directorio de mcp-detective esté en el sys.path
sys.path.insert(0, str(Path(__file__).resolve().parent))

from server import (
    reiniciar_alertas,
    logica_listar_casos,
    logica_consultar_eventos,
    logica_registrar_alerta,
)


@pytest.fixture(autouse=True)
def limpiar_memoria():
    """Limpia el almacenamiento de alertas antes de cada prueba para evitar efectos secundarios."""
    reiniciar_alertas()
    yield
    reiniciar_alertas()


def test_listar_casos():
    """Verifica que listar_casos devuelve exactamente INC-001, INC-002 e INC-003 con cantidades correctas."""
    casos = logica_listar_casos()
    assert isinstance(casos, list)
    assert len(casos) == 3

    ids = [c["id"] for c in casos]
    assert ids == ["INC-001", "INC-002", "INC-003"]

    conteo_por_id = {c["id"]: c["cantidad_eventos"] for c in casos}
    assert conteo_por_id["INC-001"] == 2
    assert conteo_por_id["INC-002"] == 6
    assert conteo_por_id["INC-003"] == 5

    for c in casos:
        assert "sistema" in c
        assert "id" in c
        assert "cantidad_eventos" in c


def test_consultar_eventos_valido():
    """Verifica la consulta de eventos de un caso válido (INC-002 con seis fallos)."""
    eventos = logica_consultar_eventos("INC-002")
    assert isinstance(eventos, list)
    assert len(eventos) == 6
    for evento in eventos:
        assert evento["usuario"] == "admin"
        assert evento["evento"] == "LOGIN_FAILED"


def test_consultar_eventos_caso_inexistente():
    """Verifica que consultar un caso desconocido (INC-999) lance ValueError explícito."""
    with pytest.raises(ValueError, match="El caso 'INC-999' no existe"):
        logica_consultar_eventos("INC-999")


def test_registrar_alerta_valida():
    """Verifica que se registre correctamente una alerta válida para INC-003."""
    resultado = logica_registrar_alerta(
        caso_id="INC-003",
        nivel="alto",
        motivo="Cuatro intentos fallidos seguidos de un acceso exitoso; requiere revisión",
    )
    assert resultado == {
        "caso_id": "INC-003",
        "nivel": "alto",
        "motivo": "Cuatro intentos fallidos seguidos de un acceso exitoso; requiere revisión",
        "estado": "registrada",
    }


def test_registrar_alerta_duplicada_rechazada():
    """Verifica que no se permita registrar dos alertas para el mismo caso en la misma instancia."""
    logica_registrar_alerta(
        caso_id="INC-003",
        nivel="alto",
        motivo="Primer registro de sospecha",
    )

    with pytest.raises(ValueError, match="Ya existe una alerta registrada para el caso 'INC-003'"):
        logica_registrar_alerta(
            caso_id="INC-003",
            nivel="medio",
            motivo="Intento de duplicación",
        )


def test_registrar_alerta_validaciones_invalidas():
    """Verifica que se rechacen niveles inválidos, motivos vacíos o casos inexistentes."""
    # Nivel inválido
    with pytest.raises(ValueError, match="Nivel de alerta inválido"):
        logica_registrar_alerta("INC-002", "critico", "Intentos repetidos")

    # Motivo en blanco
    with pytest.raises(ValueError, match="El motivo no puede estar vacío"):
        logica_registrar_alerta("INC-002", "medio", "    ")

    # Caso inexistente
    with pytest.raises(ValueError, match="no existe en el sistema"):
        logica_registrar_alerta("INC-999", "bajo", "Caso que no existe")

