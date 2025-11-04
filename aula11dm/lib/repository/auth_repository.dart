import 'package:exdb/interface/i_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Nenhum usuario encontrado.');
        throw e;
      } else if (e.code == 'wrong-password') {
        print('Senha incorreta.');
        throw e;
      } else {
        throw e;
      }
    }
  }

  @override
  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
        await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Senha esta muito fraca.');
        throw e;
      } else if (e.code == 'email-already-in-use') {
        print('Email ja existe.');
        throw e;
      } else {
        throw e;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<void> logoutWithEmailAndPassword() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  @override
  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return false;
    
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    return userCredential.user != null;
  }
}
