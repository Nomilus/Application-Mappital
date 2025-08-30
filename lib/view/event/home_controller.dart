import 'package:application_mappital/private/service/location_service.dart';
import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:application_mappital/core/model/notification_model.dart';
import 'package:application_mappital/public/service/hospital_service.dart';
import 'package:application_mappital/public/service/notification_service.dart';
import 'package:application_mappital/core/utility/overlay_utility.dart';
import 'package:application_mappital/core/utility/snackbar_utility.dart';
import 'package:application_mappital/view/widget/hospital_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();
  final HospitalService _hospitalService = Get.find<HospitalService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  Rxn<GoogleMapController> mapController = Rxn<GoogleMapController>();
  final RxSet<Marker> _notificationMarkers = <Marker>{}.obs;
  final RxSet<Marker> _hospitalMarkers = <Marker>{}.obs;
  final Rxn<Set<Marker>> markers = Rxn<Set<Marker>>({});

  @override
  void onInit() {
    super.onInit();
    _notificationMarkers(
      _notificationService.currentNotification
          .where((notify) => notify.type == NotificationStatus.danger)
          .map((notify) => createNotifilcationMarker(notify))
          .toSet(),
    );
    _combineMarkers();
  }

  @override
  void onReady() {
    super.onReady();
    ever(_notificationService.currentNotification, (value) {
      _notificationMarkers.clear();
      _notificationMarkers(
        value
            .where((notify) => notify.type == NotificationStatus.danger)
            .map((notify) => createNotifilcationMarker(notify))
            .toSet(),
      );
      _combineMarkers();
    });

    ever(_hospitalService.currentHospital, (value) {
      _hospitalMarkers.clear();
      _hospitalMarkers(
        value.map((hospital) => createHospitalMarker(hospital)).toSet(),
      );
      _combineMarkers();
    });
  }

  void _combineMarkers() {
    markers.value?.clear();
    final combinedSet = _notificationMarkers.toSet().union(
      _hospitalMarkers.toSet(),
    );
    markers.value?.addAll(combinedSet);
    markers.refresh();
  }

  Marker createHospitalMarker(HospitalModel hospital) {
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
          HospitalWidget(hospital: hospital),
          isDismissible: true,
          enableDrag: true,
          isScrollControlled: true,
        );
      },
    );
  }

  Marker createNotifilcationMarker(NotificationModel notify) {
    return Marker(
      markerId: MarkerId(notify.id),
      position: LatLng(notify.latitude, notify.longitude),
      infoWindow: InfoWindow(title: notify.title),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
  }

  Future<void> moveToSelfLocation() async {
    try {
      OverlayUtility.showLoading();
      final currentLocation = await _locationService.getCurrentLocation();
      await mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 16),
      );
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ไม่สามารถรับตำแหน่งปัจจุบันได้',
      );
    } finally {
      OverlayUtility.hideOverlay();
    }
  }

  Future<void> moveToLocation(LatLng location) async {
    try {
      OverlayUtility.showLoading();
      await mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16),
      );
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ไม่สามารถไปยังตำแหน่งที่ต้องการได้',
      );
    } finally {
      OverlayUtility.hideOverlay();
    }
  }
}
