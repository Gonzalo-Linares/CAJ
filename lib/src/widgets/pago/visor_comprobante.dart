import 'package:flutter/material.dart';

class VisorComprobante extends StatelessWidget {
  final String? nombreArchivo;
  final String? tipoDetectado;

  const VisorComprobante({
    super.key,
    required this.nombreArchivo,
    required this.tipoDetectado,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.5),
          style: BorderStyle.solid,
        ),
      ),
      child: nombreArchivo == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file_rounded,
                  size: 60,
                  color: colors.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  'Formatos aceptados: PNG, JPG, PDF',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tipoDetectado == 'pdf'
                      ? Icons.picture_as_pdf_rounded
                      : Icons.image_rounded,
                  size: 60,
                  color: tipoDetectado == 'pdf'
                      ? Colors.redAccent
                      : Colors.blueAccent,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    nombreArchivo!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}
