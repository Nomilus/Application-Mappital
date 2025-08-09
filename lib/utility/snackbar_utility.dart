import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtility {
  static void error({String? title, required String message}) {
    Get.snackbar(
      title ?? 'Error',
      message,
      barBlur: 7.0,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.surfaceContainerLow.withAlpha(
        (0.8 * 255).toInt(),
      ),
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }

  static void success({String? title, required String message}) {
    Get.snackbar(
      title ?? 'Success',
      message,
      barBlur: 7.0,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.surfaceContainerLow.withAlpha(
        (0.8 * 255).toInt(),
      ),
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  static void info({String? title, required String message}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      barBlur: 7.0,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.surfaceContainerLow.withAlpha(
        (0.8 * 255).toInt(),
      ),
      icon: Icon(Icons.info, color: Get.theme.colorScheme.primary),
    );
  }
}
