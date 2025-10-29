import 'package:exdb/firebase_options.dart';
import 'package:exdb/view/lista_cliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/db_helper.dart';
import 'interface/i_cidade.dart';
import 'interface/i_cliente.dart';
import 'repository/cidade_firebase_repository.dart';
import 'repository/cidade_repository.dart';
import 'repository/cliente_firebase_repository.dart';
import 'repository/cliente_sqlite_repository.dart';
import 'viewmodel/cidade_viewmodel.dart';
import 'viewmodel/cliente_viewmodel.dart';

class StorageConfig extends ChangeNotifier {
  bool _useCloud = true;
  bool get useCloud => _useCloud;

  late IClienteRepository _clienteRepository;
  late IAuthRepository _authRepository;

  StorageConfig() {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _useCloud = prefs.getBool('useCloud') ?? true;
    _clienteRepository = _useCloud
        ? ClienteFirebaseRepository()
        : ClienteSqliteRepository();
    _authRepository = _useCloud
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
    _authRepository = value ? CidadeFirebaseRepository() : CidadeRepository();
    notifyListeners();
  }

  IClienteRepository get clienteRepository => _clienteRepository;
  IAuthRepository get cidadeRepository => _authRepository;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  await DatabaseHelper.instance.database;

  final storageConfig = StorageConfig();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: storageConfig),
        ChangeNotifierProxyProvider<StorageConfig, ClienteViewModel>(
          create: (_) => ClienteViewModel(storageConfig.clienteRepository),
          update: (_, config, vm) {
            if (vm != null) {
              vm.repository = config.clienteRepository;
              return vm;
            } else {
              return ClienteViewModel(config.clienteRepository);
            }
          },
        ),
        ChangeNotifierProxyProvider<StorageConfig, CidadeViewModel>(
          create: (_) => CidadeViewModel(storageConfig.cidadeRepository),
          update: (_, config, vm) {
            if (vm != null) {
              vm.repository = config.cidadeRepository;
              return vm;
            } else {
              return CidadeViewModel(config.cidadeRepository);
            }
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Clientes (MVVM + SQLite)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaClientesPage(),
    );
  }
}
