import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/pago.dart';

class PagosService {
  PagosService._internal();

  static final PagosService instance = PagosService._internal();

  final StreamController<List<Pago>> _pagosController =
      StreamController<List<Pago>>.broadcast();

  final List<Pago> _pagos = [];
  bool _cargado = false;

  Stream<List<Pago>> obtenerPagosStream() async* {
    await _cargarDatosIniciales();

    yield List.unmodifiable(_pagos);

    yield* _pagosController.stream;
  }

  Future<List<Pago>> obtenerPagos() async {
    await _cargarDatosIniciales();
    return List.unmodifiable(_pagos);
  }

  Future<void> aprobarPago(String pagoId, {String revisadoPor = ''}) async {
    await _actualizarEstadoPago(
      pagoId,
      estado: 'aprobado',
      revisadoPor: revisadoPor,
    );
  }

  Future<void> rechazarPago(String pagoId, {String revisadoPor = ''}) async {
    await _actualizarEstadoPago(
      pagoId,
      estado: 'rechazado',
      revisadoPor: revisadoPor,
    );
  }

  Future<void> _cargarDatosIniciales() async {
    if (_cargado) return;

    final resp = await rootBundle.loadString('data/pagos.json');
    final Map<String, dynamic> dataMap = json.decode(resp);
    final List<dynamic> data = dataMap['pagos'] ?? [];

    _pagos
      ..clear()
      ..addAll(data.map((item) => Pago.fromMap(item)));

    _cargado = true;
  }

  Future<void> _actualizarEstadoPago(
    String pagoId, {
    required String estado,
    required String revisadoPor,
  }) async {
    await _cargarDatosIniciales();

    final index = _pagos.indexWhere((pago) => pago.id == pagoId);

    if (index == -1) return;

    _pagos[index] = _pagos[index].copyWith(
      estado: estado,
      fechaRevision: DateTime.now(),
      revisadoPor: revisadoPor,
    );

    _emitirCambios();
  }

  void _emitirCambios() {
    _pagosController.add(List.unmodifiable(_pagos));
  }
}