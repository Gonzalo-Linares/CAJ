class LibroModel {
  String? id;
  String titulo;
  String descripcion;
  String categoria;
  String icon;
  String url;

  LibroModel({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.icon,
    required this.url,
  });

  // Convierte el diccionario NoSQL (Map) de Firestore a Objeto Dart
  factory LibroModel.fromMap(Map<String, dynamic> json, String idF) =>
      LibroModel(
        id: idF,
        titulo: json['titulo'] ?? '',
        descripcion: json['descripcion'] ?? '',
        categoria: json['categoria'] ?? '',
        icon: json['icon'] ?? 'menu_book_rounded',
        url: json['url'] ?? '',
      );

  // Convierte el Objeto Dart a un Map para futuras operaciones de guardado
  Map<String, dynamic> toMap() => {
    'titulo': titulo,
    'descripcion': descripcion,
    'categoria': categoria,
    'icon': icon,
    'url': url,
  };
}
