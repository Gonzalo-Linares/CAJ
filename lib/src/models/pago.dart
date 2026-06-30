class Pago {
  final String id;
  final String socioId;
  final String nombreSocio;
  final String telefono;
  final String mes;
  final int anio;
  final double monto;
  final String estado;
  final String comprobanteUrl;
  final DateTime fechaCarga;
  final DateTime? fechaRevision;
  final String? revisadoPor;

  const Pago({
    required this.id,
    required this.socioId,
    required this.nombreSocio,
    required this.telefono,
    required this.mes,
    required this.anio,
    required this.monto,
    required this.estado,
    required this.comprobanteUrl,
    required this.fechaCarga,
    this.fechaRevision,
    this.revisadoPor,
  });

  factory Pago.fromMap(Map<String, dynamic> json, {String? documentId}) {
    return Pago(
      id: documentId ?? json['id']?.toString() ?? '',
      socioId: json['socioId']?.toString() ?? '',
      nombreSocio: json['nombreSocio']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      mes: json['mes']?.toString() ?? '',
      anio: _parseInt(json['anio']),
      monto: _parseDouble(json['monto']),
      estado: json['estado']?.toString() ?? 'pendiente',
      comprobanteUrl: json['comprobanteUrl']?.toString() ?? '',
      fechaCarga: _parseDate(json['fechaCarga']) ?? DateTime.now(),
      fechaRevision: _parseDate(json['fechaRevision']),
      revisadoPor: json['revisadoPor']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'socioId': socioId,
      'nombreSocio': nombreSocio,
      'telefono': telefono,
      'mes': mes,
      'anio': anio,
      'monto': monto,
      'estado': estado,
      'comprobanteUrl': comprobanteUrl,
      'fechaCarga': fechaCarga.toIso8601String(),
      'fechaRevision': fechaRevision?.toIso8601String(),
      'revisadoPor': revisadoPor,
    };
  }

  Pago copyWith({
    String? estado,
    String? comprobanteUrl,
    DateTime? fechaRevision,
    String? revisadoPor,
  }) {
    return Pago(
      id: id,
      socioId: socioId,
      nombreSocio: nombreSocio,
      telefono: telefono,
      mes: mes,
      anio: anio,
      monto: monto,
      estado: estado ?? this.estado,
      comprobanteUrl: comprobanteUrl ?? this.comprobanteUrl,
      fechaCarga: fechaCarga,
      fechaRevision: fechaRevision ?? this.fechaRevision,
      revisadoPor: revisadoPor ?? this.revisadoPor,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is String) {
      return DateTime.tryParse(value);
    }

    try {
      final dynamic dynamicValue = value;
      final result = dynamicValue.toDate();
      if (result is DateTime) return result;
    } catch (_) {
      return null;
    }

    return null;
  }
}