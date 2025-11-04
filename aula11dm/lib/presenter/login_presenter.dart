import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../repository/auth_repository.dart';

class LoginPresenter {
  final AuthRepository _authRepository;

  LoginPresenter(this._authRepository);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print("Error in Google Sign-In: $e");
      return false;
    }
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _authRepository.loginWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      print("Error in Email Login: $e");
      return false;
    }
  }

  Future<bool> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _authRepository.registerWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      print("Error in Email Registration: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logoutWithEmailAndPassword();
      await _googleSignIn.signOut();
    } catch (e) {
      print("Error in Logout: $e");
    }
  }
}