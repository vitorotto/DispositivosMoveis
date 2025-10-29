import '../db/db_helper.dart';
import '../interface/i_cidade.dart';
import '../model/cidade.dart';

class CidadeRepository implements IAuthRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> inserir(Cidade cidade) async {
    final db = await _dbHelper.database;
    await db.insert('cidades', cidade.toMap());
  }

  @override
  Future<void> atualizar(String id, Cidade cidade) async {
    final db = await _dbHelper.database;
    int codigo = int.tryParse(id) ?? 0;
    await db.update(
      'cidades',
      cidade.toMap(),
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  @override
  Future<void> excluir(String id) async {
    final db = await _dbHelper.database;
    int codigo = int.tryParse(id) ?? 0;
    await db.delete('cidades', where: 'codigo = ?', whereArgs: [codigo]);
  }

  @override
  Future<List<Cidade>> buscar({String filtro = ''}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = filtro.isEmpty
        ? await db.query('cidades', orderBy: 'nome')
        : await db.query(
            'cidades',
            where: 'nome LIKE ?',
            whereArgs: ['%$filtro%'],
            orderBy: 'nome',
          );
    return maps.map((m) => Cidade.fromMap(m)).toList();
  }
}
