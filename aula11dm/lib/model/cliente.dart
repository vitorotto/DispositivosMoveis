// Classe que representa o modelo de dados 'Cliente'.
class Cliente {
  // A propriedade 'codigo' é a chave primária
  String? codigo; // pode ser null ao criar um novo cliente

  // Campo id do tipo string para Firebase
  String? id;

  // CPF do cliente (string para manter zeros à esquerda, separadores, etc.)
  String cpf;

  // Nome do cliente
  String nome;

  // Idade do cliente (inteiro)
  int idade;

  // Data de nascimento em formato String (poderia ser DateTime, aqui usamos String para simplicidade)
  String dataNascimento;

  // Cidade de nascimento
  String cidadeNascimento;

  // Construtor com campos obrigatórios (exceto codigo)
  Cliente({
    this.codigo,
    this.id,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.dataNascimento,
    required this.cidadeNascimento,
  });

  // Converte o objeto Cliente em Map<String, dynamic> para inserir/atualizar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo, // pode ser null (SQLite atribuirá autoincrement)
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'idade': idade,
      'dataNascimento': dataNascimento,
      'cidadeNascimento': cidadeNascimento,
    };
  }

  // Cria um objeto Cliente a partir de um Map (resultado de uma query no SQLite)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      codigo: map['codigo'],
      id: map['id'],
      cpf: map['cpf'],
      nome: map['nome'],
      idade: map['idade'],
      dataNascimento: map['dataNascimento'],
      cidadeNascimento: map['cidadeNascimento'],
    );
  }

  /* -- FIREBASE -- */
  // Fábrica (factory) que cria uma instância de Aluno a partir de um JSON.
  // O método recebe um Map que representa o objeto JSON e retorna uma instância de Aluno.
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      codigo: json['codigo'], // Acessa o valor de 'codigo' do JSON.
      id: json['id'], // Acessa o valor de 'id' do JSON.
      cpf: json['cpf'], // Acessa o valor de 'cpf' do JSON.
      nome: json['nome'], // Acessa o valor de 'nome' do JSON.
      idade: json['idade'], // Acessa o valor de 'idade' do JSON.
      dataNascimento:
          json['dataNascimento'], // Acessa o valor de 'dataNascimento' do JSON.
      cidadeNascimento:
          json['cidadeNascimento'], // Acessa o valor de 'cidadeNascimento' do JSON.
    );
  }

  // Método que converte uma instância de Aluno para um objeto JSON (Map<String, dynamic>).
  // Útil para transformar o objeto Aluno em um formato que possa ser serializado e enviado para uma API.
  Map<String, dynamic> toJson() {
    return {
      'codigo':
          codigo, // Mapeia o atributo 'codigo' para o campo 'codigo' no JSON.
      'id':
          id, // Mapeia o atributo 'id' para o campo 'id' no JSON.
      'cpf': cpf, // Mapeia o atributo 'cpf' para o campo 'cpf' no JSON.
      'nome': nome, // Mapeia o atributo 'nome' para o campo 'nome' no JSON.
      'idade': idade, // Mapeia o atributo 'idade' para o campo 'idade' no JSON.
      'dataNascimento':
          dataNascimento, // Mapeia o atributo 'dataNascimento' para o campo 'dataNascimento' no JSON.
      'cidadeNascimento':
          cidadeNascimento, // Mapeia o atributo 'cidadeNascimento' para o campo 'cidadeNascimento' no JSON.
    };
  }
}
