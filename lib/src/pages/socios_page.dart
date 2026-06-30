import 'package:flutter/material.dart';
import '../models/socio_model.dart';
import '../services/socio_service.dart';

class SociosPage extends StatelessWidget {
  final SocioService _socioService = SocioService();

  SociosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Socios'),
      ),
      body: StreamBuilder<List<SocioModel>>(
        stream: _socioService.obtenerSocios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final socios = snapshot.data ?? [];

          if (socios.isEmpty) {
            return const Center(child: Text('No hay socios registrados todavía.'));
          }

          return ListView.builder(
            itemCount: socios.length,
            itemBuilder: (context, index) {
              final socio = socios[index];
              return ListTile(
                title: Text('${socio.nombre} ${socio.apellido}'),
                subtitle: Text(socio.telefono.isEmpty ? 'DNI: ${socio.dni}' : 'DNI: ${socio.dni} - Tel: ${socio.telefono}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit, 
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _mostrarFormulario(context, socio: socio),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete, 
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => _confirmarBaja(context, socio.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormulario(BuildContext context, {SocioModel? socio}) {
    final nombreCtrl = TextEditingController(text: socio?.nombre ?? '');
    final apellidoCtrl = TextEditingController(text: socio?.apellido ?? '');
    final dniCtrl = TextEditingController(text: socio?.dni ?? '');
    final telefonoCtrl = TextEditingController(text: socio?.telefono ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(socio == null ? 'Nuevo Socio' : 'Editar Socio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: apellidoCtrl, decoration: const InputDecoration(labelText: 'Apellido')),
            TextField(controller: dniCtrl, decoration: const InputDecoration(labelText: 'DNI')),
            TextField(controller: telefonoCtrl,keyboardType: TextInputType.phone,decoration: const InputDecoration(labelText: 'Teléfono')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (socio == null) {
                await _socioService.crearSocio(SocioModel(
                  nombre: nombreCtrl.text,
                  apellido: apellidoCtrl.text,
                  dni: dniCtrl.text,
                  telefono: telefonoCtrl.text.trim(),
                ));
              } else {
                socio.nombre = nombreCtrl.text;
                socio.apellido = apellidoCtrl.text;
                socio.dni = dniCtrl.text;
                socio.telefono = telefonoCtrl.text.trim();
                await _socioService.actualizarSocio(socio);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarBaja(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Socio'),
        content: const Text('¿Estás seguro de que querés dar de baja a este socio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () async {
              await _socioService.eliminarSocio(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Sí, eliminar', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}