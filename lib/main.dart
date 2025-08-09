import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:application_mappital/auth_wrapper.dart';
import 'package:application_mappital/config/const/app_get.dart';
import 'package:application_mappital/config/router/app_router.dart';
import 'package:application_mappital/config/theme/export/app_theme.dart';
import 'package:application_mappital/private/service/theme_service.dart';
import 'package:application_mappital/firebase_options.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await Geolocator.requestPermission();
  AppGet().getInit;
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final ThemeService _themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _themeService.getTheme(),
      initialData: false,
      builder: (context, snapshot) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          getPages: AppRouter().getRoute,
          themeMode: snapshot.data! ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme(context: context).getLightTheme,
          darkTheme: AppTheme(context: context).getDarkTheme,
          home: AuthWrapper(),
        );
      },
    );
  }
}
