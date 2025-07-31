import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:application_mappital/private/service/local_service.dart';
import 'package:application_mappital/public/model/user_model.dart';
import 'package:application_mappital/public/repository/i_auth_service.dart';

class AuthService extends GetxService implements IAuthService {
  final Dio _dio;
  final LocalService _localService = Get.find<LocalService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = RxBool(false);

  bool _isGoogleSignInInitialized = false;

  AuthService({required Dio dio}) : _dio = dio;

  @override
  void onInit() {
    super.onInit();
    _ensureGoogleSignInInitialized();
    _ensureCheckGoogleSignInInitialized();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await initializeGoogleSignIn();
    }
  }

  Future<void> _ensureCheckGoogleSignInInitialized() async {
    checkGoogleSignIn();
  }

  void _handleSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void _setUser(GoogleSignInAccount account) {
    currentUser(
      UserModel(
        id: account.id,
        email: account.email,
        name: account.displayName ?? "unknown",
        avatar: account.photoUrl ?? "",
        role: Role.user,
      ),
    );
  }

  @override
  Future<void> checkGoogleSignIn() async {
    await _ensureGoogleSignInInitialized();
    if (_googleSignIn.supportsAuthenticate()) {
      try {
        final account = await _googleSignIn.attemptLightweightAuthentication();
        if (account != null) {
          _setUser(account);
          isLoggedIn(true);
        } else {
          isLoggedIn(false);
        }
      } catch (e) {
        isLoggedIn(false);
      }
    }
  }

  @override
  Future<void> initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "271442909805-2odd28bf9fgpuefpf1oe62jfr4su294n.apps.googleusercontent.com",
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      _handleError('Failed to initialize Google Sign-In: $e');
    }
  }

  @override
  Future<void> signInGoogle() async {
    await _ensureGoogleSignInInitialized();
    if (_googleSignIn.supportsAuthenticate()) {
      try {
        GoogleSignInAccount account = await _googleSignIn.authenticate(
          scopeHint: ['email', 'profile'],
        );
        _localService.saveToken(account.authentication.idToken.toString());
        _setUser(account);
        isLoggedIn(true);
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          _handleError('Cancel to sign in with Google');
        } else {
          _handleError('Failed to sign in with Google: ${e.description}');
        }
      } catch (e) {
        _handleError('Unexpected error during Google Sign In');
      }
    }
  }

  @override
  Future<void> signOutGoogle() async {
    await _ensureGoogleSignInInitialized();
    await _googleSignIn.signOut();
    currentUser(null);
    _handleSuccess('User signed out.');
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
}
