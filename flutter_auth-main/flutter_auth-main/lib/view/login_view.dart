import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import 'aluno_page.dart'; // Certifique-se de que o caminho para AlunoPage está correto

class LoginView extends StatelessWidget {
  final LoginPresenter presenter;

  LoginView({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de login
              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Campo de senha
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Para ocultar a senha
              ),
              SizedBox(height: 20),

              // Botão de login com Google com ícone
              ElevatedButton.icon(
                onPressed: () async {
                  bool success = await presenter.signInWithGoogle();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login successful!")),
                    );
                    // Navegar para a tela AlunoPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlunoPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login failed!")),
                    );
                  }
                },
                icon: Image.asset(
                  'assets/google_icon.png', // Caminho do ícone do Google na pasta assets
                  height: 24,
                  width: 24,
                ),
                label: Text("Login with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
