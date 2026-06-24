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
  });

  factory Pago.fromMap(Map<String, dynamic> json) {
    return Pago(
      id: json['id'] ?? '',
      socioId: json['socioId'] ?? '',
      nombreSocio: json['nombreSocio'] ?? '',
      telefono: json['telefono'] ?? '',
      mes: json['mes'] ?? '',
      anio: json['anio'] ?? 0,
      monto: (json['monto'] ?? 0).toDouble(),
      estado: json['estado'] ?? 'pendiente',
      comprobanteUrl: json['comprobanteUrl'] ?? '',
      fechaCarga: DateTime.tryParse(json['fechaCarga'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'socioId': socioId,
      'nombreSocio': nombreSocio,
      'telefono': telefono,
      'mes': mes,
      'anio': anio,
      'monto': monto,
      'estado': estado,
      'comprobanteUrl': comprobanteUrl,
      'fechaCarga': fechaCarga.toIso8601String(),
    };
  }

  Pago copyWith({
    String? estado,
    String? comprobanteUrl,
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
    );
  }
}