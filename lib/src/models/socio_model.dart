
class SocioModel {
  String? id;
  String nombre;
  String apellido;
  String dni;
  bool activo;

  SocioModel({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    this.activo = true, // al dar de alta, el socio está activo
  });

  // Mapea los datos que vienen de Firebase hacia nuestra app
  factory SocioModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return SocioModel(
      id: documentId, 
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      dni: data['dni'] ?? '',
      activo: data['activo'] ?? true,
    );
  }

  // Mapea los datos de nuestra app para guardarlos en Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'activo': activo,
    };
  }
}