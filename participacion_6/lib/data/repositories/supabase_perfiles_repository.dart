import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/perfil.dart';
import '../../domain/repositories/perfiles_repository.dart';

class SupabasePerfilesRepository implements PerfilesRepository {
  final _client = Supabase.instance.client;

  @override
  Future<void> crear(String id, String nombre) async {
    await _client.from('perfiles').insert({
      'id': id,
      'nombre': nombre,
    });
  }

  @override
  Future<List<Perfil>> obtenerTodos() async {
    final data = await _client.from('perfiles').select();
    
    // Convierte los Map devueltos por Supabase en objetos Perfil de tu dominio
    return (data as List).map((fila) {
      return Perfil(
        id: fila['id'],
        nombre: fila['nombre'],
        creadoEn: DateTime.parse(fila['creado_en']),
      );
    }).toList();
  }
}