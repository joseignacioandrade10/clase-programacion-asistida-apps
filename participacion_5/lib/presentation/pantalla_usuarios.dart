import 'package:flutter/material.dart';
import '../domain/entities/usuario.dart';
import '../domain/usecases/obtener_usuarios_con_vocal.dart';

class PantallaUsuarios extends StatefulWidget {
  final ObtenerUsuariosConVocal casoDeUso;

  const PantallaUsuarios({super.key, required this.casoDeUso});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  List<Usuario> _usuarios = [];
  bool _cargando = true;
  String _mensajeError = '';

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    try {
      final usuariosObtenidos = await widget.casoDeUso.call();
      setState(() {
        _usuarios = usuariosObtenidos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _mensajeError = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios (Capas)'),
        backgroundColor: Colors.blueGrey,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _mensajeError.isNotEmpty
              ? Center(child: Text(_mensajeError))
              : ListView.builder(
                  itemCount: _usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = _usuarios[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(usuario.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(usuario.email),
                    );
                  },
                ),
    );
  }
}