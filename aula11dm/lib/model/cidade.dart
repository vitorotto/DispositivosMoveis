// Classe que representa o modelo de dados 'Cliente'.
class Cidade {
  // A propriedade 'codigo' é a chave primária (autoincrement)
  int? codigo; // pode ser null ao criar um novo cliente

  // Nome do cidade
  String nome;

  // Construtor com campos obrigatórios (exceto codigo)
  Cidade({
    this.codigo,
    required this.nome,
  });

  // Converte o objeto Cliente em Map<String, dynamic> para inserir/atualizar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo, // pode ser null (SQLite atribuirá autoincrement)
      'nome': nome,
    };
  }

  // Cria um objeto Cliente a partir de um Map (resultado de uma query no SQLite)
  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      codigo: map['codigo'],
      nome: map['nome'],
    );
  }
}
