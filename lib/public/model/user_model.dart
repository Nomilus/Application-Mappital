class UserModel {
  final String id;
  final String? googleId;
  final String email;
  final String name;
  final String avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.googleId,
    required this.email,
    required this.name,
    required this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      googleId: json['google_id'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
