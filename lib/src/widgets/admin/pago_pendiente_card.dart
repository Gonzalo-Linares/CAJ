import 'package:flutter/material.dart';

import '../../models/pago.dart';

class PagoPendienteCard extends StatelessWidget {
  final Pago pago;
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;
  final VoidCallback onContactarWhatsapp;
  final VoidCallback onVerComprobante;

  const PagoPendienteCard({
    super.key,
    required this.pago,
    required this.onAprobar,
    required this.onRechazar,
    required this.onContactarWhatsapp,
    required this.onVerComprobante,
  });

  bool get _estaPendiente => pago.estado == 'pendiente';

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colores.primary,
                  child: Text(
                    pago.nombreSocio.isNotEmpty
                        ? pago.nombreSocio[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: colores.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pago.nombreSocio,
                        style: tema.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pago.mes} ${pago.anio}',
                        style: tema.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _EstadoPagoChip(estado: pago.estado),
              ],
            ),
            const SizedBox(height: 12.0),
            _DatoPago(
              icono: Icons.payments_outlined,
              texto: 'Monto: \$${pago.monto.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 6.0),
            _DatoPago(
              icono: Icons.receipt_long_outlined,
              texto: pago.comprobanteUrl.isEmpty
                  ? 'Sin comprobante adjunto'
                  : 'Comprobante cargado',
            ),
            const SizedBox(height: 6.0),
            _DatoPago(
              icono: Icons.phone_android_outlined,
              texto: pago.telefono,
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pago.comprobanteUrl.isEmpty
                    ? null
                    : onVerComprobante,
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Ver comprobante'),
              ),
            ),
            const SizedBox(height: 14.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _estaPendiente ? onAprobar : null,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Aprobar'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _estaPendiente ? onRechazar : null,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Rechazar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onContactarWhatsapp,
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Contactar por WhatsApp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoPago extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _DatoPago({
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icono,
          size: 18.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(texto),
        ),
      ],
    );
  }
}

class _EstadoPagoChip extends StatelessWidget {
  final String estado;

  const _EstadoPagoChip({
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final datos = _datosEstado(context);

    return Chip(
      avatar: Icon(
        datos.icono,
        size: 18.0,
        color: datos.color,
      ),
      label: Text(
        datos.texto,
        style: TextStyle(
          color: datos.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: datos.color.withValues(alpha: 0.12),
      side: BorderSide(color: datos.color.withValues(alpha: 0.35)),
    );
  }

  _EstadoVisual _datosEstado(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    switch (estado) {
      case 'aprobado':
        return _EstadoVisual(
          texto: 'Aprobado',
          icono: Icons.check_circle_outline,
          color: colores.primary,
        );
      case 'rechazado':
        return _EstadoVisual(
          texto: 'Rechazado',
          icono: Icons.cancel_outlined,
          color: colores.error,
        );
      default:
        return _EstadoVisual(
          texto: 'Pendiente',
          icono: Icons.schedule_outlined,
          color: colores.tertiary,
        );
    }
  }
}

class _EstadoVisual {
  final String texto;
  final IconData icono;
  final Color color;

  const _EstadoVisual({
    required this.texto,
    required this.icono,
    required this.color,
  });
}