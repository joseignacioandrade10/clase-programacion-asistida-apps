import 'package:flutter/material.dart';

void main() {
  runApp(const MiAppContador());
}

class MiAppContador extends StatelessWidget {
  const MiAppContador({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador con Imagen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PantallaContador(),
    );
  }
}

class PantallaContador extends StatefulWidget {
  const PantallaContador({super.key});

  @override
  State<PantallaContador> createState() => _PantallaContadorState();
}

class _PantallaContadorState extends State<PantallaContador> {
  int _contador = 0;
  int _imageSeed = 0; // Usado para forzar que la imagen aleatoria cambie

  // URL de la imagen actual
  final String _urlImagen = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ9nOQJ-ZLU_OoJPxLNRVWoTNvrABpYlzc4G_9gtvwTw&s';

  // Función para abrir la imagen completamente en una ventana emergente dentro de la app
  void _mostrarImagenCompleta(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              // La imagen ocupando gran parte de la pantalla
              Center(
                child: InteractiveViewer(
                  // Permite hacer zoom con los dedos si se desea
                  child: Image.network(
                    _urlImagen,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Botón para cerrar la vista de la imagen
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra la "pestaña" emergente
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para sumar
  void _sumar() {
    setState(() {
      _contador++;
      _imageSeed++;
    });
  }

  // Función para restar
  void _restar() {
    setState(() {
      _contador--;
      _imageSeed++;
    });
  }

  // Función para reiniciar
  void _reiniciar() {
    setState(() {
      _contador = 0;
      _imageSeed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Interactivo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Imagen normal en el centro (al tocarla también se abre completa)
              GestureDetector(
                onTap: () => _mostrarImagenCompleta(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _urlImagen,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 250,
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botón para abrir la imagen completamente en una nueva "pestaña" de la app
              ElevatedButton.icon(
                onPressed: () => _mostrarImagenCompleta(context),
                icon: const Icon(Icons.fullscreen),
                label: const Text('Abrir Imagen Completa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[100],
                ),
              ),

              const SizedBox(height: 30),
              
              // Texto del contador
              const Text(
                'Valor actual:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '$_contador',
                style: const TextStyle(
                  fontSize: 60, 
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 40),

              // Fila con los 3 botones principales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón de Restar
                  FloatingActionButton(
                    onPressed: _restar,
                    tooltip: 'Restar',
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                  
                  // Botón de Reset
                  ElevatedButton.icon(
                    onPressed: _reiniciar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),

                  // Botón de Sumar
                  FloatingActionButton(
                    onPressed: _sumar,
                    tooltip: 'Sumar',
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}