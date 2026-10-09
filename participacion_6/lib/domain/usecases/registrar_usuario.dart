import '../repositories/auth_repository.dart';
import '../repositories/perfiles_repository.dart';

class RegistrarUsuario {
  final AuthRepository authRepository;
  final PerfilesRepository perfilesRepository;

  RegistrarUsuario(this.authRepository, this.perfilesRepository);

  Future<void> call(String correo, String clave, String nombre) async {
    // 1. Registra en Auth y obtiene el ID generado
    final id = await authRepository.registrar(correo, clave);
    
    // 2. Con ese ID, inserta el perfil en la tabla. Si esto falla, propaga el error.
    await perfilesRepository.crear(id, nombre);
  }
}