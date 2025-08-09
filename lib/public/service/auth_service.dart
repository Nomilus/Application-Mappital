import 'dart:async';
import 'package:application_mappital/utility/snackbar_utility.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:application_mappital/public/model/user_model.dart';
import 'package:application_mappital/public/repository/i_auth_service.dart';

class AuthService extends GetxService implements IAuthService {
  AuthService({required Dio dio}) : _dio = dio;

  final Dio _dio;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = RxBool(false);

  bool _isGoogleSignInInitialized = false;

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

  void _setUser(GoogleSignInAccount account) {
    currentUser(
      UserModel(
        id: account.id,
        email: account.email,
        name: account.displayName ?? "unknown",
        avatar: account.photoUrl ?? "",
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
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          SnackbarUtility.error(message: 'Cancel to sign in with Google');
        } else {
          SnackbarUtility.error(
            message: 'Failed to sign in with Google: ${e.description}',
          );
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
      SnackbarUtility.error(message: 'Failed to initialize Google Sign-In: $e');
    }
  }

  @override
  Future<void> signInGoogle() async {
    await _ensureGoogleSignInInitialized();
    if (_googleSignIn.supportsAuthenticate()) {
      try {
        GoogleSignInAccount account = await _googleSignIn.authenticate(
          scopeHint: ['email', 'profile', 'openid'],
        );
        _setUser(account);
        isLoggedIn(true);
        SnackbarUtility.success(message: 'Sign in successfully');
      } on GoogleSignInException catch (e) {
        switch (e.code) {
          case GoogleSignInExceptionCode.canceled:
            SnackbarUtility.error(message: 'Sign in was cancelled');
            break;
          case GoogleSignInExceptionCode.unknownError:
            SnackbarUtility.error(message: 'Sign in failed');
            break;
          default:
            SnackbarUtility.error(
              message: 'Failed to sign in with Google: ${e.description}',
            );
        }
      } catch (e) {
        SnackbarUtility.error(
          message: 'Unexpected error during Google Sign In',
        );
      }
    }
  }

  @override
  Future<void> signOutGoogle() async {
    await _ensureGoogleSignInInitialized();
    await _googleSignIn.signOut();
    currentUser(null);
    SnackbarUtility.info(message: 'User signed out.');
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
}
