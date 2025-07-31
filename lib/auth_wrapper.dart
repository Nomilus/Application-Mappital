import 'package:flutter/material.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:application_mappital/view/screen/home_screen.dart';
import 'package:application_mappital/view/screen/auth_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final AuthService _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Lottie.asset("assets/icons/animation_logo.json"),
          );
        }

        return Obx(() {
          return _authService.isLoggedIn.value ? HomeScreen() : AuthScreen();
        });
      },
    );
  }
}
