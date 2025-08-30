import 'package:application_mappital/view/screen/form_screen.dart';
import 'package:application_mappital/view/screen/home_screen.dart';
import 'package:application_mappital/view/screen/auth_screen.dart';
import 'package:application_mappital/view/screen/notification_screen.dart';
import 'package:application_mappital/view/screen/profile_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  List<GetPage> get getRoute => [
    GetPage(name: "/auth", page: () => AuthScreen()),
    GetPage(name: "/form", page: () => FormScreen()),
    GetPage(name: "/home", page: () => HomeScreen()),
    GetPage(name: "/notification", page: () => NotificationScreen()),
    GetPage(name: "/profile", page: () => ProfileScreen()),
  ];
}
