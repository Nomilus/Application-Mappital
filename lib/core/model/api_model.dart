class ApiModel<T> {
  final String status;
  final String message;
  final T data;

  ApiModel({required this.status, required this.message, required this.data});

  factory ApiModel.fromModel(Map<String, dynamic> json) {
    return ApiModel(
      status: json['status'].toString(),
      message: json['message'].toString(),
      data: json['data'] as T,
    );
  }
}
