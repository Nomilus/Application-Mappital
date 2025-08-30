import 'dart:async';
import 'package:application_mappital/core/api/user_api.dart';
import 'package:application_mappital/core/utility/error_utility.dart';
import 'package:application_mappital/core/utility/snackbar_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:application_mappital/core/model/user_model.dart';
import 'package:application_mappital/public/repository/i_auth_service.dart';

class AuthService extends GetxService implements IAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;

  final UserApi _userApi = UserApi();

  List<String> scopes = ['email', 'profile', 'openid'];
  bool _isGoogleSignInInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  Future<void> _setCurrentUser(String? idToken) async {
    currentUser(await _userApi.googleSignInAuth(idToken: idToken));
    if (currentUser.value != null) {
      isLoggedIn(true);
    }
  }

  Future<void> _initializeService() async {
    await _ensureGoogleSignInInitialized();
    await checkGoogleSignIn();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await initializeGoogleSignIn();
    }
  }

  Future<void> _silentFirebaseSignIn(GoogleSignInAccount account) async {
    try {
      final GoogleSignInAuthentication googleAuth = account.authentication;

      if (googleAuth.idToken != null) {
        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        _setCurrentUser(googleAuth.idToken);

        await _firebaseAuth.signInWithCredential(credential);
      }
    } on GoogleSignInException catch (e) {
      ErrorUtility.handleGoogleSignInException(e);
    } on FirebaseAuthException catch (e) {
      ErrorUtility.handleFirebaseAuthException(e);
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message:
            'ข้อผิดพลาดที่ไม่คาดคิดระหว่างการลงชื่อเข้าใช้งาน Google อีกครั้ง',
      );
    }
  }

  @override
  Future<UserModel?> userInfo({required String id}) async {
    return await _userApi.userInfoApi(id: id);
  }

  @override
  Future<void> checkGoogleSignIn() async {
    await _ensureGoogleSignInInitialized();
    isLoading(true);
    if (_googleSignIn.supportsAuthenticate()) {
      try {
        final account = await _googleSignIn.attemptLightweightAuthentication();
        if (account != null) {
          await _silentFirebaseSignIn(account);
        }
      } on GoogleSignInException catch (e) {
        ErrorUtility.handleGoogleSignInException(e);
      } on FirebaseAuthException catch (e) {
        ErrorUtility.handleFirebaseAuthException(e);
      } catch (e) {
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด',
          message: 'ไม่สามารถเข้าสู่ระบบอีกครั้งด้วย Google ',
        );
      } finally {
        isLoading(false);
      }
    }
  }

  @override
  Future<void> initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ไม่สามารถเริ่มต้นการลงชื่อเข้าใช้ Google ได้: $e',
      );
    }
  }

  @override
  Future<void> signInGoogle() async {
    await _ensureGoogleSignInInitialized();

    if (!_googleSignIn.supportsAuthenticate()) {
      SnackbarUtility.error(
        title: 'แจ้งเตือน',
        message: 'การลงชื่อเข้าใช้ด้วย Google ไม่รองรับบนแพลตฟอร์มนี้',
      );
      return;
    }

    isLoading(true);
    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );

      GoogleSignInClientAuthorization? client;
      if (scopes.isNotEmpty) {
        client = await account.authorizationClient.authorizationForScopes(
          scopes,
        );

        if (client == null) {
          try {
            client = await account.authorizationClient.authorizeScopes(scopes);
          } catch (e) {
            SnackbarUtility.error(
              title: 'แจ้งเตือน',
              message: 'ไม่สามารถได้รับสิทธิ์ที่จำเป็นได้',
            );
            return;
          }
        }
      }

      final GoogleSignInAuthentication googleAuth = account.authentication;

      if (googleAuth.idToken == null) {
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด',
          message: 'ไม่สามารถรับ ID token จาก Google Sign-In ได้',
        );
        return;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: client?.accessToken,
        idToken: googleAuth.idToken,
      );

      _setCurrentUser(googleAuth.idToken);

      await _firebaseAuth.signInWithCredential(credential);

      SnackbarUtility.success(
        title: 'เข้าสู่ระบบ',
        message: 'ลงชื่อเข้าใช้สำเร็จ',
      );
    } on GoogleSignInException catch (e) {
      ErrorUtility.handleGoogleSignInException(e);
    } on FirebaseAuthException catch (e) {
      ErrorUtility.handleFirebaseAuthException(e);
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ข้อผิดพลาดที่ไม่คาดคิดระหว่างการลงชื่อเข้าใช้ Google',
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> signOutGoogle() async {
    isLoading(true);
    try {
      await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);

      SnackbarUtility.info(title: 'แจ้งเตือน', message: 'ผู้ใช้ออกจากระบบแล้ว');
    } on GoogleSignInException catch (e) {
      ErrorUtility.handleGoogleSignInException(e);
    } on FirebaseAuthException catch (e) {
      ErrorUtility.handleFirebaseAuthException(e);
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ไม่สามารถออกจากระบบได้',
      );
    } finally {
      isLoading(false);
    }
  }
}
