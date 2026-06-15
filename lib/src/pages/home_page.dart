import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio - Control de Turnos')),
      body: _crearListaMenu(context),
    );
  }

  // Método que genera dinámicamente el menú
  Widget _crearListaMenu(BuildContext context) {
    // Lista de rutas y opciones. Despues se puede armar desde JSON o API
    final List<Map<String, dynamic>> opcionesMenu = [
      {'titulo': 'Gestión de Turnos', 'icono': Icons.calendar_month, 'ruta': 'turnos'},
      {'titulo': 'Lista de Pacientes', 'icono': Icons.people, 'ruta': 'pacientes'},
      {'titulo': 'Configuración', 'icono': Icons.settings, 'ruta': 'configuracion'},
    ];

    return ListView(
      children: opcionesMenu.map((opt) {
        return Column(
          children: [
            ListTile(
              // Icono a la izquierda
              leading: Icon(opt['icono'], color: Theme.of(context).primaryColor),
              title: Text(opt['titulo']),
              // Icono a la derecha
              trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () {
                // Navegamos usando el String configurado de cada ruta de las pantallas
                Navigator.pushNamed(context, opt['ruta']);
              },
            ),
            const Divider(), // Separador estético
          ],
        );
      }).toList(),
    );
  }
}