import 'package:application_mappital/private/service/theme_service.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ThemeService _themeService = Get.find<ThemeService>();
  final RxBool isLoading = false.obs;

  RxBool get isDarkMode => _themeService.isDarkMode;

  void toggleTheme() {
    final mode = !_themeService.isDarkMode.value;
    _themeService.toggleTheme(mode);
  }

  Future<void> submitSignInWithGoogle() async {
    try {
      isLoading(true);

      await _authService.signInGoogle();

      if (_authService.isLoggedIn.value) {
        Get.offAllNamed("/home");
      }
    } finally {
      isLoading(false);
    }
  }
}
