
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactoWhatsapp extends StatelessWidget {
  const ContactoWhatsapp ({super.key});

  static const String _telefono= '5492640000000';

  static const String _mensaje= 'Hola, me contacto desde la app Club Andino Jáchal. Quisiera hacer una consulta.';

  static const Color _whatsappColor = Color(0xFF25D366);

  Future<void> _abrirWhatsapp(BuildContext context) async {
    final Uri url= Uri.parse('https://wa.me/$_telefono?text=${Uri.encodeComponent(_mensaje)}');

    final bool pudoAbrir = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!pudoAbrir && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir WhatsApp.'),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema= Theme.of(context);

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: FaIcon(
              FontAwesomeIcons.whatsapp,
              size:48.0,
              color: _whatsappColor,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: ()=> _abrirWhatsapp(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _whatsappColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                textStyle: tema.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            child: const Text('Enviar mensaje por WhatsApp'),
            ),
          ],
        ),
        ),
    );
  }
}