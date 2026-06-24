import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/pago.dart';

class _PagosProvider {
  List<Pago> pagos = [];

  _PagosProvider();

  Future<List<Pago>> cargarData() async {
    final resp = await rootBundle.loadString('data/pagos.json');
    final Map<String, dynamic> dataMap = json.decode(resp);

    final List<dynamic> data = dataMap['pagos'];

    pagos = data.map((item) => Pago.fromMap(item)).toList();

    return pagos;
  }
}

final pagosProvider = _PagosProvider();