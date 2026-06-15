import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/placeholder_page.dart'; // Importamos nuestra página temporal

// Función pura que retorna el mapa de rutas configurado [cite: 120]
Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/':             (BuildContext context) => const HomePage(),
    'turnos':        (BuildContext context) => const PlaceholderPage(titulo: 'Gestión de Turnos'),
    'pacientes':     (BuildContext context) => const PlaceholderPage(titulo: 'Pacientes'),
    'configuracion': (BuildContext context) => const PlaceholderPage(titulo: 'Configuración'),
  };
}