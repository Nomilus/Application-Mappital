import 'package:application_mappital/private/repository/i_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService extends GetxService implements ILocationService {
  @override
  void onInit() {
    _checkPermissionLocation();
    super.onInit();
  }

  @override
  Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();

    return LatLng(position.latitude, position.longitude);
  }

  Future<void> _checkPermissionLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;
  }
}
