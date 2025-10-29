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
      } else if (e.code == 'wrong-password') {
        print('Senha incorreta.');
      }
    }
  }

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
      } else if (e.code == 'email-already-in-use') {
        print('Email ja existe.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> logoutWithEmailAndPassword() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    return userCredential.user;
  }
}
