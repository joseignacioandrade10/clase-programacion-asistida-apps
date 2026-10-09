import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sesion_provider.dart';
// Esta importación marcará error hasta que hagamos la Parte 8
import 'pantalla_usuarios.dart'; 

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final _correoCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();

  // Función auxiliar para navegar si el login/registro fue exitoso
  void _revisarNavegacion() {
    final sesion = context.read<SesionProvider>();
    if (sesion.idUsuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaUsuarios()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos watch aquí para que el build se vuelva a ejecutar si cambia cargando o error
    final sesion = context.watch<SesionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso / Registro')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _correoCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _claveCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre (solo para Crear cuenta)'),
            ),
            const SizedBox(height: 20),
            
            // Mostrar error en rojo si existe
            if (sesion.error != null) ...[
              Text(
                sesion.error!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
            ],

            // Si está cargando, mostramos el indicador y ocultamos los botones
            if (sesion.cargando)
              const CircularProgressIndicator()
            else ...[
              ElevatedButton(
                onPressed: () async {
                  // Usamos read en los botones para disparar la acción
                  await context.read<SesionProvider>().ingresar(
                    _correoCtrl.text.trim(),
                    _claveCtrl.text.trim(),
                  );
                  if (mounted) _revisarNavegacion();
                },
                child: const Text('Ingresar'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  await context.read<SesionProvider>().registrar(
                    _correoCtrl.text.trim(),
                    _claveCtrl.text.trim(),
                    _nombreCtrl.text.trim(),
                  );
                  if (mounted) _revisarNavegacion();
                },
                child: const Text('Crear cuenta'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _correoCtrl.dispose();
    _claveCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }
}