abstract class IAuthService {
  Future<void> checkGoogleSignIn();
  Future<void> initializeGoogleSignIn();
  Future<void> signInGoogle();
  Future<void> signOutGoogle();
}
