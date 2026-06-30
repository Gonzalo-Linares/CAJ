class SocioModel {
  String? id;
  String nombre;
  String apellido;
  String dni;
  String telefono;
  bool activo;

  SocioModel({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    this.telefono = '',
    this.activo = true,
  });

  // Mapea los datos que vienen de Firebase hacia nuestra app
  factory SocioModel.fromFirestore(Map<String, dynamic> data,String documentId) {
    return SocioModel(
      id: documentId,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      dni: data['dni'] ?? '',
      telefono: data['telefono'] ?? '',
      activo: data['activo'] ?? true,
    );
  }

  // Mapea los datos de nuestra app para guardarlos en Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'telefono': telefono,
      'activo': activo,
    };
  }
}