import 'package:exdb/interface/i_cliente.dart';

import '../db/db_helper.dart';
import '../model/cliente.dart';

class ClienteSqliteRepository implements IClienteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> inserir(Cliente cliente) async {
    final db = await _dbHelper.database;
    await db.insert('clientes', cliente.toMap());
  }

  @override
  Future<void> atualizar(String id, Cliente cliente) async {
    final db = await _dbHelper.database;
    String codigo = id;
    await db.update(
      'clientes',
      cliente.toMap(),
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  @override
  Future<void> excluir(String id) async {
    final db = await _dbHelper.database;
    String codigo = id;
    await db.delete(
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
