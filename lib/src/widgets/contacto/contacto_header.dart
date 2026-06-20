import 'package:flutter/material.dart';

class ContactoHeader extends StatelessWidget {
  const ContactoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: colores.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.hiking,
              size: 48.0,
              color: colores.onPrimary,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Club Andino Jáchal',
              style: tema.textTheme.headlineSmall?.copyWith(
                color: colores.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Dejanos tu consulta y nos pondremos en contacto pronto.',
              style: tema.textTheme.bodyMedium?.copyWith(
                color: colores.onPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}