// import 'dart:convert';

// import 'package:flutter/services.dart' show rootBundle;

// //Se genera de manera privada la clase
// class _TurnosProvider {
//   //Se genera una lista dinámica y se inicializa como una lista vacía
//   List<dynamic> turnos = [];

//   //Se define el constructor
//   _TurnosProvider();

//   //El método cargarData es un Future que permite devolver el listado de turnos una vez que se ha leído del archivo JSON
//   //El Future va a retornar cuando esté disponible, la información en una lista dinámica
//   Future<List<dynamic>> cargarData() async {
//     final resp = await rootBundle.loadString('data/turnos.json');
//     Map dataMap = json.decode(resp);
//     turnos = dataMap['turnos'];

//     return turnos;
//   }
// }

// //Se crea la instancia del TurnosProvider
// final turnosProvider = _TurnosProvider();

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  // Hacemos una referencia directa a la colección "turnos" de la base de datos
  final CollectionReference _turnosCollection = 
      FirebaseFirestore.instance.collection('turnos');

  // 1. MÉTODO PARA GUARDAR UN TURNO NUEVO
  Future<void> guardarTurno(Map<String, dynamic> nuevoTurno) async {
    try {
      // .add() crea un documento nuevo automáticamente con un ID único
      await _turnosCollection.add(nuevoTurno);
    } catch (e) {
      print('Error al eliminar el turno: $e');
      // rethrow e;
    }
  }

  // 2. MÉTODO PARA ESCUCHAR LOS TURNOS EN TIEMPO REAL (El Stream)
  Stream<List<Map<String, dynamic>>> obtenerTurnosStream() {
    // Escuchamos los cambios en la colección
    return _turnosCollection.snapshots().map((QuerySnapshot snapshot) {
      
      // Convertimos los documentos de Firebase a una lista de Mapas
      return snapshot.docs.map((doc) {
        // Obtenemos los datos del documento
        final data = doc.data() as Map<String, dynamic>;
        
        // Opcional pero recomendado: le agregamos el ID único que Firebase genera
        // por si después queremos borrarlo
        data['id'] = doc.id; 
        
        return data;
      }).toList();
    });
  }
  
  // 3. MÉTODO PARA ELIMINAR UN TURNO
  Future<void> eliminarTurno(String idDocumento) async {
    try {
      await _turnosCollection.doc(idDocumento).delete();
    } catch (e) {
      print('Error al eliminar el turno: $e');
    }
  }
}

// Instanciamos el provider para usarlo en toda la app
final firebaseProvider = FirebaseProvider();
