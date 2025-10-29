import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exdb/interface/i_cidade.dart';

import '../model/cidade.dart';

class CidadeFirebaseRepository implements IAuthRepository {
  final CollectionReference cidadesRef = FirebaseFirestore.instance.collection(
    'cidades',
  );

  @override
  Future<void> inserir(Cidade cidade) async {
    try {
      print("Salvando cidade no Firestore: ${cidade.toJson()}");
      await cidadesRef.add(cidade.toJson());

      await buscar();
    } catch (e) {
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
      QuerySnapshot snapshot = await cidadesRef.get();

      List<Cidade> cidades = snapshot.docs.map((doc) {
        Cidade cidade = Cidade.fromJson(doc.data() as Map<String, dynamic>);
        cidade.id = doc.id;
        try {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('codigo')) {
            cidade.codigo = data['codigo']?.toString();
          }
        } catch (_) {}
        return cidade;
      }).toList();

      if (filtro.isEmpty) {
        cidades.sort((a, b) => a.nome.compareTo(b.nome));
        return cidades;
      } else {
        List<Cidade> filtrados = cidades
            .where((c) => c.nome.toLowerCase().contains(filtro.toLowerCase()))
            .toList();
        filtrados.sort((a, b) => a.nome.compareTo(b.nome));
        return filtrados;
      }
    } catch (e) {
      print('Erro ao buscar cidades: $e');
      return [];
    }
  }
}
