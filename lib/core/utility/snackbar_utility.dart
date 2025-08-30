import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtility {
  static void error({String? title, required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title ?? 'Error',
        message,
        barBlur: 7.0,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.surfaceContainerLow.withAlpha(
          (0.8 * 255).toInt(),
        ),
        icon: Card(
          color: Get.theme.colorScheme.surfaceContainerLow,
          shape: const CircleBorder(),
          child: Icon(Icons.dangerous, color: Get.theme.colorScheme.error),
        ),
      );
    });
  }

  static void success({String? title, required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title ?? 'Success',
        message,
        barBlur: 7.0,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.surfaceContainerLow.withAlpha(
          (0.8 * 255).toInt(),
        ),
        icon: Card(
          color: Get.theme.colorScheme.surfaceContainerLow,
          shape: const CircleBorder(),
          child: Icon(Icons.check_circle, color: Get.theme.colorScheme.primary),
        ),
      );
    });
  }

  static void info({String? title, required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title ?? 'Info',
        message,
        barBlur: 7.0,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.surfaceContainerLow.withAlpha(
          (0.8 * 255).toInt(),
        ),
        icon: Card(
          color: Get.theme.colorScheme.surfaceContainerLow,
          shape: const CircleBorder(),
          child: Icon(Icons.info, color: Get.theme.colorScheme.secondary),
        ),
      );
    });
  }
}
