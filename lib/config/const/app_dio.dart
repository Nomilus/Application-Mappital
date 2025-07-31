import 'package:dio/dio.dart';
class AppDio {
  Dio get getDio => Dio(
    BaseOptions(
      baseUrl: 'https://your-api-url.com/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );
}
