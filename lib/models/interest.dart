class Interest {
  final String label;
  final String emoji;

  Interest({required this.label, required this.emoji});

  factory Interest.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'label': String label,
          'emoji': String emoji,
        }) {
      return Interest(label: label, emoji: emoji);
    } else {
      throw const FormatException('Unexpected JSON structure');
    }
  }
}
