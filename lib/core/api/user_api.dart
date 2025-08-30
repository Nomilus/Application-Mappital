import 'package:application_mappital/core/model/api_model.dart';
import 'package:application_mappital/core/utility/error_utility.dart';
import 'package:application_mappital/core/utility/snackbar_utility.dart';
import 'package:application_mappital/core/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class UserApi {
  final Dio _dio = GetIt.instance<Dio>();

  Future<UserModel?> googleSignInAuth({required String? idToken}) async {
    if (idToken == null) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ไม่ได้รับ ID token จาก Google Sign-In',
      );
    }

    debugPrint("Id token api: $idToken");

    try {
      final responseApi = await _dio.post(
        'user/google-auth',
        data: {'token': idToken},
      );

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['token'] != null) {
          _dio.options.headers['Authorization'] =
              'Bearer ${response.data['token']}';
        }

        if (response.data['user'] != null) {
          return UserModel.fromModel(response.data['user']);
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }

  Future<UserModel?> userInfoApi({required String id}) async {
    try {
      final responseApi = await _dio.post('user/info', data: {'user_id': id});

      if (responseApi.statusCode == 200) {
        final response = ApiModel.fromModel(responseApi.data);

        if (response.data['user'] != null) {
          return UserModel.fromModel(response.data['user']);
        }
      }
      return null;
    } on DioException catch (e) {
      ErrorUtility.handleDioException(e);
      return null;
    }
  }
}
