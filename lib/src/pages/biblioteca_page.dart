import 'package:flutter/material.dart';
import '../provider/biblioteca_provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/biblioteca/tarjeta_biblioteca.dart';

class BibliotecaPage extends StatelessWidget {
  const BibliotecaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Biblioteca Virtual',
      body: FutureBuilder<List<dynamic>>(
        future: bibliotecaProvider.cargarData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay documentos disponibles.'));
          }

          final libros = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.72,
            ),
            itemCount: libros.length,
            itemBuilder: (context, index) =>
                TarjetaBiblioteca(libro: libros[index]),
          );
        },
      ),
    );
  }
}
