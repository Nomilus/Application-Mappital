import 'package:application_mappital/config/const/app_dio.dart';
import 'package:application_mappital/config/const/app_permission.dart';
import 'package:application_mappital/config/const/app_websocket.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:application_mappital/auth_wrapper.dart';
import 'package:application_mappital/config/const/app_get.dart';
import 'package:application_mappital/config/router/app_router.dart';
import 'package:application_mappital/config/theme/export/app_theme.dart';
import 'package:application_mappital/private/service/theme_service.dart';
import 'package:application_mappital/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppPermission().init;
  AppGet().init;
  AppDio().init;
  AppWebsocket().init;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
          home: const AuthWrapper(),
        );
      },
    );
  }
}
