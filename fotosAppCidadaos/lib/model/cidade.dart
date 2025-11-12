// Classe que representa o modelo de dados 'Cidade'.
class Cidade {
  // A propriedade 'codigo' é a chave primária (autoincrement)
  String? codigo; // pode ser null ao criar um novo cliente

  // Campo id do tipo string para Firebase
  String? id;

  // Nome da cidade
  String nome;

  // Construtor com campos obrigatórios (exceto codigo)
  Cidade({this.codigo, this.id, required this.nome});

  // Converte o objeto Cidade em Map<String, dynamic> para inserir/atualizar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo, // pode ser null (SQLite atribuirá autoincrement)
      'id': id,
      'nome': nome,
    };
  }

  // Cria um objeto Cidade a partir de um Map (resultado de uma query no SQLite)
  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      codigo: map['codigo']?.toString(),
      id: map['id'],
      nome: map['nome'],
    );
  }

  /* -- FIREBASE -- */
  // Fábrica (factory) que cria uma instância de Cidade a partir de um JSON.
  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(codigo: json['codigo'], id: json['id'], nome: json['nome']);
  }

  // Método que converte uma instância de Cidade para um objeto JSON (Map<String, dynamic>).
  Map<String, dynamic> toJson() {
    return {'codigo': codigo, 'id': id, 'nome': nome};
  }
}
