import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/libro_model.dart';

class BibliotecaService {
  // Única instancia compartida globalmente en la memoria activa (Singleton)
  static final BibliotecaService db = BibliotecaService._();
  BibliotecaService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // READ: Realiza la petición asíncrona a la colección remota de Firestore
  Future<List<LibroModel>> getDocumentos() async {
    final QuerySnapshot respuestas = await _firestore
        .collection('biblioteca')
        .get();

    // Mapea la lista de documentos crudos del servidor a objetos Dart
    return respuestas.docs.map((doc) {
      return LibroModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
