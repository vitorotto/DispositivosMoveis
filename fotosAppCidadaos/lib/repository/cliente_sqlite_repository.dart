import 'package:exdb/interface/i_cliente.dart';

import '../model/cliente.dart';
import '../db/db_helper.dart';

class ClienteSqliteRepository implements IClienteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<int> inserir(Cliente cliente) async {
    final db = await _dbHelper.database;
    return await db.insert('clientes', cliente.toMap());
  }

  @override
  Future<int> atualizar(String id, Cliente cliente) async {
    final db = await _dbHelper.database;
    String codigo = id;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  @override
  Future<int> excluir(String id) async {
    final db = await _dbHelper.database;
    String codigo = id;
    return await db.delete(
      'clientes',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  @override
  Future<List<Cliente>> buscar({String filtro = ''}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = filtro.isEmpty
        ? await db.query('clientes', orderBy: 'nome')
        : await db.query(
            'clientes',
            where: 'nome LIKE ?',
            whereArgs: ['%$filtro%'],
            orderBy: 'nome',
          );
    return maps.map((m) => Cliente.fromMap(m)).toList();
  }
}
