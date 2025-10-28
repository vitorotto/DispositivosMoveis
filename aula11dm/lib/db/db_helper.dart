import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('clientes.db');
    return _database!;
  }

  Future<Database> get cidadesDatabase async {
    return database;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, fileName);

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE clientes (
codigo INTEGER PRIMARY KEY AUTOINCREMENT,
id TEXT,
cpf TEXT NOT NULL,
nome TEXT NOT NULL,
idade INTEGER NOT NULL,
dataNascimento TEXT NOT NULL,
cidadeNascimento TEXT NOT NULL
)
''');
    await db.execute('''
CREATE TABLE cidades (
codigo INTEGER PRIMARY KEY AUTOINCREMENT,
id TEXT,
nome TEXT NOT NULL
)
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE clientes ADD COLUMN id TEXT');
      await db.execute('ALTER TABLE cidades ADD COLUMN id TEXT');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
