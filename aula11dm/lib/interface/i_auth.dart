abstract class IAuthRepository {
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> registerWithEmailAndPassword(String email, String password);
  Future<void> logoutWithEmailAndPassword();
  Future<void> signInWithGoogle();
}
