class ApiModel<T> {
  final bool success;
  final T data;

  ApiModel({required this.success, required this.data});

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(success: json['success'] as bool, data: json['data'] as T);
  }
}
