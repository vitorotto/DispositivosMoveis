import 'package:exdb/model/cidade.dart';
import 'package:flutter/material.dart';

import '../interface/i_cidade.dart';

class CidadeDTO {
  final String? codigo;
  final String? id;
  final String nome;

  CidadeDTO({this.codigo, this.id, required this.nome});

  factory CidadeDTO.fromModel(Cidade cidade) {
    return CidadeDTO(codigo: cidade.codigo, id: cidade.id, nome: cidade.nome);
  }

  Cidade toModel() {
    return Cidade(codigo: codigo, id: id, nome: nome);
  }
}

class CidadeViewModel extends ChangeNotifier {
  IAuthRepository _repository;

  List<Cidade> _cidades = [];

  List<CidadeDTO> get cidades =>
      _cidades.map((c) => CidadeDTO.fromModel(c)).toList();

  String _ultimoFiltro = '';

  CidadeViewModel(this._repository) {
    loadCidades();
  }

  set repository(IAuthRepository newRepository) {
    _repository = newRepository;
    loadCidades(_ultimoFiltro);
  }

  Future<void> loadCidades([String filtro = '']) async {
    _ultimoFiltro = filtro;
    _cidades = await _repository.buscar(filtro: filtro);
    notifyListeners();
  }

  Future<void> adicionarCidade({required String nome}) async {
    final cidade = Cidade(nome: nome);
    await _repository.inserir(cidade);
    await loadCidades(_ultimoFiltro);
  }

  Future<void> editarCidade({String? id, required String nome}) async {
    final cidade = Cidade(id: id, nome: nome);
    if (id != null) {
      await _repository.atualizar(id, cidade);
    }
    await loadCidades(_ultimoFiltro);
  }

  Future<void> removerCidade(String id) async {
    await _repository.excluir(id);
    await loadCidades(_ultimoFiltro);
  }
}
