class Aluno {
  // Definição dos atributos da classe Aluno: código, nome, idade e turma.
  final int codigo;
  final String nome;
  final int idade;
  final String turma;

  // Construtor da classe Aluno. Os atributos são marcados como required (obrigatórios).
  Aluno({
    required this.codigo,
    required this.nome,
    required this.idade,
    required this.turma,
  });

  // Fábrica (factory) que cria uma instância de Aluno a partir de um JSON.
  // O método recebe um Map que representa o objeto JSON e retorna uma instância de Aluno.
  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      codigo: json['codigo'], // Acessa o valor de 'codigo' do JSON.
      nome: json['nome'], // Acessa o valor de 'nome' do JSON.
      idade: json['idade'], // Acessa o valor de 'idade' do JSON.
      turma: json['turma'], // Acessa o valor de 'turma' do JSON.
    );
  }

  // Método que converte uma instância de Aluno para um objeto JSON (Map<String, dynamic>).
  // Útil para transformar o objeto Aluno em um formato que possa ser serializado e enviado para uma API.
  Map<String, dynamic> toJson() {
    return {
      'codigo':
          codigo, // Mapeia o atributo 'codigo' para o campo 'codigo' no JSON.
      'nome': nome, // Mapeia o atributo 'nome' para o campo 'nome' no JSON.
      'idade': idade, // Mapeia o atributo 'idade' para o campo 'idade' no JSON.
      'turma': turma, // Mapeia o atributo 'turma' para o campo 'turma' no JSON.
    };
  }
}
