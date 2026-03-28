import 'package:ai_a11y/domain/entity/gemini_result.dart';

abstract class IGeminiRepository {
  /// Sends [screenshotPath] (converted to base64), [tfliteDetections] and
  /// [systemPrompt] to the Gemini API and returns a [GeminiResult].
  Future<GeminiResult> describeScreen({
    required String screenshotPath,
    required String tfliteDetections,
    required String systemPrompt,
  });
}
