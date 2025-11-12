import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Classe responsável pela lógica de autenticação com Google e Firebase
class LoginPresenter {
  // Instância do FirebaseAuth para autenticação
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instância do GoogleSignIn — usa construtor nomeado padrão (compatível com versões recentes)
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  // Retorna o usuário atual (null se não autenticado)
  User? get currentUser => _auth.currentUser;

  // Método para autenticação com o Google
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false; // usuário cancelou

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Error in Google Sign-In: $e');
      return false;
    }
  }

  // Login com email e senha
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException (signIn): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error signing in with email: $e');
      rethrow;
    }
  }

  // Registro com email e senha
  Future<UserCredential?> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException (register): ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error registering with email: $e');
      rethrow;
    }
  }

  // Desloga o usuário (do Firebase e do Google se aplicável)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      try {
        // Tenta também desconectar o GoogleSignIn (se o usuário estiver conectado via Google)
        await _googleSignIn.signOut();
      } catch (_) {}
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
