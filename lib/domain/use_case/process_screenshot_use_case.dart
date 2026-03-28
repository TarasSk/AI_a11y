import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:ai_a11y/services/tts_service.dart';
import 'package:ai_a11y/services/ui_detection_service.dart';

/// Use case responsible for the full screenshot-processing pipeline:
///
/// 1. Validates that a screenshot path was actually provided.
/// 2. Runs on-device UI detection on the screenshot via [UiDetectionService].
/// 3. Speaks the resulting description through [TtsService].
///
/// Business logic lives here; the ViewModel only reacts to the result.
final class ProcessScreenshotUseCase {
  const ProcessScreenshotUseCase({
    required TtsService ttsService,
    required UiDetectionService uiDetectionService,
  }) : _ttsService = ttsService,
       _uiDetectionService = uiDetectionService;

  final TtsService _ttsService;
  final UiDetectionService _uiDetectionService;

  Future<ProcessScreenshotResult> processScreenshot(String? screenshotPath) async {
    if (screenshotPath == null || screenshotPath.trim().isEmpty) {
      await _ttsService.speak(
        'Could not capture a screenshot. Please try again.',
      );
      return const ProcessScreenshotResult.failure(
        error: 'Screenshot path is empty.',
      );
    }

    final description = await _buildDescription(screenshotPath);

    await _ttsService.speak(description);

    return ProcessScreenshotResult.success(description: description);
  }

  Future<String> _buildDescription(String screenshotPath) async {
    return _uiDetectionService.predictFromScreenshotFile(screenshotPath);
  }
}
