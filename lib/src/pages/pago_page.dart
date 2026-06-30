import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // 🚀 IMPORTACIÓN CLAVE PARA USAR kIsWeb
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/pago_service.dart';
import '../models/comprobante_model.dart';
import '../widgets/main_layout.dart';

import '../widgets/pago/visor_comprobante.dart';
import '../widgets/pago/boton_confirmar_pago.dart';

class PagoPage extends StatefulWidget {
  const PagoPage({super.key});

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  bool _subiendo = false;
  String? _nombreArchivo;
  String? _tipoDetectado;
  PlatformFile? _archivoSeleccionado;

  Future<void> _seleccionarComprobante() async {
    // 1. Si es Web, salteamos el bloqueo de permisos nativos porque el navegador no los usa
    bool tienePermiso = kIsWeb;

    if (!kIsWeb) {
      // Si está corriendo en un celular (Android/iOS), ahí sí pedimos permiso
      final status = await Permission.storage.request();
      tienePermiso = status.isGranted;
    }

    if (tienePermiso) {
      final List<String> extensiones = ['jpg', 'jpeg', 'png', 'pdf'];

      // Corregido a FilePicker.platform.pickFiles para evitar errores de compilación
      final resultado = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensiones,
      );

      if (resultado != null && resultado.files.isNotEmpty) {
        final archivo = resultado.files.first;
        setState(() {
          _archivoSeleccionado = archivo;
          _nombreArchivo = archivo.name;
          _tipoDetectado = archivo.extension == 'pdf' ? 'pdf' : 'imagen';
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sin acceso al almacenamiento no podemos cargar el archivo.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _procesarPago() async {
    if (_archivoSeleccionado == null) return;

    setState(() => _subiendo = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulación de red

    final nuevoPago = ComprobanteModel(
      socioId: "socio_juan_123",
      urlArchivo: "https://google_drive_simulado.com/files/$_nombreArchivo",
      fecha: DateTime.now().toString().substring(0, 10),
      tipoArchivo: _tipoDetectado!,
    );

    await PagoService.db.enviarComprobante(nuevoPago);

    setState(() {
      _subiendo = false;
      _archivoSeleccionado = null;
      _nombreArchivo = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Comprobante enviado con éxito! Queda bajo revisión del Admin.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _mostrarDialogoDeAjustes() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permiso Requerido'),
        content: const Text(
          'Habilite el acceso al almacenamiento desde los ajustes del sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Ir a Ajustes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Enviar Pago',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. Invocación limpia al visor desacoplado
            VisorComprobante(
              nombreArchivo: _nombreArchivo,
              tipoDetectado: _tipoDetectado,
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _subiendo ? null : _seleccionarComprobante,
              icon: const Icon(Icons.folder_open_rounded),
              label: const Text('Seleccionar Archivo'),
            ),
            const Spacer(),

            // 2. Invocación limpia al botón desacoplado
            BotonConfirmarPago(
              subiendo: _subiendo,
              tieneArchivo: _archivoSeleccionado != null,
              onConfirmar: _procesarPago,
            ),
          ],
        ),
      ),
    );
  }
}
