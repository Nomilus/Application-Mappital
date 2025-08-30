import 'package:application_mappital/core/model/api_model.dart';
import 'package:application_mappital/core/model/notification_model.dart';
import 'package:application_mappital/core/utility/error_utility.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class NotificationApi {
  final Dio _dio = GetIt.instance<Dio>();

  Future<List<NotificationModel>?> findAllNotification() async {
    try {
      final responseApi = await _dio.get('notification/all');

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['notifications'] != null &&
            response.data['notifications'] is List) {
          return (response.data['notifications'] as List)
              .map((item) => NotificationModel.fromModel(item))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return [];
    }
  }

  Future<NotificationModel?> sendNotification({
    required String title,
    required String message,
    required double latitude,
    required double longitude,
    required NotificationStatus type,
  }) async {
    try {
      final responseApi = await _dio.post(
        'notification/push',
        data: {
          "title": title,
          "message": message,
          "latitude": latitude,
          "longitude": longitude,
          "type": type.name,
        },
      );

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['notification'] != null) {
          return NotificationModel.fromModel(response.data['notification']);
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }

  Future<bool> undoNotification({required String id}) async {
    try {
      final responseApi = await _dio.post(
        'notification/undo',
        data: {'id': id},
      );

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['notification'] != null &&
            response.data['notification'] is bool) {
          return response.data['notification'];
        }
      }
      return false;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return false;
    }
  }
}
