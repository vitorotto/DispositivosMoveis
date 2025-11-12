// Importa o pacote da câmera — usado para capturar fotos e vídeos
import 'package:camera/camera.dart';
// Importa para obter diretórios temporários ou permanentes no dispositivo
import 'package:path_provider/path_provider.dart';
// Importa para manipular caminhos de arquivos (ex: juntar diretório + nome do arquivo)
import 'package:path/path.dart' as path;
// Importa para operações com arquivos locais (salvar, ler, deletar, etc.)
import 'dart:io';
import 'dart:convert';
// Importa o modelo de mídia (foto ou vídeo)
import '../model/midia_model.dart';

// ---------- VIEWMODEL ----------
// Esta classe representa o "ViewModel" no padrão MVVM.
// Ela contém a lógica de negócio e manipulação dos dados relacionados à câmera.
// A View (interface) interage com ela, mas não acessa diretamente a câmera.
class CameraViewModel {
  // Controlador da câmera — responsável por iniciar, capturar e gravar
  late CameraController _controller;

  // Flag para indicar se a câmera já foi inicializada
  bool _inicializado = false;

  // Guarda a última mídia capturada (foto ou vídeo)
  MidiaModel? _ultimaMidia;

  // ---------- GETTERS ----------
  // Os getters abaixo expõem dados prontos para a View,
  // mantendo o princípio de encapsulamento (a View não acessa diretamente o controller).

  // Permite que a View acesse o controller da câmera (somente leitura)
  CameraController get controller => _controller;

  // Retorna se a câmera está pronta para uso
  bool get inicializado => _inicializado;

  // Caminho completo do arquivo da última mídia capturada
  String? get caminhoMidia => _ultimaMidia?.caminho;

  // Retorna true se a última mídia for um vídeo
  bool get ehVideo => _ultimaMidia?.ehVideo ?? false;

  // Retorna true se existe uma mídia capturada (foto ou vídeo)
  bool get temMidia => _ultimaMidia != null;

  // Retorna a string base64 da última foto capturada (null se não existir ou se for vídeo)
  String? get base64UltimaFoto => _ultimaMidia?.base64;

  // -----------------------------------------------------------
  // Inicializa a câmera
  // -----------------------------------------------------------
  // Este método busca as câmeras disponíveis no dispositivo,
  // seleciona a primeira (geralmente a traseira) e cria o controller.
  // Em seguida, inicializa o controller e marca o estado como "inicializado".
  Future<void> inicializarCamera() async {
    final cameras =
        await availableCameras(); // Lista todas as câmeras do dispositivo
    final primeiraCamera = cameras.first; // Seleciona a primeira câmera

    // Cria o controller com uma resolução média
    _controller = CameraController(primeiraCamera, ResolutionPreset.medium);

    // Inicializa o controlador (necessário antes de usar)
    await _controller.initialize();

    // Marca como inicializado com sucesso
    _inicializado = true;
  }

  // -----------------------------------------------------------
  // Tira uma foto
  // -----------------------------------------------------------
  // Captura uma imagem da câmera e salva no diretório temporário do dispositivo.
  Future<void> tirarFoto() async {
    // Obtém o diretório temporário do sistema
    final directory = await getTemporaryDirectory();

    // Monta o caminho completo do arquivo (ex: /tmp/123456789.jpg)
    final filePath = path.join(
      directory.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    // Captura a foto usando o controller
    final foto = await _controller.takePicture();

    // Salva o arquivo no caminho definido
    await foto.saveTo(filePath);

    // Lê os bytes do arquivo e converte para base64 (útil para armazenamento em DB ou envio)
    try {
      final bytes = await File(filePath).readAsBytes();
      final b64 = base64Encode(bytes);
      // Atualiza o modelo com a nova mídia (foto) incluindo o base64
      _ultimaMidia = MidiaModel(caminho: filePath, ehVideo: false, base64: b64);
    } catch (e) {
      // Se algo falhar ao ler/converter, persiste apenas o caminho
      _ultimaMidia = MidiaModel(caminho: filePath, ehVideo: false);
    }
  }

  // -----------------------------------------------------------
  // Inicia a gravação de vídeo
  // -----------------------------------------------------------
  // Começa a gravar o vídeo se ainda não estiver gravando.
  Future<void> iniciarGravacao() async {
    if (!_controller.value.isRecordingVideo) {
      await _controller.startVideoRecording();
    }
  }

  // -----------------------------------------------------------
  // Para a gravação e salva o vídeo
  // -----------------------------------------------------------
  // Quando o usuário interrompe a gravação, este método
  // finaliza e salva o vídeo, atualizando o modelo.
  Future<void> pararGravacao() async {
    if (_controller.value.isRecordingVideo) {
      final video = await _controller.stopVideoRecording();
      // Cria um novo modelo de mídia contendo o caminho do vídeo
      _ultimaMidia = MidiaModel(caminho: video.path, ehVideo: true);
    }
  }

  // -----------------------------------------------------------
  // Libera recursos
  // -----------------------------------------------------------
  // Método que deve ser chamado quando a câmera não for mais usada
  // (por exemplo, ao sair da tela), para evitar vazamentos de memória.
  void dispose() {
    _controller.dispose(); // Encerra o controller e libera memória
  }
}
