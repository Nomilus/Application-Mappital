import 'package:flutter/material.dart';
import 'package:application_mappital/private/repository/i_theme_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService implements IThemeService {
  RxBool isDarkMode = true.obs;

  @override
  void onInit() async {
    super.onInit();
    isDarkMode(await getTheme());
  }

  @override
  void toggleTheme(bool value) {
    isDarkMode.value = value;
    saveTheme(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Future<void> saveTheme(bool mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', mode);
  }

  @override
  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }
}
