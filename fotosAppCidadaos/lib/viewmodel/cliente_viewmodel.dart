import 'package:flutter/material.dart';
import '../model/cliente.dart';
import '../interface/i_cliente.dart';

// DTO (Data Transfer Object) para expor dados formatados à View
// A View NÃO deve acessar o Model diretamente
class ClienteDTO {
  final String? codigo;
  final String? id; // firebase
  final String cpf;
  final String nome;
  final String idade;
  final String dataNascimento;
  final String cidadeNascimento;
  final String? fotoBase64;
  final String subtitulo; // Dado formatado para exibição

  ClienteDTO({
    this.codigo,
    this.id,
    required this.cpf,
    required this.nome,
    required this.idade,
    required this.dataNascimento,
    required this.cidadeNascimento,
    this.fotoBase64,
    required this.subtitulo,
  });

  // Converte Model para DTO
  factory ClienteDTO.fromModel(Cliente cliente) {
    return ClienteDTO(
      codigo: cliente.codigo,
      id: cliente.id,
      cpf: cliente.cpf,
      nome: cliente.nome,
      idade: cliente.idade.toString(),
      dataNascimento: cliente.dataNascimento,
      cidadeNascimento: cliente.cidadeNascimento,
      fotoBase64: cliente.fotoBase64,
      subtitulo: 'CPF: ${cliente.cpf} · ${cliente.cidadeNascimento}',
    );
  }

  // Converte DTO para Model
  Cliente toModel() {
    return Cliente(
      codigo: codigo,
      id: id,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
    );
  }
}

// ViewModel que expõe dados e ações para as Views (usa ChangeNotifier para MVVM reativo)
class ClienteViewModel extends ChangeNotifier {
  // Repositório de dados (injeção simples via construtor)
  IClienteRepository _repository;

  // Lista interna de clientes (Model) - privada
  List<Cliente> _clientes = [];

  // Lista pública de DTOs que a View irá observar
  List<ClienteDTO> get clientes =>
      _clientes.map((c) => ClienteDTO.fromModel(c)).toList();

  // Último filtro usado (para manter a lista consistente ao voltar da tela de edição)
  String _ultimoFiltro = '';

  // Construtor recebe o repositório
  ClienteViewModel(this._repository) {
    // Ao construir o ViewModel, carregamos a lista inicial
    loadClientes();
  }

  // Setter para permitir troca dinâmica do repositório
  set repository(IClienteRepository newRepository) {
    _repository = newRepository;
    // Recarrega os dados com o novo repositório
    loadClientes(_ultimoFiltro);
  }

  // Carrega clientes do repositório com filtro opcional
  Future<void> loadClientes([String filtro = '']) async {
    // Guarda o filtro atual
    _ultimoFiltro = filtro;
    // Busca no repositório (por padrão usa o repositório injetado - Firebase)
    _clientes = await _repository.buscar(filtro: filtro);
    // Notifica listeners (Views que usam Provider/Consumer serão atualizadas)
    notifyListeners();
  }

  // Adiciona um cliente (recebe dados primitivos da View)
  Future<void> adicionarCliente({
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
    String? fotoBase64,
  }) async {
    final cliente = Cliente(
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
      fotoBase64: fotoBase64,
    );
    await _repository.inserir(cliente);
    // Recarrega a lista com o último filtro aplicado
    await loadClientes(_ultimoFiltro);
  }

  // Atualiza um cliente (recebe dados primitivos da View)
  Future<void> editarCliente({
    String? codigo,
    String? id,
    required String cpf,
    required String nome,
    required String idade,
    required String dataNascimento,
    required String cidadeNascimento,
    String? fotoBase64,
  }) async {
    final cliente = Cliente(
      codigo: codigo,
      id: id,
      cpf: cpf,
      nome: nome,
      idade: int.tryParse(idade) ?? 0,
      dataNascimento: dataNascimento,
      cidadeNascimento: cidadeNascimento,
      fotoBase64: fotoBase64,
    );
    if (id != null) {
      await _repository.atualizar(id, cliente);
    }
    await loadClientes(_ultimoFiltro);
  }

  // Remove um cliente pelo id
  Future<void> removerCliente(String? id) async {
    if (id != null) {
      await _repository.excluir(id);
    }
    await loadClientes(_ultimoFiltro);
  }
}
