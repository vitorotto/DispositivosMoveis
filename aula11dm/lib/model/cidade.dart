class Cidade {
  String? codigo;

  String? id;

  String nome;

  Cidade({this.codigo, this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'id': id,
      'nome': nome,
    };
  }

  factory Cidade.fromMap(Map<String, dynamic> map) {
    return Cidade(
      codigo: map['codigo']?.toString(),
      id: map['id'],
      nome: map['nome'],
    );
  }

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(codigo: json['codigo'], id: json['id'], nome: json['nome']);
  }

  Map<String, dynamic> toJson() {
    return {'codigo': codigo, 'id': id, 'nome': nome};
  }
}
