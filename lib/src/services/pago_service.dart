import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comprobante_model.dart';

class PagoService {
  // Instancia única global (Singleton) [cite: 115, 174]
  static final PagoService db = PagoService._();
  PagoService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE: Registra la transacción con el link en Firestore
  Future<void> enviarComprobante(ComprobanteModel nuevoPago) async {
    await _firestore.collection('comprobantes').add(nuevoPago.toMap());
  }
}
