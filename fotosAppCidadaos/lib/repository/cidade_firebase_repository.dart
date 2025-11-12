import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exdb/interface/i_cidade.dart';

import '../model/cidade.dart';

class CidadeFirebaseRepository implements ICidadeRepository {
  final CollectionReference cidadesRef = FirebaseFirestore.instance.collection(
    'cidades',
  );

  @override
  Future<void> inserir(Cidade cidade) async {
    try {
      print("Salvando cidade no Firestore: ${cidade.toJson()}");
      // Adiciona um novo documento na coleção 'cidades'.
      await cidadesRef.add(cidade.toJson());

      // Atualiza a lista após adicionar a cidade.
      await buscar();
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      print('Erro ao adicionar cidade: $e');
    }
  }

  @override
  Future<void> atualizar(String? id, Cidade cidade) async {
    try {
      await cidadesRef.doc(id).update(cidade.toJson());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      await cidadesRef.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<Cidade>> buscar({String filtro = ''}) async {
    try {
      // Obtém os dados da coleção 'cidades' no Firestore.
      QuerySnapshot snapshot = await cidadesRef.get();

      // Mapeia os dados para uma lista de objetos Cidade.
      List<Cidade> cidades = snapshot.docs.map((doc) {
        Cidade cidade = Cidade.fromJson(doc.data() as Map<String, dynamic>);
        // armazena o id do documento para permitir update/delete por id
        cidade.id = doc.id;
        // se o documento tiver campo 'codigo', mantenha-o também
        try {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('codigo')) {
            cidade.codigo = data['codigo']?.toString();
          }
        } catch (_) {}
        return cidade;
      }).toList();

      // Aplicar filtro se houver
      if (filtro.isEmpty) {
        // Se filtro vazio, ordenar por nome
        cidades.sort((a, b) => a.nome.compareTo(b.nome));
        return cidades;
      } else {
        // Aplicar filtro no nome (case-insensitive)
        List<Cidade> filtrados = cidades
            .where((c) => c.nome.toLowerCase().contains(filtro.toLowerCase()))
            .toList();
        // Ordenar os filtrados por nome
        filtrados.sort((a, b) => a.nome.compareTo(b.nome));
        return filtrados;
      }
    } catch (e) {
      // Captura exceções e exibe a mensagem de erro.
      print('Erro ao buscar cidades: $e');
      return []; // Retornar lista vazia em caso de erro
    }
  }
}
