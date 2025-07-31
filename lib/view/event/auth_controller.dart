import 'package:application_mappital/public/service/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

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
