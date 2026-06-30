import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider {
  
  final CollectionReference _turnosCollection = 
      FirebaseFirestore.instance.collection('turnos');

  //MÉTODO PARA GUARDAR UN TURNO NUEVO
  Future<void> guardarTurno(Map<String, dynamic> nuevoTurno) async {
    try {
      // .add() crea un documento nuevo automáticamente con un ID único
      await _turnosCollection.add(nuevoTurno);
    } catch (e) {
      debugPrint('Error al guardar el turno: $e');
      rethrow;
    }
  }

  // MÉTODO PARA ESCUCHAR LOS TURNOS EN TIEMPO REAL 
  Stream<List<Map<String, dynamic>>> obtenerTurnosStream() {
    // Escuchamos los cambios en la colección
    return _turnosCollection.snapshots().map((QuerySnapshot snapshot) {
      
      // Convertimos los documentos de Firebase a una lista de Mapas
      return snapshot.docs.map((doc) {
        // Obtenemos los datos del documento
        final data = doc.data() as Map<String, dynamic>;
        
        
        data['id'] = doc.id; 
        
        return data;
      }).toList();
    });
  }
  
  // MÉTODO PARA ELIMINAR UN TURNO
  Future<void> eliminarTurno(String idDocumento) async {
    try {
      await _turnosCollection.doc(idDocumento).delete();
    } catch (e) {
      debugPrint('Error al eliminar el turno: $e');
    }
  }
}

// Instanciamos el provider para usarlo en toda la app
final firebaseProvider = FirebaseProvider();
