// Importa o pacote para uso da câmera
import 'package:camera/camera.dart';
// Importa o pacote principal do Flutter
import 'package:flutter/material.dart';
// Importa o ViewModel que contém a lógica da câmera
import '../viewmodel/camera_viewmodel.dart';
// Importa para manipular arquivos locais (exibir fotos salvas, por exemplo)
import 'dart:io';

// ---------- VIEW ----------
// Esta classe representa a "View" no padrão MVVM.
// É responsável apenas pela interface e interações visuais (UI).
class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

// ---------- STATE ----------
// Classe que mantém o estado e comportamento da CameraView
class _CameraViewState extends State<CameraView> {
  // Instância do ViewModel que contém a lógica da câmera
  final CameraViewModel _viewModel = CameraViewModel();

  // Variável que indica se o aplicativo está gravando vídeo
  bool _gravando = false;

  // -----------------------------------------------------------
  // @override initState()
  // -----------------------------------------------------------
  // Método do ciclo de vida de um StatefulWidget.
  // Ele é chamado **apenas uma vez**, quando o widget é criado.
  // Ideal para inicializações que devem ocorrer antes da exibição da tela,
  // como abrir câmera, conectar a banco de dados, carregar dados, etc.
  @override
  void initState() {
    super.initState(); // Chama a implementação original da classe pai
    _inicializar(); // Inicializa a câmera (processo assíncrono)
  }

  // Método auxiliar para inicializar a câmera
  Future<void> _inicializar() async {
    await _viewModel.inicializarCamera(); // Configura a câmera via ViewModel
    setState(() {}); // Atualiza a interface após a inicialização
  }

  // -----------------------------------------------------------
  // @override dispose()
  // -----------------------------------------------------------
  // Também é um método do ciclo de vida de um StatefulWidget.
  // É chamado **automaticamente quando o widget sai da tela** (por exemplo,
  // ao navegar para outra página ou fechar o app).
  // Serve para liberar recursos que estavam sendo usados — como streams,
  // controladores, animações, ou a própria câmera — evitando vazamento de memória.
  @override
  void dispose() {
    _viewModel.dispose(); // Libera o controller da câmera e outros recursos
    super.dispose(); // Chama o método da classe pai
  }

  // -----------------------------------------------------------
  // build()
  // -----------------------------------------------------------
  // Este método é chamado toda vez que há uma atualização de estado.
  // Ele monta a interface visual da tela.
  @override
  Widget build(BuildContext context) {
    // Enquanto a câmera não for inicializada, mostra um indicador de carregamento
    if (!_viewModel.inicializado) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Estrutura principal da tela (Scaffold)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Câmera - MVVM'),
        backgroundColor: Colors.teal,
        actions: [
          // Ação para retornar a foto em base64 para a tela anterior
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Usar foto',
            onPressed: () {
              if (!_viewModel.temMidia) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nenhuma foto capturada')),
                );
                return;
              }

              if (_viewModel.ehVideo) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Última mídia é um vídeo')),
                );
                return;
              }

              // Retorna a string base64 (pode ser null se falhou a conversão)
              Navigator.pop(context, _viewModel.base64UltimaFoto);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mostra o preview da câmera (imagem ao vivo)
          AspectRatio(
            aspectRatio: _viewModel.controller.value.aspectRatio,
            child: CameraPreview(_viewModel.controller),
          ),

          const SizedBox(height: 16),

          // Linha com os botões de foto e vídeo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botão para tirar foto
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Tirar Foto"),
                onPressed: () async {
                  await _viewModel.tirarFoto(); // Captura a foto
                  setState(() {}); // Atualiza a tela para exibir a nova imagem
                },
              ),

              // Botão para iniciar ou parar gravação de vídeo
              ElevatedButton.icon(
                icon: Icon(_gravando ? Icons.stop : Icons.videocam),
                label: Text(_gravando ? "Parar" : "Gravar"),
                onPressed: () async {
                  if (_gravando) {
                    // Se estiver gravando, para e salva o vídeo
                    await _viewModel.pararGravacao();
                    setState(() => _gravando = false);
                  } else {
                    // Se não estiver, inicia a gravação
                    await _viewModel.iniciarGravacao();
                    setState(() => _gravando = true);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Exibe a última mídia capturada (foto ou vídeo)
          if (_viewModel.temMidia)
            Expanded(
              child: _viewModel.ehVideo
                  // Se for vídeo, mostra o caminho do arquivo
                  ? Center(
                      child: Text(
                        "Vídeo salvo em:\n${_viewModel.caminhoMidia}",
                        textAlign: TextAlign.center,
                      ),
                    )
                  // Se for imagem, exibe a foto capturada
                  : Image.file(File(_viewModel.caminhoMidia!)),
            ),
        ],
      ),
    );
  }
}
