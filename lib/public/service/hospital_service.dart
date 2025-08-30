import 'package:application_mappital/core/api/hospital_api.dart';
import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:application_mappital/public/repository/i_hospital_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalService extends GetxService implements IHospitalService {
  final RxList<HospitalModel> currentHospital = <HospitalModel>[].obs;
  final RxBool isLonding = false.obs;

  final HospitalApi _hospitalApi = HospitalApi();

  @override
  Future<void> createHospital({
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
      isLonding(true);
      await _hospitalApi.createHospitalApi(
        userId: userId,
        title: title,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        opening: opening,
        closing: closing,
        images: images,
        type: type,
        phoneNumber: phoneNumber,
      );
    } finally {
      isLonding(false);
    }
  }

  @override
  Future<void> updateHospital({
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
      isLonding(true);
      await _hospitalApi.updateHospitalApi(
        id: id,
        userId: userId,
        title: title,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        opening: opening,
        closing: closing,
        images: images,
        type: type,
        phoneNumber: phoneNumber,
        deleteImageList: deleteImageList,
      );
    } finally {
      isLonding(false);
    }
  }

  @override
  Future<void> findHospitalBySearch({required String search}) async {
    try {
      isLonding(true);
      currentHospital(
        await _hospitalApi.findHospitalBySearchApi(search: search),
      );
    } finally {
      isLonding(false);
    }
  }

  @override
  Future<void> findHospitalByLocation({required LatLng location}) async {
    try {
      isLonding(true);
      currentHospital(
        await _hospitalApi.findHospitalByLocationApi(location: location),
      );
    } finally {
      isLonding(false);
    }
  }

  @override
  Future<bool> deleteHospital({required int hospitalId}) async {
    if (await _hospitalApi.deleteHospitalApi(hospitalId: hospitalId)) {
      return true;
    }
    return false;
  }
}
