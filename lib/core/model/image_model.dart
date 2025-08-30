class ImageModel {
  final String id;
  final String hospitalId;
  final dynamic path;
  final DateTime createdAt;

  ImageModel({
    required this.id,
    required this.hospitalId,
    required this.path,
    required this.createdAt,
  });

  factory ImageModel.fromModel(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'].toString(),
      hospitalId: json['hospital_id'].toString(),
      path: json['path'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }
}
