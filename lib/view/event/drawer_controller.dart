import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:application_mappital/core/model/user_model.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:application_mappital/public/service/hospital_service.dart';
import 'package:application_mappital/public/service/notification_service.dart';
import 'package:get/get.dart';

class DrawerController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final HospitalService _hospitalService = Get.find<HospitalService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final RxList<HospitalModel> hospitalList = <HospitalModel>[].obs;

  UserModel? get currentUser => _authService.currentUser.value;

  int get notification => _notificationService.currentNotification.length;

  @override
  void onInit() {
    super.onInit();
    ever(_hospitalService.currentHospital, (value) {
      hospitalList.clear();
      hospitalList(value);
      hospitalList.refresh();
    });
  }

  Future<void> findHospital(String search) async {
    await _hospitalService.findHospitalBySearch(search: search);
  }

  void removeResults() {
    hospitalList.clear();
    _hospitalService.currentHospital.clear();
  }
}
