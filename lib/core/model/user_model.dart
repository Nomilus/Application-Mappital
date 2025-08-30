class UserModel {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    this.createdAt,
  });

  factory UserModel.fromModel(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'].toString(),
      name: json['name'].toString(),
      avatar: json['avatar'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }
}
