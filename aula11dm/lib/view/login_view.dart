import 'package:flutter/material.dart';

import '../presenter/login_presenter.dart';
import 'lista_cliente.dart';

class LoginView extends StatefulWidget {
  final LoginPresenter presenter;

  LoginView({Key? key, required this.presenter}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha email e senha")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await widget.presenter.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login realizado com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListaClientesPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no login. Verifique suas credenciais.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha email e senha")),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("A senha deve ter pelo menos 6 caracteres")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await widget.presenter.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Conta criada com sucesso!")),
        );
        await _login();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no registro. Tente novamente.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      bool success = await widget.presenter.signInWithGoogle();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login com Google realizado com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListaClientesPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no login com Google")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro no login com Google: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sistema de Clientes',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                enabled: !_isLoading,
              ),
              SizedBox(height: 30),

              if (_isLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: _register,
                      child: Text('Criar Conta'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Ou'),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _loginWithGoogle,
                      icon: Image.asset(
                        'assets/google_icon.png',
                        height: 24,
                        width: 24,
                      ),
                      label: Text("Entrar com Google"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}