import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/biblioteca_page.dart';
import '../pages/turnos_page.dart';
import '../pages/contacto_page.dart';
import '../pages/socios_page.dart';
import '../pages/admin_page.dart';
import '../pages/admin_cobranzas_page.dart';

// Función pura que retorna el mapa de rutas configurado
Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/':                  (BuildContext context) => const HomePage(),
    'turnos':             (BuildContext context) => const TurnosPage(),
    'contacto':           (BuildContext context) => const ContactoPage(),
    'biblioteca':         (BuildContext context) => const BibliotecaPage(),
    'socios':             (BuildContext context) => SociosPage(),
    'admin':              (BuildContext context) => const AdminPage(),
    'admin-cobranzas':    (BuildContext context) => const AdminCobranzasPage(),
  };
}