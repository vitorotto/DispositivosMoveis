import 'package:exdb/view/lista_cliente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/cliente_viewmodel.dart';
import 'repository/cliente_repository.dart';
import 'viewmodel/cidade_viewmodel.dart';
import 'repository/cidade_repository.dart';
import 'db/db_helper.dart';

// Ponto de entrada da aplicação
Future<void> main() async {
  // Garante que plugins nativos estejam inicializados antes de usar path_provider/sqflite
  WidgetsFlutterBinding.ensureInitialized();

  // (Opcional) Inicializa o banco explicitamente para evitar atrasos na primeira operação
  await DatabaseHelper.instance.database;

  // Executa o app dentro de um Provider que injeta o ViewModel (MVVM)
  runApp(
    MultiProvider(
      providers: [
        // Fornece uma instância de ClienteViewModel para toda a árvore de widgets
        ChangeNotifierProvider(
          create: (_) => ClienteViewModel(ClienteRepository()),
        ),
        // Fornece uma instância de CidadeViewModel para as telas de cidades
        ChangeNotifierProvider(
          create: (_) => CidadeViewModel(CidadeRepository()),
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
      home: const ListaClientesPage(),
    );
  }
}
