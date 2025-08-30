import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class IHospitalService {
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
  });
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
  });
  Future<void> findHospitalBySearch({required String search});
  Future<void> findHospitalByLocation({required LatLng location});
  Future<bool> deleteHospital({required int hospitalId});
}
