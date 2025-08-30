import 'package:application_mappital/core/model/api_model.dart';
import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:application_mappital/core/utility/error_utility.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalApi {
  final Dio _dio = GetIt.instance<Dio>();

  Future<HospitalModel?> createHospitalApi({
    required String userId,
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required String opening,
    required String closing,
    required List<String> images,
    required HospitalType type,
    required String phoneNumber,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'title': title,
        'description': description,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'opening': opening,
        'closing': closing,
        'type': type.name,
        'phone_number': phoneNumber,
      });

      for (var imagePath in images) {
        formData.files.add(
          MapEntry('images[]', await MultipartFile.fromFile(imagePath)),
        );
      }

      final responseApi = await _dio.post('hospital/create', data: formData);

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);
        if (response.data['hospital'] != null) {
          return HospitalModel.fromModel(response.data['hospital']);
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }

  Future<HospitalModel?> updateHospitalApi({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    required String opening,
    required String closing,
    required List<String> images,
    required HospitalType type,
    required String phoneNumber,
    required List<int> deleteImageList,
  }) async {
    try {
      final formData = FormData.fromMap({
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'opening': opening,
        'closing': closing,
        'images[]': images,
        'type': type,
        'phone_number': phoneNumber,
        'deletes': deleteImageList.join(','),
      });

      final responseApi = await _dio.post('hospital/update', data: formData);

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['hospital'] != null) {
          return HospitalModel.fromModel(response.data['hospital']);
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }

  Future<List<HospitalModel>?> findHospitalBySearchApi({
    required String search,
  }) async {
    try {
      final responseApi = await _dio.post(
        'hospital/find',
        data: {'search': search},
      );

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data != null && response.data is List) {
          return (response.data as List)
              .map((item) => HospitalModel.fromModel(item))
              .toList();
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }

  Future<List<HospitalModel>?> findHospitalByLocationApi({
    required LatLng location,
  }) async {
    try {
      final responseApi = await _dio.post(
        'hospital/find',
        data: {'lat': location.latitude, 'long': location.longitude},
      );

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data != null && response.data is List) {
          return (response.data as List)
              .map((item) => HospitalModel.fromModel(item))
              .toList();
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }

  Future<bool> deleteHospitalApi({required int hospitalId}) async {
    try {
      final responseApi = await _dio.delete(
        'hospital/delete',
        data: {'id': hospitalId},
      );

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['hospital'] != null &&
            response.data['hospital'] is bool) {
          return response.data['hospital'] as bool;
        }
      }
      return false;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return false;
    }
  }
}
