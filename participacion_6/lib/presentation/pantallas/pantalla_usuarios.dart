import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/perfiles_provider.dart';
import '../providers/sesion_provider.dart';
import 'pantalla_ingreso.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  @override
  void initState() {
    super.initState();
    // Llamamos a cargar() justo después de que se construya el widget para evitar errores de estado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerfilesProvider>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios del provider de perfiles
    final perfilesState = context.watch<PerfilesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Volver a cargar la lista manualmente
              context.read<PerfilesProvider>().cargar();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Cerrar sesión y regresar a la pantalla de ingreso
              await context.read<SesionProvider>().salir();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaIngreso()),
                );
              }
            },
          ),
        ],
      ),
      body: _construirCuerpo(perfilesState),
    );
  }

  Widget _construirCuerpo(PerfilesProvider state) {
    if (state.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.perfiles.isEmpty) {
      return const Center(child: Text('Aún no hay usuarios registrados.'));
    }

    return ListView.builder(
      itemCount: state.perfiles.length,
      itemBuilder: (context, index) {
        final perfil = state.perfiles[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(perfil.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
          // Convertimos la fecha a un formato legible básico
          subtitle: Text('Miembro desde: ${perfil.creadoEn.toLocal().toString().split(' ')[0]}'),
        );
      },
    );
  }
}