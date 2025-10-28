import 'package:exdb/view/cadastro_cidade_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';

class ListaCidadesPage extends StatefulWidget {
  const ListaCidadesPage({super.key});

  @override
  State<ListaCidadesPage> createState() => _ListaCidadesPageState();
}

class _ListaCidadesPageState extends State<ListaCidadesPage> {
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
    final vm = Provider.of<CidadeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidades (MVVM + SQLite)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CadastroCidadePage()),
              );
              await vm.loadCidades(_searchController.text);
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
                await vm.loadCidades(value);
              },
            ),
          ),
          Expanded(
            child: vm.cidades.isEmpty
                ? const Center(child: Text('Nenhum cliente encontrado'))
                : ListView.builder(
                    itemCount: vm.cidades.length,
                    itemBuilder: (context, index) {
                      final CidadeDTO dto = vm.cidades[index];

                      return ListTile(
                        title: Text(dto.nome),
                        onTap: () {
                          Navigator.pop(context, dto);
                        },
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
                                        CadastroCidadePage(cidadeDTO: dto),
                                  ),
                                );
                                await vm.loadCidades(_searchController.text);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await vm.removerCidade(dto.id!);
                                await vm.loadCidades(_searchController.text);
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
