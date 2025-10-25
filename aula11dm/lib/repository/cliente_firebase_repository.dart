import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exdb/interface/i_cliente.dart';

import '../model/cliente.dart';

class ClienteFirebaseRepository implements IClienteRepository {
  final CollectionReference clientesRef = FirebaseFirestore.instance.collection(
    'clientes',
  );

  @override
  Future<void> inserir(Cliente cliente) async {
    try {
      print("Salvando cliente no Firestore: ${cliente.toJson()}");
      // Adiciona um novo documento na coleção 'clientes'.
      await clientesRef.add(cliente.toJson());

      // Atualiza a lista após adicionar o aluno.
      await buscar();
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      print('Erro ao adicionar aluno: $e');
    }
  }

  @override
  Future<void> atualizar(String? id, Cliente cliente) async {
    try {
      await clientesRef.doc(id).update(cliente.toJson());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      await clientesRef.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<Cliente>> buscar({String filtro = ''}) async {
    try {
      // Obtém os dados da coleção 'clientes' no Firestore.
      QuerySnapshot snapshot = await clientesRef.get();

      // Mapeia os dados para uma lista de objetos Cliente.
      List<Cliente> clientes = snapshot.docs.map((doc) {
        Cliente cliente = Cliente.fromJson(doc.data() as Map<String, dynamic>);
        return cliente;
      }).toList();

      // Aplicar filtro se houver
      if (filtro.isEmpty) {
        // Se filtro vazio, ordenar por nome
        clientes.sort((a, b) => a.nome.compareTo(b.nome));
        return clientes;
      } else {
        // Aplicar filtro no nome (case-insensitive)
        List<Cliente> filtrados = clientes
            .where((c) => c.nome.toLowerCase().contains(filtro.toLowerCase()))
            .toList();
        // Ordenar os filtrados por nome
        filtrados.sort((a, b) => a.nome.compareTo(b.nome));
        return filtrados;
      }
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      print('Erro ao buscar dados: $e');
      return []; // Retornar lista vazia em caso de erro
    }
  }
}
