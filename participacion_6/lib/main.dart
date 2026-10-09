import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importamos las implementaciones de datos (Data)
import 'data/repositories/supabase_auth_repository.dart';
import 'data/repositories/supabase_perfiles_repository.dart';

// Importamos los casos de uso (Domain)
import 'domain/usecases/registrar_usuario.dart';

// Importamos los administradores de estado y pantallas (Presentation)
import 'presentation/providers/perfiles_provider.dart';
import 'presentation/providers/sesion_provider.dart';

// La pantalla que crearemos en la Parte 7 (dejará de marcar error cuando la creemos)
import 'presentation/pantallas/pantalla_ingreso.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  // 1. Composición de dependencias
  final authRepo = SupabaseAuthRepository();
  final perfilesRepo = SupabasePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepo, perfilesRepo);

  runApp(
    // 2. Envolvemos la app en un MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SesionProvider(authRepo, registrarUsuario),
        ),
        ChangeNotifierProvider(
          create: (_) => PerfilesProvider(perfilesRepo),
        ),
      ],
      child: const MiAppSupabase(),
    ),
  );
}

class MiAppSupabase extends StatelessWidget {
  const MiAppSupabase({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Usuarios USFQ',
      home: PantallaIngreso(), // Arrancará aquí, pero aún no existe.
    );
  }
}