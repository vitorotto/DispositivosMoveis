import 'package:flutter/material.dart';

import '../presenter/login_presenter.dart';
import 'lista_cliente.dart';

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
              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () async {
                  bool success = await presenter.signInWithGoogle();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login successful!")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListaClientesPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login failed!")),
                    );
                  }
                },
                icon: Image.asset(
                  'assets/google_icon.png',
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