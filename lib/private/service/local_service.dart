import 'package:application_mappital/private/repository/i_local_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService extends GetxService implements ILocalService {
  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idToken', token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idToken');
  }

  @override
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('idToken');
  }
}
