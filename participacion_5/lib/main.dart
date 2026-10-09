import 'package:flutter/material.dart';
import 'data/repositories/usuario_api.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/pantalla_usuarios.dart';

void main() {
  // 1. Instanciar infraestructura (Data)
  final usuarioApi = UsuarioApi();
  
  // 2. Instanciar lógica inyectando infraestructura (Domain)
  final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(usuarioApi);

  // 3. Arrancar app inyectando lógica (Presentation)
  runApp(Aplicacion(casoDeUso: obtenerUsuariosConVocal));
}

class Aplicacion extends StatelessWidget {
  final ObtenerUsuariosConVocal casoDeUso;

  const Aplicacion({super.key, required this.casoDeUso});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaUsuarios(casoDeUso: casoDeUso),
    );
  }
}



// 1.   tiene el metodo .get hacia una url especifica, tiene el mappeo de los datos de json, tiene la regla de negocio, 
// donde es el filtro de vocales y presenta la intefaz.


// 2. Si la URL de la API cambia, es necesario editar el archivo visual porque la dirección de internet está 
// codificada dentro del estado del widget.

// 3.Al estar la regla de negocio (el filtro de vocales) atrapada dentro del estado de la interfaz de Flutter, 
// te obliga a emular toda la pantalla y la respuesta del servidor mediante un Widget

// rompe la responsabilidad unica en la linea 42 porque la interfaz grafica no se deberia conectar al internet,
// tambien se rompe en la linea 48 al mapear los datos json, 

// 4)  pantalla presenta una baja cohesión porque agrupa responsabilidades que no comparten el mismo propósito fundamental. Están conviviendo en un solo bloque estructural:  
// El acceso a la red (consumo de la API con http).El parseo y transformación de datos (jsonDecode).La lógica de negocio estricta (el filtrado por vocales).

// 5) Reemplazar toda la función _obtenerUsuarios dentro del State del Widget y cambiar la lógica de parseo web por la lógica de lectura de tu base de datos
// esto demuestra que se tiene un nivel acoplamiento alto donde cualquier cambio obliga a reescribir diferentes partes delcodigo




