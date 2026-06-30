import 'package:flutter/material.dart';

// Importaciones de todas las páginas (las tuyas y las de tu compañero)
import '../pages/home_page.dart';
import '../pages/turnos_page.dart';
import '../pages/contacto_page.dart';
import '../pages/biblioteca_page.dart';
import '../pages/pago_page.dart'; // Tu pantalla
import '../pages/socios_page.dart'; // Compañero
import '../pages/admin_page.dart'; // Compañero
import '../pages/admin_cobranzas_page.dart'; // Compañero

// Función pura que retorna el mapa de rutas configurado
Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const HomePage(),
    'turnos': (BuildContext context) => const TurnosPage(),
    'contacto': (BuildContext context) => const ContactoPage(),
    'biblioteca': (BuildContext context) => const BibliotecaPage(),
    'pago': (BuildContext context) => const PagoPage(),
    'socios': (BuildContext context) => SociosPage(),
    'admin': (BuildContext context) => const AdminPage(),
    'admin-cobranzas': (BuildContext context) => const AdminCobranzasPage(),
  };
}
