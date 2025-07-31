import 'package:application_mappital/view/screen/home_screen.dart';
import 'package:application_mappital/view/screen/auth_screen.dart';
import 'package:application_mappital/view/screen/profile_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  List<GetPage> get getRoute => [
    GetPage(name: "/auth", page: () => AuthScreen()),
    GetPage(name: "/home", page: () => HomeScreen()),
    GetPage(name: "/profile", page: () => ProfileScreen()),
  ];
}
