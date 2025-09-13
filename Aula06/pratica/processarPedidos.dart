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
  final int quantidade;
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

void main(List<String> args) {}
