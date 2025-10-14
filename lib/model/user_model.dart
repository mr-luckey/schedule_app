// models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String passwordDigest;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordDigest,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] ?? 0,
      name: json['user']['name'] ?? '',
      email: json['user']['email'] ?? '',
      passwordDigest: json['user']['password_digest'] ?? '',
      isActive: json['user']['is_active'] ?? false,
      createdAt: json['user']['created_at'] ?? '',
      updatedAt: json['user']['updated_at'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password_digest': passwordDigest,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
    };
  }
}