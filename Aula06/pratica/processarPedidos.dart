import 'dart:convert';
import 'dart:io';

class Pedido {
  final int pedidoId;
  final String dataPedido;
  final Cliente cliente;
  final List<ItemPedido> itens;
  final double valorTotalPedido;
  final String status;

  Pedido({
    required this.pedidoId,
    required this.dataPedido,
    required this.cliente,
    required this.itens,
    required this.valorTotalPedido,
    required this.status,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    var itensList = (json['itens'] as List)
        .map((e) => ItemPedido.fromJson(e))
        .toList();

    return Pedido(
      pedidoId: json['id'],
      dataPedido: json['data'],
      cliente: Cliente.fromJson(json['cliente']),
      itens: itensList,
      valorTotalPedido: json['valorTotalPedido'],
      status: json['status'],
    );
  }
}

class Cliente {
  final int idCliente;
  final String nome;
  final String email;

  Cliente({required this.idCliente, required this.nome, required this.email});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['id'],
      nome: json['nome'],
      email: json['email'],
    );
  }
}

class ItemPedido {
  final int produtoId;
  final int? quantidade;
  final double valorUnitario;
  final double valorTotal;

  ItemPedido({
    required this.produtoId,
    required this.quantidade,
    required this.valorUnitario,
    required this.valorTotal,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      produtoId: json['produtoId'],
      quantidade: json['quatidade'],
      valorUnitario: json['valorUnitario'],
      valorTotal: json['valorTotal'],
    );
  }
}

class Produto {
  final int id;
  final String nome;
  final double preco;
  final int estoque;
  final String categoria;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.estoque,
    required this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      preco: json['preco'],
      estoque: json['estoque'],
      categoria: json['categoria'],
    );
  }
}

class ListaPedidos {
  List<Pedido> pedidos;

  ListaPedidos(this.pedidos);

  // Filtrar por cliente
  List<Pedido> filtrarPorCliente(String nomeCliente) {
    return pedidos.where((p) => p.cliente.nome == nomeCliente).toList();
  }

  // Filtrar por produto
  List<Pedido> filtrarPorProduto(int produtoId) {
    return pedidos
        .where((p) => p.itens.any((i) => i.produtoId == produtoId))
        .toList();
  }

  // Ticket médio
  double ticketMedio() {
    if (pedidos.isEmpty) return 0.0;
    double total = pedidos.fold(0, (soma, p) => soma + p.valorTotalPedido);
    return total / pedidos.length;
  }

  // Preço médio
  double precoMedio() {
    List<double> precos = [];
    for (var pedido in pedidos) {
      precos.addAll(pedido.itens.map((i) => i.valorUnitario));
    }
    if (precos.isEmpty) return 0.0;
    return precos.reduce((a, b) => a + b) / precos.length;
  }

  // Total por produto
  Map<int, double> totalPorProduto() {
    Map<int, double> totais = {};
    for (var pedido in pedidos) {
      for (var item in pedido.itens) {
        totais[item.produtoId] =
            (totais[item.produtoId] ?? 0) + item.valorTotal;
      }
    }
    return totais;
  }
}

void main() async {
  Process.run('cls', [], runInShell: true);

  final file = File("Aula06/pratica/pedidos100.json");
  final conteudo = await file.readAsString();
  final data = jsonDecode(conteudo);

  List<Pedido> pedidos = (data['pedidos'] as List)
      .map((e) => Pedido.fromJson(e))
      .toList();

  var listaPedidos = ListaPedidos(pedidos);

  print("Ticket médio: ${listaPedidos.ticketMedio()}");
  print("Preço médio: ${listaPedidos.precoMedio()}");

  var maria = listaPedidos.filtrarPorCliente("Maria Oliveira");
  print("Pedidos da Maria: ${maria.length}");

  var notebook = listaPedidos.filtrarPorProduto(1);
  print("Pedidos com Notebook Gamer: ${notebook.length}");

  print("Total por produto: ${listaPedidos.totalPorProduto()}");
}
