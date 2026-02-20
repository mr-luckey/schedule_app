class PaymentMethod {
  final int id;
  final String title;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethod({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
