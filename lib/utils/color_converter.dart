import 'package:flutter/material.dart';

class ColorConverter {
  static Color fromHex(String hex) {
    hex = hex.toUpperCase().replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse(hex, radix: 16));
  }

  static String toHex(Color color) {
    return color.value.toRadixString(16).substring(2);
  }
}
