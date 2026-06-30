import 'package:flutter/material.dart';

class BotonConfirmarPago extends StatelessWidget {
  final bool subiendo;
  final bool tieneArchivo;
  final VoidCallback onConfirmar;

  const BotonConfirmarPago({
    super.key,
    required this.subiendo,
    required this.tieneArchivo,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (subiendo) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: tieneArchivo ? onConfirmar : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirmar y Enviar Pago',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
