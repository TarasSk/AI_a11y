import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path_provider/path_provider.dart';

final class GemmaService {
  GemmaService({required String token}) : _token = token;

  final String _token;

  InferenceModel? _model;
  InferenceChat? _chat;

  static const modelUrl =
      'https://huggingface.co/google/gemma-3n-E2B-it-litert-lm/resolve/main/gemma-3n-E2B-it-int4.litertlm';

  static const modelUrl1 =
      'https://huggingface.co/google/gemma-3n-E2B-it-litert/resolve/main/gemma-3n-E2B-it-int4.task';

  static const _modelFilename = 'gemma-3n-E2B-it-int4.task';

  /// Returns the path to the model file in the public Downloads directory.
  static Future<String> get modelPath async {
    final externalDir = await getExternalStorageDirectory();
    if (externalDir != null) {
      // getExternalStorageDirectory() returns the app-specific dir:
      // /storage/emulated/0/Android/data/<pkg>/files
      // Navigate 4 levels up to reach the storage root.
      final root = externalDir.parent.parent.parent.parent;
      return '${root.path}/Download/$_modelFilename';
    }
    return '/storage/emulated/0/Download/$_modelFilename';
  }

  Future<bool> isModelInstalled() async {
    final path = await modelPath;
    return File(path).exists();
  }

  Future<void> installModel({void Function(int progress)? onProgress}) async {
    await FlutterGemma.installModel(modelType: ModelType.gemmaIt)
        .fromNetwork(modelUrl1, token: _token)
        .withProgress((p) => onProgress?.call(p))
        .install();
  }

  Future<void> initSession({int maxTokens = 1024}) async {
    _model = await FlutterGemma.getActiveModel(
      maxTokens: maxTokens,
      preferredBackend: PreferredBackend.gpu,
      supportImage: true,
      maxNumImages: 1,
    );
    _chat = await _model!.createChat(supportImage: true);
  }

  Future<String> sendMessage(String text, {Uint8List? imageBytes}) async {
    if (_model == null || _chat == null) {
      throw StateError(
        'GemmaService session is not initialized. Call initSession() first.',
      );
    }
    // Always start a fresh chat for image messages so accumulated context
    // and stale session state don't cause native inference crashes.
    if (imageBytes != null) {
      await _chat?.stopGeneration();
      _chat = await _model!.createChat(supportImage: true);
    }

    final message = imageBytes != null
        ? Message.withImage(text: text, imageBytes: imageBytes, isUser: true)
        : Message.text(text: text, isUser: true);

    await _chat!.addQueryChunk(message);
    final response = await _chat!.generateChatResponse();
    return response is TextResponse ? response.token : '';
  }

  Stream<String> streamMessage(String text, {Uint8List? imageBytes}) {
    final message = imageBytes != null
        ? Message.withImage(text: text, imageBytes: imageBytes, isUser: true)
        : Message.text(text: text, isUser: true);

    return _chat!
        .addQueryChunk(message)
        .asStream()
        .asyncExpand(
          (_) => _chat!
              .generateChatResponseAsync()
              .where((r) => r is TextResponse)
              .cast<TextResponse>()
              .map((r) => r.token),
        );
  }

  Future<void> closeSession() async {
    await _chat?.stopGeneration();
    await _model?.close();
    _chat = null;
    _model = null;
  }
}
