import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  late final double _width;
  late final double _height;
  late final double _diagonal;
  late final bool _isTablet;

  // Getters para acceder a las propiedades
  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;
  bool get isTablet => _isTablet;

  Responsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    _width = size.width;
    _height = size.height;

    // Teorema de Pitágoras
    _diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    
    // Si el lado más corto es mayor a 600px, es una tablet
    _isTablet = size.shortestSide >= 600;
  }

  // Métodos que devuelven los porcentajes
  double wp(double percent) => _width * percent / 100;
  double hp(double percent) => _height * percent / 100;
  double dp(double percent) => _diagonal * percent / 100;
}