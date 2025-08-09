import 'package:application_mappital/config/const/app_dio.dart';
import 'package:application_mappital/private/service/location_service.dart';
import 'package:application_mappital/private/service/theme_service.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:get/get.dart';

class AppGet {
  void get getInit {
    // Pubilc
    Get.lazyPut(() => AuthService(dio: AppDio().getDio));

    // Private
    Get.lazyPut(() => ThemeService());
    Get.lazyPut(() => LocationService());
  }
}
