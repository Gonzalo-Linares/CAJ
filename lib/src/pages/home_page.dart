import 'package:flutter/material.dart';
import '../widgets/main_layout.dart'; // Importa el layout base

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'Inicio',
      body: _listaNovedades(),
    );
  }
  Widget _listaNovedades(){
    return FutureBuilder(
      future: novedadesProvider.cargarData(), 
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20.0),
            itemCount: data.length, 
            itemBuilder: (context, index) {
              final novedad = data[index]; 
              
              return TarjetaInicio(
                titulo: novedad['titulo'],
                descripcion: novedad['descripcion'],
                urlImagen: novedad['imagen'], 
              );
            },
          );
        } else {
          return const Center(child: Text('No hay novedades disponibles en este momento.'));
        }
      },
    );
  }



}