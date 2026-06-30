class ComprobanteModel {
  String? id;
  String socioId;
  String urlArchivo;
  String estado; // 'pendiente', 'aprobado', 'rechazado'
  String fecha;
  String tipoArchivo; // 'imagen' o 'pdf'

  ComprobanteModel({
    this.id,
    required this.socioId,
    required this.urlArchivo,
    this.estado = 'pendiente',
    required this.fecha,
    required this.tipoArchivo,
  });

  // Mapeo: Transforma el JSON del servidor a Objeto Dart
  factory ComprobanteModel.fromMap(Map<String, dynamic> json, String idF) =>
      ComprobanteModel(
        id: idF,
        socioId: json['socioId'] ?? '',
        urlArchivo: json['urlArchivo'] ?? '',
        estado: json['estado'] ?? 'pendiente',
        fecha: json['fecha'] ?? '',
        tipoArchivo: json['tipoArchivo'] ?? 'imagen',
      );

  // Serialización: Transforma el Objeto Dart a un Map para persistencia [cite: 170]
  Map<String, dynamic> toMap() => {
    'socioId': socioId,
    'urlArchivo': urlArchivo,
    'estado': estado,
    'fecha': fecha,
    'tipoArchivo': tipoArchivo,
  };
}
