import 'package:flutter/material.dart';


class TarjetaInicio extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String urlImagen;

  const TarjetaInicio({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.urlImagen,
  });

  @override 
  Widget build(BuildContext context){
    final tema = Theme.of(context);
    return Card(
      elevation: 4.0, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: FadeInImage(
              placeholder: const AssetImage('assets/loading-img.gif'), 
              image: AssetImage(urlImagen),
              fadeInDuration: const Duration(milliseconds: 200),
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: tema.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ?? const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  descripcion,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    color: tema.colorScheme.onSurface.withValues(alpha: 0.8), 
                  ) ?? const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ]
      )

    );
  }

}