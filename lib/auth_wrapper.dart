import 'package:flutter/material.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:application_mappital/view/screen/home_screen.dart';
import 'package:application_mappital/view/screen/auth_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class AuthWrapperController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _authService.checkGoogleSignIn();
  }

  bool get isLoading => _authService.isLoading.value;
  bool get isLoggedIn => _authService.isLoggedIn.value;
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthWrapperController>(
      init: AuthWrapperController(),
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading) {
            return Material(
              color: Colors.black,
              child: Center(
                child: Lottie.asset("assets/icons/animation_logo.json"),
              ),
            );
          }
          return controller.isLoggedIn ? HomeScreen() : AuthScreen();
        }).animate().fadeIn(duration: const Duration(seconds: 1));
      },
    );
  }
}
