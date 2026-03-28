import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';
import 'package:ai_a11y/services/tts_service.dart';

/// Use case responsible for the full screenshot-processing pipeline:
///
/// 1. Validates that a screenshot path was actually provided.
/// 2. Sends the path to the native layer for any pre-processing
///    (future: OCR / AI description via [NativeOverlayService]).
/// 3. Speaks the resulting description through [TtsService].
///
/// Business logic lives here; the ViewModel only reacts to the result.
final class ProcessScreenshotUseCase {
  const ProcessScreenshotUseCase({
    required TtsService ttsService,
    required NativeOverlayService overlayService,
  }) : _ttsService = ttsService,
       _overlayService = overlayService;

  final TtsService _ttsService;
  final NativeOverlayService _overlayService;

  Future<ProcessScreenshotResult> processScreenshot() async {
    // ── 1. Capture screenshot
    final screenshotPath = await _overlayService.takeScreenshot();

    if (screenshotPath == null || screenshotPath.trim().isEmpty) {
      await _ttsService.speak(
        'Could not capture a screenshot. Please try again.',
      );
      return const ProcessScreenshotResult.failure(error: 'Screenshot capture failed.');
    }

    // ── 2. Process screenshot
    // TODO: replace stub with real AI / OCR call.
    final description = await _buildDescription(screenshotPath);

    // ── 3. Speak result
    await _ttsService.speak(description);

    return ProcessScreenshotResult.success(description: description);
  }

  Future<String> _buildDescription(String screenshotPath) async {
    return 'Screenshot captured. Analyzing the content on your screen. '
        'This is a placeholder description that will be replaced '
        'by an AI-generated accessibility description.';
  }
}
