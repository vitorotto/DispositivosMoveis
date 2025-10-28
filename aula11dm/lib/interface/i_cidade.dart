import 'package:exdb/model/cidade.dart';

abstract class ICidadeRepository {
  Future<void> inserir(Cidade cidade);
  Future<void> atualizar(String id, Cidade cidade);
  Future<void> excluir(String id);
  Future<List<Cidade>> buscar({String filtro = ''});
}
