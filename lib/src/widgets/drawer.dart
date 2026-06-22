import 'package:controlturnos/src/provider/menu_provider.dart';
import 'package:controlturnos/src/utils/icono_string_util.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Encabezado fijo del Club Andino
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                    child: Image.asset(
                      'assets/logo_caj3.png',
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.contain,
                    ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Club Andino Jáchal',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Menú de Opciones',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _lista(context),
          ),
        ],
      ),
    );
  }

  Widget _lista(BuildContext context) {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final data = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: data.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final itemData = data[index];
              return _buildTile(context, itemData);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: Text('No hay opciones disponibles'));
        }
      },
    );
  }

  Widget _buildTile(BuildContext context, dynamic opt) {
    return ListTile(
      title: Text(
        opt['texto'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      leading: getIcon(
        opt['icon'],
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        // Cierre del menú lateral de forma animada
        Navigator.pop(context);

        // Navegación a la ruta correspondiente
        Navigator.pushReplacementNamed(context, opt['ruta']);
      },
    );
  }
}