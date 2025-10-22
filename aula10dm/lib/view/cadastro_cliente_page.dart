import 'package:exdb/view/lista_cidade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cliente_viewmodel.dart';

// Tela de cadastro/edição (View)
// NÃO importa Model - usa apenas DTO do ViewModel
class CadastroClientePage extends StatefulWidget {
  // Recebe um DTO opcional: se for null => criação; senão => edição
  final ClienteDTO? clienteDTO;
  const CadastroClientePage({super.key, this.clienteDTO});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  // Form key para validação
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos do formulário
  late TextEditingController _cpfController;
  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _cidadeController;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os valores do DTO (se existir) ou vazios
    _cpfController = TextEditingController(text: widget.clienteDTO?.cpf ?? '');
    _nomeController = TextEditingController(
      text: widget.clienteDTO?.nome ?? '',
    );
    _idadeController = TextEditingController(
      text: widget.clienteDTO?.idade ?? '',
    );
    _dataNascimentoController = TextEditingController(
      text: widget.clienteDTO?.dataNascimento ?? '',
    );
    _cidadeController = TextEditingController(
      text: widget.clienteDTO?.cidadeNascimento ?? '',
    );
  }

  @override
  void dispose() {
    // Libera os controllers
    _cpfController.dispose();
    _nomeController.dispose();
    _idadeController.dispose();
    _dataNascimentoController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  // Função chamada ao salvar (adicionar ou editar)
  Future<void> _salvar() async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) return;

    // Obtém o ViewModel (não escuta mudanças aqui)
    final vm = Provider.of<ClienteViewModel>(context, listen: false);

    // Passa dados primitivos para o ViewModel (NÃO cria objetos Model aqui)
    if (widget.clienteDTO == null) {
      // Novo cliente
      await vm.adicionarCliente(
        cpf: _cpfController.text.trim(),
        nome: _nomeController.text.trim(),
        idade: _idadeController.text.trim(),
        dataNascimento: _dataNascimentoController.text.trim(),
        cidadeNascimento: _cidadeController.text.trim(),
      );
    } else {
      // Atualiza cliente existente
      await vm.editarCliente(
        codigo: widget.clienteDTO!.codigo!,
        cpf: _cpfController.text.trim(),
        nome: _nomeController.text.trim(),
        idade: _idadeController.text.trim(),
        dataNascimento: _dataNascimentoController.text.trim(),
        cidadeNascimento: _cidadeController.text.trim(),
      );
    }

    // Volta para a tela anterior
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.clienteDTO == null ? 'Novo Cliente' : 'Editar Cliente',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo CPF
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o CPF' : null,
              ),

              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),

              // Campo Idade
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a idade' : null,
              ),

              // Campo Data de Nascimento
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe a data de nascimento'
                    : null,
              ),

              // Campo Cidade de Nascimento
              Row(
                children: [
                  // O TextFormField precisa de uma largura definida dentro de um Row.
                  // Usamos Expanded para que ele ocupe o espaço disponível e
                  // evite erros de layout (RenderBox/constraints) dentro do ListView.
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade de Nascimento',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Informe a cidade'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Abre o bottom sheet e espera pela cidade selecionada
                      final result = await showModalBottomSheet<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 300,
                            child: ListaCidadesPage(),
                          );
                        },
                      );

                      // Se o usuário selecionou uma cidade, preenche o campo
                      if (result != null) {
                        // result deve ser um CidadeDTO retornado por ListaCidadesPage
                        try {
                          final dto = result as dynamic;
                          // Atualiza apenas o texto exibido; o salvamento usa o nome
                          setState(() {
                            _cidadeController.text = dto.nome ?? dto.toString();
                          });
                        } catch (_) {
                          // Ignora se o tipo não for o esperado
                        }
                      }
                    },
                    child: const Icon(Icons.search),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Botão de salvar
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
