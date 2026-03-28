import 'package:ai_a11y/domain/entity/gemini_result.dart';
import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:ai_a11y/domain/repository/i_gemini_repository.dart';
import 'package:ai_a11y/services/tts_service.dart';
import 'package:ai_a11y/services/ui_detection_service.dart';

/// Use case responsible for the full screenshot-processing pipeline:
///
/// 1. Validates that a screenshot path was actually provided.
/// 2. Runs on-device UI detection on the screenshot via [UiDetectionService].
/// 3. Enhances the description via [IGeminiRepository] (Gemini API).
/// 4. Speaks the resulting description through [TtsService].
///
/// Business logic lives here; the ViewModel only reacts to the result.
final class ProcessScreenshotUseCase {
  const ProcessScreenshotUseCase({
    required TtsService ttsService,
    required UiDetectionService uiDetectionService,
    required IGeminiRepository geminiRepository,
  }) : _ttsService = ttsService,
       _uiDetectionService = uiDetectionService,
       _geminiRepository = geminiRepository;

  final TtsService _ttsService;
  final UiDetectionService _uiDetectionService;
  final IGeminiRepository _geminiRepository;

  Future<ProcessScreenshotResult> processScreenshot(
    String? screenshotPath,
  ) async {
    if (screenshotPath == null || screenshotPath.trim().isEmpty) {
      return const ProcessScreenshotResult.failure(
        error: 'Screenshot path is empty.',
      );
    }

    final description = await _buildDescription(screenshotPath);

    await _ttsService.speak(description);

    return ProcessScreenshotResult.success(description: description);
  }

  Future<String> _buildDescription(String screenshotPath) async {
    final tfliteResult = (await _uiDetectionService.predictFromScreenshotFile(
      screenshotPath,
    )).summaryText;

    final geminiResult = await _geminiRepository.describeScreen(
      screenshotPath: screenshotPath,
      tfliteDetections: tfliteResult,
      systemPrompt: _systemPrompt,
    );

    return geminiResult.when(
      success: (description) => description,
      failure: (_) => tfliteResult, // fall back to raw TFLite output on error
    );
  }
}

const _systemPrompt =
    'You are a real-time voice accessibility assistant for mobile interfaces. You receive a screenshot and raw UI detections. Your job is to understand the screen and generate one short spoken message that helps a blind or low-vision user use the app. Use the screenshot as the primary source. Use the detection output only as supporting evidence. Detection output may be noisy or incomplete. Your spoken response must: - describe the screen purpose - mention the most important visible content - name the main available actions - suggest the next useful step Your response must NOT: - include coordinates - include confidence scores - list every element - mention technical model details - invent text or controls not supported by the image Preferred style: - natural spoken English - calm and concise - 2 to 5 short sentences - under 100 words in most cases If the exact screen is unclear, briefly say what it appears to be. If a primary action is visible, mention it. If a popup or alert is visible, describe it first. If the screen is scrollable, mention that. Return only the final TTS-ready narration.';


