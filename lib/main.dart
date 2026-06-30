import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';
import 'src/services/firebase_options.dart';

Future<void> main() async {
  // 1. Vinculación de los componentes nativos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicialización de Firebase con las opciones de tu proyecto
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Lanzamiento de la aplicación
  runApp(const MyApp());
}
