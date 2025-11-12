import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Instância única (singleton)
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Referência privada ao Database do sqflite
  static Database? _database;

  // Construtor privado
  DatabaseHelper._init();

  // Getter assíncrono para obter o Database (cria se necessário)
  Future<Database> get database async {
    // Se já inicializamos, retornamos a instância existente
    if (_database != null) return _database!;

    // Caso contrário, inicializamos o banco
    _database = await _initDB('clientes.db');
    return _database!;
  }

  // Getter separado para o banco de cidades
  Future<Database> get cidadesDatabase async {
    // Por simplicidade, vamos usar o mesmo banco por enquanto
    // mas na prática seria melhor ter bancos separados
    return database;
  }

  // Inicializa o banco e retorna o Database
  Future<Database> _initDB(String fileName) async {
    // Pega o diretório de documentos da aplicação (onde o DB será salvo)
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Monta o caminho completo até o arquivo do banco
    final dbPath = join(documentsDirectory.path, fileName);

    // Abre (ou cria) o banco de dados passando onCreate e onUpgrade
    return await openDatabase(
      dbPath,
      version: 3, // Nova versão: adiciona coluna fotoBase64
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // SQL de criação das tabelas
  Future _createDB(Database db, int version) async {
    // Cria a tabela 'clientes' com as colunas solicitadas
    await db.execute('''
CREATE TABLE clientes (
codigo INTEGER PRIMARY KEY AUTOINCREMENT,
id TEXT,
cpf TEXT NOT NULL,
nome TEXT NOT NULL,
idade INTEGER NOT NULL,
dataNascimento TEXT NOT NULL,
cidadeNascimento TEXT NOT NULL,
fotoBase64 TEXT
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

  // Método para upgrade do banco de dados
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adiciona coluna 'id' nas tabelas existentes
      await db.execute('ALTER TABLE clientes ADD COLUMN id TEXT');
      await db.execute('ALTER TABLE cidades ADD COLUMN id TEXT');
    }
    // Versão 3: adiciona coluna para armazenar imagem em base64
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE clientes ADD COLUMN fotoBase64 TEXT');
      } catch (_) {
        // Ignora se já existir ou se houver alguma limitação
      }
    }
  }

  // Fecha o banco (quando necessário)
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
