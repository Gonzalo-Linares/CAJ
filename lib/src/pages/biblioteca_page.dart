import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegurate de importar la librería de descargas
import '../services/biblioteca_service.dart';
import '../models/libro_model.dart';
import '../widgets/main_layout.dart';
import '../widgets/biblioteca/tarjeta_biblioteca.dart';

class BibliotecaPage extends StatelessWidget {
  const BibliotecaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Biblioteca Virtual',
      // Consumimos el controlador Singleton de Firebase
      body: FutureBuilder<List<LibroModel>>(
        future: BibliotecaService.db.getDocumentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error de conexión: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay documentos en la biblioteca.'),
            );
          }

          final libros = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.85,
            ),
            itemCount: libros.length,
            itemBuilder: (context, index) {
              return TarjetaBiblioteca(
                libro: libros[index],
                // Pasamos la función de descarga directa utilizando url_launcher
                onDescargar: () => _lanzarDescarga(context, libros[index].url),
              );
            },
          );
        },
      ),
    );
  }

  // Ejecución imperativa externa mediante el Event Loop de Dart
  Future<void> _lanzarDescarga(BuildContext context, String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se pudo procesar la URL.';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al descargar: $e')));
      }
    }
  }
}
