import 'package:exdb/firebase_options.dart';
import 'package:exdb/view/lista_cliente.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodel/cliente_viewmodel.dart';
import 'viewmodel/cidade_viewmodel.dart';
import 'repository/cidade_firebase_repository.dart';
import 'repository/cidade_repository.dart';
import 'repository/cliente_firebase_repository.dart';
import 'repository/cliente_sqlite_repository.dart';
import 'db/db_helper.dart';
import 'interface/i_cliente.dart';
import 'interface/i_cidade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view/login_page.dart';

// Provider global para configuração de armazenamento
class StorageConfig extends ChangeNotifier {
  bool _useCloud = true; // padrão: nuvem
  bool get useCloud => _useCloud;

  late IClienteRepository _clienteRepository;
  late ICidadeRepository _cidadeRepository;

  StorageConfig() {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _useCloud = prefs.getBool('useCloud') ?? true;
    _clienteRepository = _useCloud
        ? ClienteFirebaseRepository()
        : ClienteSqliteRepository();
    _cidadeRepository = _useCloud
        ? CidadeFirebaseRepository()
        : CidadeRepository();
    notifyListeners();
  }

  Future<void> setUseCloud(bool value) async {
    _useCloud = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useCloud', value);
    _clienteRepository = value
        ? ClienteFirebaseRepository()
        : ClienteSqliteRepository();
    _cidadeRepository = value ? CidadeFirebaseRepository() : CidadeRepository();
    notifyListeners();
  }

  IClienteRepository get clienteRepository => _clienteRepository;
  ICidadeRepository get cidadeRepository => _cidadeRepository;
}

// Ponto de entrada da aplicação
Future<void> main() async {
  // Garante que plugins nativos estejam inicializados antes de usar path_provider/sqflite
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // (Opcional) Inicializa o banco explicitamente para evitar atrasos na primeira operação
  await DatabaseHelper.instance.database;

  // Inicializa configuração global
  final storageConfig = StorageConfig();

  // Executa o app dentro de um Provider que injeta o ViewModel (MVVM)
  runApp(
    MultiProvider(
      providers: [
        // Configuração global de armazenamento
        ChangeNotifierProvider.value(value: storageConfig),
        // Fornece uma instância de ClienteViewModel usando o repositório ativo
        ChangeNotifierProxyProvider<StorageConfig, ClienteViewModel>(
          create: (_) => ClienteViewModel(storageConfig.clienteRepository),
          update: (_, config, vm) {
            if (vm != null) {
              // Atualiza o repositório do ViewModel existente
              vm.repository = config.clienteRepository;
              return vm;
            } else {
              // Cria novo ViewModel se não existir
              return ClienteViewModel(config.clienteRepository);
            }
          },
        ),
        // Fornece uma instância de CidadeViewModel usando o repositório ativo
        ChangeNotifierProxyProvider<StorageConfig, CidadeViewModel>(
          create: (_) => CidadeViewModel(storageConfig.cidadeRepository),
          update: (_, config, vm) {
            if (vm != null) {
              // Atualiza o repositório do ViewModel existente
              vm.repository = config.cidadeRepository;
              return vm;
            } else {
              // Cria novo ViewModel se não existir
              return CidadeViewModel(config.cidadeRepository);
            }
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// Widget raiz da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Clientes (MVVM + SQLite)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const ListaClientesPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
