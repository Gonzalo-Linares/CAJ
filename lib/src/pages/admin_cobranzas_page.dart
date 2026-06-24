import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pago.dart';
import '../provider/pagos_provider.dart';
import '../widgets/admin/pago_pendiente_card.dart';
import '../widgets/main_layout.dart';

class AdminCobranzasPage extends StatefulWidget {
  const AdminCobranzasPage({super.key});

  @override
  State<AdminCobranzasPage> createState() => _AdminCobranzasPageState();
}

class _AdminCobranzasPageState extends State<AdminCobranzasPage> {
  String _filtroEstado = 'pendiente';
  List<Pago> _pagos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPagos();
  }

  Future<void> _cargarPagos() async {
    final data = await pagosProvider.cargarData();

    if (!mounted) return;

    setState(() {
      _pagos = data;
      _isLoading = false;
    });
  }

  List<Pago> get _pagosFiltrados {
    if (_filtroEstado == 'todos') return _pagos;

    return _pagos.where((pago) => pago.estado == _filtroEstado).toList();
  }

  int get _cantidadPendientes {
    return _pagos.where((pago) => pago.estado == 'pendiente').length;
  }

  int get _cantidadAprobados {
    return _pagos.where((pago) => pago.estado == 'aprobado').length;
  }

  int get _cantidadRechazados {
    return _pagos.where((pago) => pago.estado == 'rechazado').length;
  }

  void _actualizarEstadoPago(Pago pago, String nuevoEstado) {
    final index = _pagos.indexWhere((item) => item.id == pago.id);

    if (index == -1) return;

    setState(() {
      _pagos[index] = pago.copyWith(estado: nuevoEstado);
    });

    final mensaje = nuevoEstado == 'aprobado'
        ? 'Pago aprobado correctamente.'
        : 'Pago rechazado correctamente.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void _verComprobante(Pago pago) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Comprobante de pago'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 48.0,
                ),
                const SizedBox(height: 12.0),
                Text(
                  pago.nombreSocio,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Período: ${pago.mes} ${pago.anio}'),
                const SizedBox(height: 8.0),
                Text('Monto: \$${pago.monto.toStringAsFixed(0)}'),
                const SizedBox(height: 8.0),
                Text(
                  'Archivo: ${pago.comprobanteUrl}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'La visualización de la imagen real se integrará luego con Firebase Storage.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _contactarPorWhatsapp(Pago pago) async {
    final mensaje = Uri.encodeComponent(
      'Hola ${pago.nombreSocio}, te contactamos desde el Club Andino Jáchal por el estado de tu pago correspondiente a ${pago.mes} ${pago.anio}.',
    );

    final url = Uri.parse('https://wa.me/${pago.telefono}?text=$mensaje');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir WhatsApp.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return MainLayout(
      title: 'Cobranzas',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: colores.primary,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      color: colores.onPrimary,
                      size: 34.0,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Panel de Cobranzas',
                      style: tema.textTheme.titleLarge?.copyWith(
                        color: colores.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Revisá comprobantes y actualizá el estado de cada pago.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: colores.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: _ResumenEstadoChip(
                            texto: 'Pend.: $_cantidadPendientes',
                            icono: Icons.schedule_outlined,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: _ResumenEstadoChip(
                            texto: 'Aprob.: $_cantidadAprobados',
                            icono: Icons.check_circle_outline,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: _ResumenEstadoChip(
                            texto: 'Rech.: $_cantidadRechazados',
                            icono: Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            DropdownButtonFormField<String>(
              initialValue: _filtroEstado,
              decoration: const InputDecoration(
                labelText: 'Filtrar pagos',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'todos',
                  child: Text('Todos'),
                ),
                DropdownMenuItem(
                  value: 'pendiente',
                  child: Text('Pendientes'),
                ),
                DropdownMenuItem(
                  value: 'aprobado',
                  child: Text('Aprobados'),
                ),
                DropdownMenuItem(
                  value: 'rechazado',
                  child: Text('Rechazados'),
                ),
              ],
              onChanged: (valor) {
                if (valor == null) return;

                setState(() {
                  _filtroEstado = valor;
                });
              },
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _pagosFiltrados.isEmpty
                      ? const Center(
                          child: Text('No hay pagos para mostrar.'),
                        )
                      : ListView.builder(
                          itemCount: _pagosFiltrados.length,
                          itemBuilder: (context, index) {
                            final pago = _pagosFiltrados[index];

                            return PagoPendienteCard(
                              pago: pago,
                              onAprobar: () =>
                                  _actualizarEstadoPago(pago, 'aprobado'),
                              onRechazar: () =>
                                  _actualizarEstadoPago(pago, 'rechazado'),
                              onContactarWhatsapp: () =>
                                  _contactarPorWhatsapp(pago),
                              onVerComprobante: () => _verComprobante(pago),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenEstadoChip extends StatelessWidget {
  final String texto;
  final IconData icono;

  const _ResumenEstadoChip({
    required this.texto,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Container(
      height: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: colores.onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colores.onPrimary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono,
            size: 14.0,
            color: colores.onPrimary,
          ),
          const SizedBox(width: 3.0),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto,
                maxLines: 1,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colores.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}