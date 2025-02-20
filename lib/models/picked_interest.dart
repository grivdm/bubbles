class PickedInterest {
  final String label;
  final String status;

  PickedInterest({required this.label, required this.status});

  factory PickedInterest.fromJson(Map<String, dynamic> json) {
    return PickedInterest(
      label: json['label'],
      status: json['status'],
    );
  }
}
