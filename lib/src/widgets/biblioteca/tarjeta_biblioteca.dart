import 'package:flutter/material.dart';
import 'package:controlturnos/src/models/libro_model.dart';
import 'package:controlturnos/src/utils/icono_string_util.dart';

class TarjetaBiblioteca extends StatelessWidget {
  final LibroModel libro;
  final VoidCallback onDescargar;

  const TarjetaBiblioteca({
    super.key,
    required this.libro,
    required this.onDescargar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: colors.secondary.withValues(alpha: 0.2),
                child: getIcon(libro.icon),
              ),
            ),
            const Spacer(),
            // Badge sutil que muestra la categoría (Nueva mejora visual gracias a Firestore)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                libro.categoria.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              libro.titulo,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              libro.descripcion,
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: onDescargar,
                child: const Text(
                  'Descargar',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
