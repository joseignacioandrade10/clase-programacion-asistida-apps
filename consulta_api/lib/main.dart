import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MiAppApi());
}

class MiAppApi extends StatelessWidget {
  const MiAppApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Consumo de APIs'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person), text: 'Usuarios'),
                Tab(icon: Icon(Icons.sports_soccer), text: 'Fútbol'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              PantallaUsuarios(),
              PantallaFutbol(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PESTAÑA 1: USUARIOS (API JSONPlaceholder)
// ---------------------------------------------------------------------------
class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  String resultado = "Presiona el botón para cargar datos";
  bool cargando = false;

  Future<void> obtenerDatos() async {
    setState(() => cargando = true);
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/users/1');
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final datosJson = jsonDecode(respuesta.body);
        setState(() {
          resultado =
              "Nombre: ${datosJson['name']}\nCorreo: ${datosJson['email']}\nCiudad: ${datosJson['address']['city']}";
        });
      } else {
        setState(() {
          resultado = "Error: Código de estado ${respuesta.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        resultado = "Error al conectar con la API: $e";
      });
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (cargando)
              const CircularProgressIndicator()
            else
              Text(
                resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cargando ? null : obtenerDatos,
              child: const Text('Obtener Datos'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PESTAÑA 2: FÚTBOL (API ScoreBat - 2 Partidos)
// ---------------------------------------------------------------------------
class PantallaFutbol extends StatefulWidget {
  const PantallaFutbol({super.key});

  @override
  State<PantallaFutbol> createState() => _PantallaFutbolState();
}

class _PantallaFutbolState extends State<PantallaFutbol> {
  List<dynamic> partidos = [];
  bool cargando = false;
  String mensaje = "Presiona 'Consultar' para ver los partidos";

  Future<void> consultarPartidos() async {
    setState(() {
      cargando = true;
      mensaje = "";
    });

    try {
      final url = Uri.parse('https://www.scorebat.com/video-api/v3/');
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        final List<dynamic> lista = datos['response'] ?? [];

        setState(() {
          // Tomamos solo los 2 primeros partidos
          partidos = lista.take(2).toList();
        });
      } else {
        setState(() {
          mensaje = "Error: Código ${respuesta.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error al consultar la API de fútbol: $e";
      });
    } finally {
      setState(() => cargando = false);
    }
  }

  // Extrae el link del video del campo embed si existe
  String obtenerLinkVideo(dynamic partido) {
    try {
      final videos = partido['videos'] as List?;
      if (videos != null && videos.isNotEmpty) {
        final embed = videos[0]['embed'] as String? ?? '';
        final match = RegExp(r"src='([^']+)'").firstMatch(embed);
        if (match != null) return match.group(1) ?? '';
      }
    } catch (_) {}
    return partido['matchviewUrl'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: cargando ? null : consultarPartidos,
            icon: const Icon(Icons.search),
            label: const Text('Consultar'),
          ),
          const SizedBox(height: 12),
          if (cargando)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (partidos.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: partidos.length,
                itemBuilder: (context, index) {
                  final partido = partidos[index];
                  final linkVideo = obtenerLinkVideo(partido);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    clipBehavior: Clip.antiAlias,
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video / Miniatura del partido
                        if (partido['thumbnail'] != null)
                          Image.network(
                            partido['thumbnail'],
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 180,
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.sports_soccer, size: 50),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título
                              Text(
                                partido['title'] ?? 'Sin título',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Resultado / Competición
                              Text(
                                "Competición / Resultado: ${partido['competition'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (linkVideo.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                // Link del video
                                SelectableText(
                                  "Video: $linkVideo",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
