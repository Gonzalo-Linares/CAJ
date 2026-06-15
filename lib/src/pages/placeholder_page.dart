import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String titulo;

  const PlaceholderPage({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(
        child: Text('Pantalla en construcción: $titulo'),
      ),
    );
  }
}