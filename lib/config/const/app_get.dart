import 'package:application_mappital/private/service/location_service.dart';
import 'package:application_mappital/private/service/theme_service.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:application_mappital/public/service/hospital_service.dart';
import 'package:application_mappital/public/service/notification_service.dart';
import 'package:get/get.dart';

class AppGet {
  void get init {
    // Pubilc
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => HospitalService());
    Get.lazyPut(() => NotificationService());

    // Private
    Get.lazyPut(() => ThemeService());
    Get.lazyPut(() => LocationService());
  }
}
