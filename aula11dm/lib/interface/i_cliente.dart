import 'package:exdb/model/cliente.dart';


abstract class IClienteRepository {
  Future<void> inserir(Cliente cliente);
  Future<void> atualizar(String id, Cliente cliente);  // Usa String id para ambos
  Future<void> excluir(String id);
  Future<List<Cliente>> buscar({String filtro = ''});
}