import 'package:application_mappital/private/service/theme_service.dart';
import 'package:application_mappital/core/model/user_model.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ThemeService _themeService = Get.find<ThemeService>();
  Rxn<UserModel> user = Rxn<UserModel>();

  RxBool get isDarkMode => _themeService.isDarkMode;

  void toggleTheme(bool value) => _themeService.toggleTheme(value);

  @override
  void onInit() {
    user(_authService.currentUser.value);
    super.onInit();
  }

  Future<void> signOut() async {
    await _authService.signOutGoogle();
    Get.offAllNamed("/auth");
  }
}
