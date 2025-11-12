// models/midia_model.dart
// Representa a mídia (foto ou vídeo) capturada.

// Representa a mídia (foto ou vídeo) capturada.
class MidiaModel {
  final String caminho; // Caminho do arquivo salvo no dispositivo
  final bool ehVideo; // True se for vídeo, false se for foto
  final String?
  base64; // Conteúdo da imagem convertido para base64 (somente para fotos)

  MidiaModel({required this.caminho, required this.ehVideo, this.base64});

  @override
  String toString() =>
      'MidiaModel(caminho: $caminho, ehVideo: $ehVideo, base64: ${base64 != null ? '<base64:${base64!.length}>' : 'null'})';
}
