import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async {
    final respuesta = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    
    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);
      return datos.map((json) => Usuario(
        id: json['id'],
        nombre: json['name'],
        email: json['email'],
      )).toList();
    } else {
      throw Exception('Error de servidor: ${respuesta.statusCode}');
    }
  }
}