import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/socio_model.dart';
import 'package:flutter/foundation.dart';

class SocioService {
  final CollectionReference _sociosRef =
      FirebaseFirestore.instance.collection('personas');

  // ALTA 
  Future<void> crearSocio(SocioModel socio) async {
    try {
      await _sociosRef.add(socio.toFirestore());
    } catch (e) {
      debugPrint('Error al dar de alta al socio: $e');
      rethrow; 
    }
  }

  // OBTENER TODOS (Leer en tiempo real)
  Stream<List<SocioModel>> obtenerSocios() {
    return _sociosRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SocioModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // MODIFICAR (Actualizar)
  Future<void> actualizarSocio(SocioModel socio) async {
    try {
      await _sociosRef.doc(socio.id).update(socio.toFirestore());
    } catch (e) {
      debugPrint('Error al modificar al socio: $e');
      rethrow;
    }
  }

  // BAJA (Eliminar)
  Future<void> eliminarSocio(String id) async {
    try {
      // Opción: Borrarlo por completo de la base de datos (Baja Física)
      //await _sociosRef.doc(id).delete();
      await _sociosRef.doc(id).update({'activo': false});
    } catch (e) {
      debugPrint('Error al dar de baja al socio: $e');
      rethrow;
    }
  }
}