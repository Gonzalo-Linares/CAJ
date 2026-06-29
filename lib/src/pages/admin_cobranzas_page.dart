import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pago.dart';
import '../services/pagos_service.dart';
import '../widgets/admin/pago_pendiente_card.dart';
import '../widgets/main_layout.dart';

class AdminCobranzasPage extends StatefulWidget {
  const AdminCobranzasPage({super.key});

  @override
  State<AdminCobranzasPage> createState() => _AdminCobranzasPageState();
}

class _AdminCobranzasPageState extends State<AdminCobranzasPage> {
  String _filtroEstado = 'pendiente';
  String _busquedaSocio = '';

  List<Pago> _filtrarPagos(List<Pago> pagos) {
    final pagosPorEstado = _filtroEstado == 'todos'
        ? pagos
        : pagos.where((pago) => pago.estado == _filtroEstado).toList();

    final busqueda = _busquedaSocio.trim().toLowerCase();

    if (busqueda.isEmpty) return pagosPorEstado;

    return pagosPorEstado.where((pago) {
      final nombre = pago.nombreSocio.toLowerCase();
      final telefono = pago.telefono.toLowerCase();
      final periodo = '${pago.mes} ${pago.anio}'.toLowerCase();

      return nombre.contains(busqueda) ||
          telefono.contains(busqueda) ||
          periodo.contains(busqueda);
    }).toList();
  }

  int _contarPorEstado(List<Pago> pagos, String estado) {
    return pagos.where((pago) => pago.estado == estado).length;
  }

  Future<void> _confirmarCambioEstado(
    Pago pago,
    String nuevoEstado,
  ) async {
    final esAprobacion = nuevoEstado == 'aprobado';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esAprobacion ? 'Aprobar pago' : 'Rechazar pago'),
          content: Text(
            esAprobacion
                ? '¿Confirmás la aprobación del pago de ${pago.nombreSocio}?'
                : '¿Confirmás el rechazo del pago de ${pago.nombreSocio}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(esAprobacion ? 'Aprobar' : 'Rechazar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    if (nuevoEstado == 'aprobado') {
      await PagosService.instance.aprobarPago(
        pago.id,
        revisadoPor: 'admin',
      );
    } else {
      await PagosService.instance.rechazarPago(
        pago.id,
        revisadoPor: 'admin',
      );
    }

    if (!mounted) return;

    final mensaje = esAprobacion
        ? 'Pago aprobado correctamente.'
        : 'Pago rechazado correctamente.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void _verComprobante(Pago pago) {
    final esUrlReal = pago.comprobanteUrl.startsWith('http');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Comprobante de pago'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (esUrlReal)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      pago.comprobanteUrl,
                      height: 220.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          size: 56.0,
                        );
                      },
                    ),
                  )
                else
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
                if (!esUrlReal) ...[
                  const SizedBox(height: 12.0),
                  const Text(
                    'La imagen real se integrará luego con Firebase Storage.',
                    textAlign: TextAlign.center,
                  ),
                ],
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
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo abrir WhatsApp.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return MainLayout(
      title: 'Cobranzas',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Pago>>(
          stream: PagosService.instance.obtenerPagosStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error al cargar pagos: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final pagos = snapshot.data ?? [];
            final pagosFiltrados = _filtrarPagos(pagos);

            return Column(
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: colores.onPrimary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: colores.onPrimary.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _ResumenEstadoItem(
                                  valor: _contarPorEstado(pagos, 'pendiente').toString(),
                                  etiqueta: 'Pendientes',
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 42,
                                color: colores.onPrimary.withValues(alpha: 0.20),
                              ),
                              Expanded(
                                child: _ResumenEstadoItem(
                                  valor: _contarPorEstado(pagos, 'aprobado').toString(),
                                  etiqueta: 'Aprobados',
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 42,
                                color: colores.onPrimary.withValues(alpha: 0.20),
                              ),
                              Expanded(
                                child: _ResumenEstadoItem(
                                  valor: _contarPorEstado(pagos, 'rechazado').toString(),
                                  etiqueta: 'Rechazados',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar socio',
                    hintText: 'Nombre, teléfono o período',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (valor) {
                    setState(() {
                      _busquedaSocio = valor;
                    });
                  },
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
                  child: pagosFiltrados.isEmpty
                      ? const Center(
                          child: Text('No hay pagos para mostrar.'),
                        )
                      : ListView.builder(
                          itemCount: pagosFiltrados.length,
                          itemBuilder: (context, index) {
                            final pago = pagosFiltrados[index];

                            return PagoPendienteCard(
                              pago: pago,
                              onAprobar: () => _confirmarCambioEstado(
                                pago,
                                'aprobado',
                              ),
                              onRechazar: () => _confirmarCambioEstado(
                                pago,
                                'rechazado',
                              ),
                              onContactarWhatsapp: () =>
                                  _contactarPorWhatsapp(pago),
                              onVerComprobante: () => _verComprobante(pago),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ResumenEstadoItem extends StatelessWidget {
  final String valor;
  final String etiqueta;

  const _ResumenEstadoItem({
    required this.valor,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valor,
          style: tema.textTheme.titleLarge?.copyWith(
            color: colores.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          etiqueta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: tema.textTheme.labelMedium?.copyWith(
            color: colores.onPrimary.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}