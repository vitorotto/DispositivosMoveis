import 'dart:convert'; // Importa o pacote para codificação e decodificação JSON.
import 'package:app_aluno_auth2/model/aluno.dart'; // Importa o modelo Aluno.
import 'package:http/http.dart'
    as http; // Importa o pacote HTTP para fazer requisições web.
import '../view/aluno_view.dart'; // Importa a interface de visualização AlunoView.
import 'package:cloud_firestore/cloud_firestore.dart';

class AlunoPresenter {
  final AlunoView
  view; // Instância de AlunoView para comunicação entre o Presenter e a View.

  final CollectionReference alunosRef = FirebaseFirestore.instance.collection(
    'alunos',
  );

  // Construtor da classe AlunoPresenter, que inicializa a instância de view.
  AlunoPresenter(this.view);

  // URL da API que fornece o CRUD de alunos. - que tal usar um arquivo env aqui?
  final String apiUrl =
      'https://back-aluno-dcdybdggbkfrguan.brazilsouth-01.azurewebsites.net/alunos';

  // Método que busca os alunos da API de forma assíncrona.
  Future<void> fetchAlunos() async {
    try {
      // Faz a requisição HTTP do tipo GET para a API.
      final response = await http.get(Uri.parse(apiUrl));

      // Verifica se a resposta tem status code 200 (sucesso).
      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta JSON.
        List<dynamic> data = jsonDecode(response.body);

        // Mapeia os dados para uma lista de objetos Aluno.
        List<Aluno> alunos = data.map((json) => Aluno.fromJson(json)).toList();

        // Exibe a lista de alunos na view chamando o método displayAlunos.
        view.displayAlunos(alunos);
      } else {
        // Em caso de erro, exibe a mensagem de erro com o status code.
        view.showError('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      view.showError('Erro: $e');
    }
  }

  // Método para adicionar um aluno à API de forma assíncrona.
  Future<void> addAluno(Aluno aluno) async {
    try {
      // Faz a requisição HTTP do tipo POST para enviar um novo aluno.
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        }, // Define o cabeçalho da requisição.
        body: jsonEncode(
          aluno.toJson(),
        ), // Converte o objeto Aluno para JSON e envia no corpo da requisição.
      );

      // Verifica se a resposta tem status code 201 (Criado com sucesso).
      if (response.statusCode == 201) {
        // Se o aluno foi adicionado com sucesso, atualiza a lista chamando fetchAlunos.
        fetchAlunos();
      } else {
        // Em caso de erro, exibe a mensagem com o status code.
        view.showError('Erro ao adicionar aluno: ${response.statusCode}');
      }
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      view.showError('Erro: $e');
    }
  }

  //firebase
  // Método que busca os alunos do Firestore.
  Future<void> fetchAlunosFirebase() async {
    try {
      // Obtém os dados da coleção 'alunos' no Firestore.
      QuerySnapshot snapshot = await alunosRef.get();

      // Mapeia os dados para uma lista de objetos Aluno.
      List<Aluno> alunos = snapshot.docs.map((doc) {
        return Aluno.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      // Exibe a lista de alunos na view.
      view.displayAlunos(alunos);
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      view.showError('Erro ao buscar dados: $e');
    }
  }

  // Método para adicionar um aluno ao Firestore.
  Future<void> addAlunoFirebase(Aluno aluno) async {
    try {
      print("Salvando aluno no Firestore: ${aluno.toJson()}");
      // Adiciona um novo documento na coleção 'alunos'.
      await alunosRef.add(aluno.toJson());

      // Atualiza a lista após adicionar o aluno.
      fetchAlunosFirebase();
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      view.showError('Erro ao adicionar aluno: $e');
    }
  }
}
