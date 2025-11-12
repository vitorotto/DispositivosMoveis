import 'package:flutter/material.dart';
import '../model/aluno.dart';
import '../presenter/aluno_presenter.dart';
import 'aluno_view.dart';
import 'aluno_form_page.dart';

// Define uma página que exibe uma lista de alunos e permite adicionar novos alunos
class AlunoPage extends StatefulWidget {
  @override
  _AlunoPageState createState() => _AlunoPageState();
}

// Define o estado da página de lista de alunos, implementando a interface AlunoView
class _AlunoPageState extends State<AlunoPage> implements AlunoView {
  // O presenter responsável por buscar e adicionar alunos
  late AlunoPresenter presenter;

  // Lista de alunos exibida na página
  List<Aluno> alunos = [];

  // Mensagem de erro que pode ser exibida na página
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    // Inicializa o presenter e busca os alunos
    presenter = AlunoPresenter(this);
    presenter
        .fetchAlunosFirebase(); // Faz a requisição para buscar os alunos no backend
  }

  // Método que atualiza a lista de alunos exibida
  @override
  void displayAlunos(List<Aluno> alunos) {
    setState(() {
      this.alunos = alunos; // Atualiza a lista de alunos
      errorMessage = ''; // Limpa qualquer mensagem de erro
    });
  }

  // Método que exibe uma mensagem de erro se a requisição falhar
  @override
  void showError(String error) {
    setState(() {
      errorMessage = error; // Atualiza a mensagem de erro a ser exibida
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Cor de fundo branco no estilo Instagram
        title: const Text(
          'Lista de Alunos',
          style: TextStyle(
            color: Colors.black, // Texto preto para contraste
            fontWeight: FontWeight.bold, // Título em negrito
            fontSize: 22, // Tamanho da fonte maior
          ),
        ),
        actions: [
          // Botão para adicionar um novo aluno
          IconButton(
            icon: const Icon(Icons.add,
                color: Colors.black), // Ícone preto no estilo minimalista
            onPressed: () async {
              // Abre a tela de cadastro de aluno
              bool? alunoAdicionado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlunoFormPage(presenter: presenter),
                ),
              );

              // Se o aluno foi adicionado com sucesso, atualiza a lista de alunos
              if (alunoAdicionado == true) {
                presenter.fetchAlunosFirebase(); // Recarrega a lista de alunos
              }
            },
          ),
        ],
      ),

      // Verifica se há uma mensagem de erro. Caso contrário, exibe a lista de alunos.
      backgroundColor: Colors.white, // Fundo branco para uma estética clean
      body: errorMessage.isEmpty
          ? ListView.builder(
              itemCount: alunos.length, // Número de itens na lista
              itemBuilder: (context, index) {
                // Para cada aluno, exibe uma linha estilizada com nome, idade e turma
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  elevation: 3, // Elevação para dar profundidade aos cards
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Bordas arredondadas no estilo moderno
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.all(16), // Espaçamento interno no card
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.blueAccent, // Fundo azul no estilo Instagram
                      child: Text(
                        alunos[index].nome[0], // Inicial do nome do aluno
                        style: const TextStyle(
                            color: Colors.white), // Texto branco no avatar
                      ),
                    ),
                    title: Text(
                      alunos[index].nome, // Nome do aluno em destaque
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Nome em negrito
                        fontSize: 18, // Tamanho da fonte maior
                        color: Colors.black, // Texto preto
                      ),
                    ),
                    subtitle: Text(
                      'Idade: ${alunos[index].idade} | Turma: ${alunos[index].turma}', // Detalhes do aluno
                      style: const TextStyle(
                          color: Colors.black54), // Texto com tom mais claro
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                errorMessage, // Exibe a mensagem de erro
                style: const TextStyle(
                    color: Colors.redAccent), // Erro em vermelho para destaque
              ),
            ),
    );
  }
}
