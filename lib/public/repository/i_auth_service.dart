import 'package:application_mappital/core/model/user_model.dart';

abstract class IAuthService {
  Future<UserModel?> userInfo({required String id});
  Future<void> checkGoogleSignIn();
  Future<void> initializeGoogleSignIn();
  Future<void> signInGoogle();
  Future<void> signOutGoogle();
}
