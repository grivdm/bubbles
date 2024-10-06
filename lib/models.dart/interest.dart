class Interest {
  final String name;
  final String icon;

  Interest({required this.name, required this.icon});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      name: json['label'],
      icon: json['emoji'],
    );
  }
}
