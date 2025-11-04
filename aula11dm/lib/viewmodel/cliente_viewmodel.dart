import 'package:flutter/material.dart';

import '../interface/i_cliente.dart';
import '../model/cliente.dart';
import '../repository/auth_repository.dart';

class ClienteDTO {
  final String? codigo;
  final String? id;
  final String cpf;
  final String nome;
  final String idade;
  final String email;
  final String password;
  final String dataNascimento;
  final String cidadeNascimento;
  final String subtitulo;

  ClienteDTO({
    this.codigo,
    this.id,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.email,
    required this.password,
    required this.dataNascimento,
    required this.cidadeNascimento,
    required this.subtitulo,
  });

  factory ClienteDTO.fromModel(Cliente cliente) {
    return ClienteDTO(
      codigo: cliente.codigo,
      id: cliente.id,
      cpf: cliente.cpf,
      nome: cliente.nome,
      idade: cliente.idade.toString(),
      email: cliente.email,
      password: cliente.password,
      dataNascimento: cliente.dataNascimento,
      cidadeNascimento: cliente.cidadeNascimento,
      subtitulo: 'CPF: ${cliente.cpf} · ${cliente.cidadeNascimento}',
    );
  }

  Cliente toModel() {
    return Cliente(
      codigo: codigo,
      id: id,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      email: email,
      password: password,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );
  }
}

class ClienteViewModel extends ChangeNotifier {
  IClienteRepository _repository;
  AuthRepository? _authRepository;

  List<Cliente> _clientes = [];

  List<ClienteDTO> get clientes =>
      _clientes.map((c) => ClienteDTO.fromModel(c)).toList();

  String _ultimoFiltro = '';

  ClienteViewModel(this._repository, [this._authRepository]) {
    loadClientes();
  }

  set repository(IClienteRepository newRepository) {
    _repository = newRepository;
    loadClientes(_ultimoFiltro);
  }

  Future<void> loadClientes([String filtro = '']) async {
    _ultimoFiltro = filtro;
    _clientes = await _repository.buscar(filtro: filtro);
    notifyListeners();
  }

  Future<void> adicionarCliente({
    required String cpf,
    required String nome,
    required String idade,
    required String email,
    required String password,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    final cliente = Cliente(
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      email: email,
      password: password,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );

    if (_authRepository != null) {
      try {
        await _authRepository!.registerWithEmailAndPassword(email, password);
        print('Usuário criado no Firebase Auth: $email');
      } catch (e) {
        print('Erro ao criar usuário no Firebase Auth: $e');
      }
    }

    await _repository.inserir(cliente);
    await loadClientes(_ultimoFiltro);
  }

  Future<void> editarCliente({
    String? codigo,
    String? id,
    required String cpf,
    required String nome,
    required String idade,
    required String email,
    required String password,
    required String dataNascimento,
    required String cidadeNascimento,
  }) async {
    final cliente = Cliente(
      codigo: codigo,
      id: id,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      email: email,
      password: password,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );
    if (id != null) {
      await _repository.atualizar(id, cliente);
    }
    await loadClientes(_ultimoFiltro);
  }

  Future<void> removerCliente(String? id) async {
    if (id != null) {
      await _repository.excluir(id);
    }
    await loadClientes(_ultimoFiltro);
  }
}
