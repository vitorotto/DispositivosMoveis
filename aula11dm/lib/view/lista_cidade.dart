import 'package:exdb/view/cadastro_cidade_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cidade_viewmodel.dart';

// Tela que exibe a lista e o campo de pesquisa (View)
// NÃO importa Model - usa apenas DTO do ViewModel
class ListaCidadesPage extends StatefulWidget {
  const ListaCidadesPage({super.key});

  @override
  State<ListaCidadesPage> createState() => _ListaCidadesPageState();
}

class _ListaCidadesPageState extends State<ListaCidadesPage> {
  // Controller do campo de pesquisa
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Opcional: poderia carregar aqui, mas o ViewModel já carrega na construção
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o ViewModel via Provider
    final vm = Provider.of<CidadeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidades (MVVM + SQLite)'),
        actions: [
          // Botão para criar novo cliente
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Navega para a tela de cadastro sem passar cliente (novo)
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CadastroCidadePage()),
              );
              // Ao voltar, recarrega a lista com o filtro atual
              await vm.loadCidades(_searchController.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de pesquisa por nome
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
                // Chama o ViewModel para atualizar a lista com o filtro
                await vm.loadCidades(value);
              },
            ),
          ),
          // Lista observando o ViewModel (neste caso, Provider reconstrói o widget)
          Expanded(
            child: vm.cidades.isEmpty
                ? const Center(child: Text('Nenhum cliente encontrado'))
                : ListView.builder(
                    itemCount: vm.cidades.length,
                    itemBuilder: (context, index) {
                      // Usa DTO ao invés de Model
                      final CidadeDTO dto = vm.cidades[index];

                      return ListTile(
                        title: Text(dto.nome), // Dado formatado pelo ViewModel
                        // Ao tocar no item, retornamos a CidadeDTO selecionada ao
                        // chamador (seja um modal ou uma rota). Isso permite que
                        // a tela de cadastro receba a cidade escolhida.
                        onTap: () {
                          Navigator.pop(context, dto);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botão editar
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                // Navega para edição passando o DTO
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CadastroCidadePage(cidadeDTO: dto),
                                  ),
                                );
                                // Recarrega a lista
                                await vm.loadCidades(_searchController.text);
                              },
                            ),
                            // Botão excluir
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // Chama o ViewModel para excluir e atualiza a lista
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
