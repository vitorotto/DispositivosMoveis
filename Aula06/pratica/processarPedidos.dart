import 'dart:convert';
import 'dart:ffi';
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
}

class Cliente {
  final int idCliente;
  final String nome;
  final String email;

  Cliente({
    required this.idCliente,
    required this.nome,
    required this.email,
  });
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
}

void main(List<String> args) {
  
}
