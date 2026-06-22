import 'package:controlturnos/src/provider/menu_provider.dart';
import 'package:controlturnos/src/utils/icono_string_util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Club Andino Jáchal')),
      body: _lista(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: const [],
      //retorna un widget builder que va a permitir dibujar un elemento en pantalla
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          List<dynamic> data = snapshot.data;
          return ListView.separated(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _listaItems(data)[index];
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        } else {
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }

  List<Widget> _listaItems(List<dynamic> data) {
    //Recorremos cada uno de los elementos de la lista, armando los ListTile
    return data
        .map(
          (opt) => ListTile(
            title: Text(opt['texto']),
            leading: getIcon(opt['icon'], color: Theme.of(context).colorScheme.primary),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              Navigator.pushNamed(context, opt['ruta']);
            },
          ),
        )
        .toList();
  }
}