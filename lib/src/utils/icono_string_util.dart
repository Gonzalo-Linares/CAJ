import 'package:flutter/material.dart';

// Se genera una variable privada, ya que solo se utilizara en este entorno
// Esta variable sera un mapa (Map) que tendra dos valores.
// Por un lado un string como llave, y un IconData como valor de esa llave
final Map<String, IconData> _icons = {
  'home': Icons.home,
  'calendar_month_rounded': Icons.calendar_month_rounded,
  'menu_book_rounded': Icons.menu_book_rounded,
  'account_circle_rounded': Icons.account_circle_rounded,

  'credit_card_rounded': Icons.credit_card_rounded,
  'people_alt_outlined': Icons.people_alt_outlined,
  'admin_panel_settings_rounded': Icons.admin_panel_settings_rounded,
  'payments_rounded': Icons.payments_rounded,
};

// Se genera un método que devuelve un icono, recibiendo como parámetro un string con el nombre del mismo
Icon getIcon(String nombreIcono, {Color? color}) {
  // Se retorna un widget de tipo Icon con el parámetro de tipo string
  // que recibe como parametro getIcon
  // Tambien se agrega la propiedad de color del mismo
  return Icon(_icons[nombreIcono], color: color);
}
