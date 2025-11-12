import 'package:app_aluno_auth2/model/aluno.dart';

abstract class AlunoView {
  void displayAlunos(List<Aluno> alunos);
  void showError(String error);
}
