import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactoInfoCard extends StatelessWidget {
  const ContactoInfoCard({super.key});

  static const String _direccionVisible = 'Jáchal, San Juan';

  static const String _direccionMaps = 'Club Andino Jáchal, Jáchal, San Juan';

  Future<void> _abrirMaps(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_direccionMaps)}',
    );

    final bool pudoAbrir = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!pudoAbrir && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir Google Maps.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.location_on_outlined,
              color: colores.primary,
            ),
            title: const Text('Ubicación'),
            subtitle: const Text(_direccionVisible),
            trailing: Icon(
              Icons.open_in_new,
              size: 18.0,
              color: colores.primary,
            ),
            onTap: () => _abrirMaps(context),
          ),
          const Divider(height: 1.0),
          ListTile(
            leading: Icon(
              Icons.email_outlined,
              color: colores.primary,
            ),
            title: const Text('Email'),
            subtitle: const Text('contacto@clubandinojachal.com'),
          ),
          const Divider(height: 1.0),
          ListTile(
            leading: Icon(
              Icons.phone_outlined,
              color: colores.primary,
            ),
            title: const Text('Teléfono'),
            subtitle: const Text('+54 9 264 000 0000'),
          ),
          const Divider(height: 1.0),
          ListTile(
            leading: Icon(
              Icons.schedule_outlined,
              color: colores.primary,
            ),
            title: const Text('Horario de atención'),
            subtitle: const Text('Lunes a viernes de 9:00 a 18:00'),
          ),
        ],
      ),
    );
  }
}