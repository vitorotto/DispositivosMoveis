import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';
import '../main.dart';
import 'cadastro_cliente_page.dart';

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ClienteViewModel>(context);
    final config = Provider.of<StorageConfig>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes (MVVM + SQLite)'),
        actions: [
          Switch(
            value: config.useCloud,
            onChanged: (value) async {
              await config.setUseCloud(value);
              await vm.loadClientes(_searchController.text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CadastroClientePage()),
              );
              await vm.loadClientes(_searchController.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) async {
                await vm.loadClientes(value);
              },
            ),
          ),
          Expanded(
            child: vm.clientes.isEmpty
                ? const Center(child: Text('Nenhum cliente encontrado'))
                : ListView.builder(
                    itemCount: vm.clientes.length,
                    itemBuilder: (context, index) {
                      final ClienteDTO dto = vm.clientes[index];
                      return ListTile(
                        title: Text(dto.nome),
                        subtitle: Text(
                          dto.subtitulo,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CadastroClientePage(clienteDTO: dto),
                                  ),
                                );
                                await vm.loadClientes(_searchController.text);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await vm.removerCliente(dto.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
