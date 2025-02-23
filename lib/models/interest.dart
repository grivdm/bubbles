import 'dart:ui';

import 'package:bubbles/utils/color_converter.dart';

class Interest {
  final String label;
  final String emoji;
  final Color color;

  Interest({required this.label, required this.emoji, required this.color});

  factory Interest.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'label': String label,
          'emoji': String emoji,
          'color': String color,
        }) {
      return Interest(
          label: label, emoji: emoji, color: ColorConverter.fromHex(color));
    } else {
      throw const FormatException('Unexpected JSON structure');
    }
  }
}
