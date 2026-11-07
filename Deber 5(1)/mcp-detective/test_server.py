"""Pruebas unitarias para el servidor MCP Detective.

Verifica listar_casos, consultar_eventos y registrar_alerta,
incluyendo casos de error y validación determinista.
"""

import pytest
from server import (
    logica_listar_casos,
    logica_consultar_eventos,
    logica_registrar_alerta,
    reiniciar_alertas,
    obtener_alertas,
)


@pytest.fixture(autouse=True)
def limpiar_estado():
    """Asegura que el almacenamiento en memoria esté limpio antes de cada prueba."""
    reiniciar_alertas()
    yield
    reiniciar_alertas()


def test_listar_casos():
    """1. listar_casos() devuelve exactamente INC-001, INC-002 e INC-003 con cantidades correctas."""
    casos = logica_listar_casos()
    ids = [c["id"] for c in casos]
    assert sorted(ids) == ["INC-001", "INC-002", "INC-003"]

    # Validar que no contenga conclusiones y que contenga las cantidades esperadas
    mapeo = {c["id"]: c for c in casos}
    assert mapeo["INC-001"]["cantidad_eventos"] == 2
    assert mapeo["INC-002"]["cantidad_eventos"] == 6
    assert mapeo["INC-003"]["cantidad_eventos"] == 5


def test_consultar_eventos_valido():
    """Verifica que consultar_eventos('INC-002') retorne los 6 fallos de inicio de sesión."""
    eventos = logica_consultar_eventos("INC-002")
    assert len(eventos) == 6
    for ev in eventos:
        assert ev["usuario"] == "admin"
        assert ev["evento"] == "LOGIN_FAILED"


def test_consultar_eventos_desconocido():
    """2. consultar_eventos('INC-999') produce un error explícito (ValueError), no una lista vacía."""
    with pytest.raises(ValueError) as excinfo:
        logica_consultar_eventos("INC-999")
    assert "no existe" in str(excinfo.value).lower()


def test_registrar_alerta_valida():
    """3. registrar_alerta con parámetros válidos registra la alerta correctamente."""
    resultado = logica_registrar_alerta(
        caso_id="INC-003",
        nivel="alto",
        motivo="Cuatro fallos y un acceso exitoso desde la misma IP; requiere investigación",
    )
    assert resultado["caso_id"] == "INC-003"
    assert resultado["nivel"] == "alto"
    assert resultado["estado"] == "registrada"
    assert "Cuatro fallos" in resultado["motivo"]

    # Comprobar que reside en el almacenamiento en memoria
    alertas = obtener_alertas()
    assert "INC-003" in alertas


def test_registrar_alerta_duplicada():
    """4. Un segundo registro del mismo caso, dentro de la misma instancia, se rechaza como duplicado."""
    logica_registrar_alerta(
        caso_id="INC-003",
        nivel="alto",
        motivo="Primera alerta válida",
    )
    with pytest.raises(ValueError) as excinfo:
        logica_registrar_alerta(
            caso_id="INC-003",
            nivel="medio",
            motivo="Segunda alerta para el mismo caso",
        )
    assert "ya existe" in str(excinfo.value).lower()


def test_registrar_alerta_nivel_invalido():
    """Prueba recomendada: registrar_alerta con nivel no permitido ('critico') lanza ValueError."""
    with pytest.raises(ValueError) as excinfo:
        logica_registrar_alerta(
            caso_id="INC-002",
            nivel="critico",
            motivo="Intentos repetidos",
        )
    assert "nivel de alerta inválido" in str(excinfo.value).lower()


def test_registrar_alerta_motivo_en_blanco():
    """Prueba recomendada: motivo en blanco o con solo espacios lanza ValueError."""
    with pytest.raises(ValueError) as excinfo:
        logica_registrar_alerta(
            caso_id="INC-002",
            nivel="medio",
            motivo="   ",
        )
    assert "motivo no puede estar vacío" in str(excinfo.value).lower()

