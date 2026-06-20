import 'package:flutter/material.dart';
import '../widgets/contacto/contacto_header.dart';
import '../widgets/contacto/contacto_info_card.dart';
import '../widgets/contacto/contacto_whatsapp.dart';
import '../widgets/main_layout.dart'; // Importa el layout base

class ContactoPage extends StatelessWidget {
  const ContactoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'Contacto',
      body: _Contacto(),
      );
  }
}

class _Contacto extends StatelessWidget {
  const _Contacto();

  @override
  Widget build(BuildContext context){
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        ContactoHeader(),
        SizedBox(height: 16.0),
        ContactoInfoCard(),
        SizedBox(height: 16.0),
        ContactoWhatsapp(),
      ]
    );
  }
}