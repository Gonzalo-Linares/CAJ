import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pago.dart';

class PagosService {
  PagosService._internal();

  static final PagosService instance = PagosService._internal();

  final CollectionReference<Map<String, dynamic>> _pagosRef =
      FirebaseFirestore.instance.collection('pagos');

  Stream<List<Pago>> obtenerPagosStream() {
    return _pagosRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Pago.fromMap(
          doc.data(),
          documentId: doc.id,
        );
      }).toList();
    });
  }

  Future<List<Pago>> obtenerPagos() async {
    final snapshot = await _pagosRef.get();

    return snapshot.docs.map((doc) {
      return Pago.fromMap(
        doc.data(),
        documentId: doc.id,
      );
    }).toList();
  }

  Future<void> aprobarPago(
    String pagoId, {
    String revisadoPor = '',
  }) async {
    await _actualizarEstadoPago(
      pagoId,
      estado: 'aprobado',
      revisadoPor: revisadoPor,
    );
  }

  Future<void> rechazarPago(
    String pagoId, {
    String revisadoPor = '',
  }) async {
    await _actualizarEstadoPago(
      pagoId,
      estado: 'rechazado',
      revisadoPor: revisadoPor,
    );
  }

  Future<void> _actualizarEstadoPago(
    String pagoId, {
    required String estado,
    required String revisadoPor,
  }) async {
    await _pagosRef.doc(pagoId).update({
      'estado': estado,
      'fechaRevision': FieldValue.serverTimestamp(),
      'revisadoPor': revisadoPor,
    });
  }
}