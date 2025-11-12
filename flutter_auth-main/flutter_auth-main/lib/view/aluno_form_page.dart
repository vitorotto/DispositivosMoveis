import 'package:app_aluno_auth2/model/aluno.dart'; // Importa o modelo Aluno.
import 'package:flutter/material.dart'; // Importa o pacote de UI do Flutter.

import '../presenter/aluno_presenter.dart'; // Importa o AlunoPresenter para a comunicação entre o formulário e o backend.

class AlunoFormPage extends StatefulWidget {
  final AlunoPresenter
  presenter; // O presenter que gerencia a lógica do formulário.

  // Construtor da página de formulário. Recebe o presenter como argumento.
  AlunoFormPage({required this.presenter});

  @override
  _AlunoFormPageState createState() => _AlunoFormPageState(); // Cria o estado da página.
}

class _AlunoFormPageState extends State<AlunoFormPage> {
  final _formKey =
      GlobalKey<
        FormState
      >(); // Chave global para identificar o formulário e validar os campos.
  final _codigoController =
      TextEditingController(); // Controlador para o campo de código do aluno.
  final _nomeController =
      TextEditingController(); // Controlador para o campo de nome.
  final _idadeController =
      TextEditingController(); // Controlador para o campo de idade.
  final _turmaController =
      TextEditingController(); // Controlador para o campo de turma.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Fundo branco no estilo Instagram.
        title: const Text(
          'Cadastrar Aluno', // Título do AppBar.
          style: TextStyle(
            color: Colors.black, // Texto preto.
            fontWeight: FontWeight.bold, // Negrito no estilo clean.
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // Ícone da seta de voltar em preto.
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Define o espaçamento interno.
        child: Form(
          key: _formKey, // Define a chave do formulário para validar.
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os elementos à esquerda.
            children: [
              // Campo de texto para o código do aluno.
              TextFormField(
                controller:
                    _codigoController, // Conecta o controlador ao campo.
                decoration: const InputDecoration(
                  labelText: 'Código', // Texto de rótulo.
                  labelStyle: TextStyle(
                    color: Colors.black, // Texto preto.
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // Borda inferior cinza.
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Borda inferior azul ao focar.
                  ),
                ),
                keyboardType:
                    TextInputType.number, // Tipo de entrada: numérica.
                validator: (value) {
                  // Validação do campo.
                  if (value == null || value.isEmpty) {
                    return 'Informe o código do aluno'; // Mensagem de erro se o campo estiver vazio.
                  }
                  return null; // Sem erro.
                },
              ),
              SizedBox(height: 20), // Espaçamento vertical.
              // Campo de texto para o nome do aluno.
              TextFormField(
                controller: _nomeController, // Conecta o controlador ao campo.
                decoration: const InputDecoration(
                  labelText: 'Nome', // Texto de rótulo.
                  labelStyle: TextStyle(
                    color: Colors.black, // Texto preto.
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // Borda inferior cinza.
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Borda inferior azul ao focar.
                  ),
                ),
                validator: (value) {
                  // Validação do campo.
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do aluno'; // Mensagem de erro se o campo estiver vazio.
                  }
                  return null; // Sem erro.
                },
              ),
              SizedBox(height: 20), // Espaçamento vertical.
              // Campo de texto para a idade do aluno.
              TextFormField(
                controller: _idadeController, // Conecta o controlador ao campo.
                decoration: const InputDecoration(
                  labelText: 'Idade', // Texto de rótulo.
                  labelStyle: TextStyle(
                    color: Colors.black, // Texto preto.
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // Borda inferior cinza.
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Borda inferior azul ao focar.
                  ),
                ),
                keyboardType:
                    TextInputType.number, // Tipo de entrada: numérica.
                validator: (value) {
                  // Validação do campo.
                  if (value == null || value.isEmpty) {
                    return 'Informe a idade do aluno'; // Mensagem de erro se o campo estiver vazio.
                  }
                  return null; // Sem erro.
                },
              ),
              SizedBox(height: 20), // Espaçamento vertical.
              // Campo de texto para a turma do aluno.
              TextFormField(
                controller: _turmaController, // Conecta o controlador ao campo.
                decoration: const InputDecoration(
                  labelText: 'Turma', // Texto de rótulo.
                  labelStyle: TextStyle(
                    color: Colors.black, // Texto preto.
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // Borda inferior cinza.
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Borda inferior azul ao focar.
                  ),
                ),
                validator: (value) {
                  // Validação do campo.
                  if (value == null || value.isEmpty) {
                    return 'Informe a turma do aluno'; // Mensagem de erro se o campo estiver vazio.
                  }
                  return null; // Sem erro.
                },
              ),
              SizedBox(height: 30), // Espaçamento maior antes do botão.
              // Botão para salvar o aluno.
              SizedBox(
                width: double.infinity, // Botão com largura máxima.
                child: ElevatedButton(
                  onPressed: () {
                    // Valida o formulário quando o botão é pressionado.
                    if (_formKey.currentState!.validate()) {
                      // Se todos os campos são válidos, cria uma nova instância de Aluno.
                      Aluno aluno = Aluno(
                        codigo: int.parse(
                          _codigoController.text,
                        ), // Converte o código para int.
                        nome: _nomeController
                            .text, // Atribui o nome do controlador.
                        idade: int.parse(
                          _idadeController.text,
                        ), // Converte a idade para int.
                        turma: _turmaController
                            .text, // Atribui a turma do controlador.
                      );
                      // Chama o método addAluno do presenter para adicionar o aluno.
                      widget.presenter.addAlunoFirebase(aluno).then((_) {
                        // Após adicionar o aluno, fecha a página e retorna true.
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor, // Cor do botão igual ao tema.
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ), // Espaçamento interno vertical.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Borda arredondada no botão.
                    ),
                  ),
                  child: const Text(
                    'Salvar', // Texto do botão.
                    style: TextStyle(
                      color: Colors.white, // Texto branco.
                      fontSize: 18, // Tamanho maior para o texto.
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
