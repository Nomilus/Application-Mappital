import 'package:application_mappital/config/mock/hospital_mock.dart';
import 'package:application_mappital/private/service/location_service.dart';
import 'package:application_mappital/public/model/hospital_model.dart';
import 'package:application_mappital/view/screen/hospital_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();

  Rxn<GoogleMapController> mapController = Rxn<GoogleMapController>();
  Rxn<Set<Marker>> markers = Rxn<Set<Marker>>();
  RxBool isLoading = false.obs;
  RxBool isExploring = false.obs;

  @override
  void onInit() {
    try {
      isLoading(true);
      markers(
        mockHospitalList.map((hospital) {
          return createMarker(hospital);
        }).toSet(),
      );
    } finally {
      isLoading(false);
    }
    super.onInit();
  }

  Marker createMarker(HospitalModel hospital) {
    return Marker(
      markerId: MarkerId(hospital.id),
      position: LatLng(hospital.latitude, hospital.longitude),
      infoWindow: InfoWindow(
        title: hospital.title,
        snippet:
            '${hospital.type.toString().split('.').last} • ${hospital.address}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
        Get.bottomSheet(
          HospitalScreen(hospital: hospital),
          isDismissible: true,
          enableDrag: true,
          isScrollControlled: true,
        );
      },
    );
  }

  Future<void> moveToSelfLocation() async {
    try {
      isLoading(true);
      final currentLocation = await _locationService.getCurrentLocation();
      await mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 16),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to get current location",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> moveToLocation(LatLng location) async {
    try {
      isLoading(true);
      await mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16),
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to get current location",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }
}
