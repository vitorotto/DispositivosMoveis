import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Classe responsável pela lógica de autenticação com Google e Firebase
class LoginPresenter {
  // Instância do FirebaseAuth para autenticação
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instância do GoogleSignIn para iniciar o processo de login com Google
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  // Método para autenticação com o Google
  Future<bool> signInWithGoogle() async {
    try {
      // Inicia o fluxo de login com Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Caso o usuário cancele o login, retorna falso
      if (googleUser == null) return false;

      // Obtém as credenciais de autenticação do Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Cria uma credencial do Firebase a partir das credenciais do Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Usa as credenciais para fazer login no Firebase
      await _auth.signInWithCredential(credential);
      return true; // Login bem-sucedido, retorna verdadeiro
    } catch (e) {
      // Em caso de erro, exibe uma mensagem no console e retorna falso
      print("Error in Google Sign-In: $e");
      return false;
    }
  }
}
