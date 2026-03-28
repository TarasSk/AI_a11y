import 'dart:io';

import 'package:ai_a11y/domain/entity/gemini_result.dart';
import 'package:ai_a11y/domain/repository/i_gemini_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final class GeminiRepository implements IGeminiRepository {
  GeminiRepository({required String apiKey}) : _apiKey = apiKey;

  final String _apiKey;

  static const String _modelName = 'gemini-2.5-flash-lite';

  @override
  Future<GeminiResult> describeScreen({
    required String screenshotPath,
    required String tfliteDetections,
    required String systemPrompt,
  }) async {
    try {
      // 1. Read screenshot bytes directly (no base64 round-trip needed).
      final imageBytes = await File(screenshotPath).readAsBytes();

      // 2. Build the Gemini model with system instruction.
      final model = GenerativeModel(
        model: _modelName,
        apiKey: _apiKey,
        systemInstruction: Content.system(systemPrompt),
      );

      // 3. Compose the multimodal prompt: detection summary text + screenshot image.
      final prompt = [
        Content.multi([
          TextPart(
            'UI detection summary from on-device model:\n$tfliteDetections',
          ),
          DataPart('image/png', imageBytes),
        ]),
      ];

      // 4. Send request and extract text response.
      final response = await model.generateContent(prompt);
      final text = response.text;

      if (text == null || text.trim().isEmpty) {
        return const GeminiResult.failure(
          error: 'Gemini returned an empty response.',
        );
      }

      return GeminiResult.success(description: text.trim());
    } on GenerativeAIException catch (e) {
      return GeminiResult.failure(error: 'Gemini API error: ${e.message}');
    } catch (e) {
      return GeminiResult.failure(error: 'Unexpected error: $e');
    }
  }
}

