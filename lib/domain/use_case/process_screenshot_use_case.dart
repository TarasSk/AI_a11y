import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:ai_a11y/services/gemma_service.dart';
import 'package:ai_a11y/services/tts_service.dart';
import 'package:ai_a11y/services/ui_detection_service.dart';
import 'package:image/image.dart' as img;

/// Use case responsible for the full screenshot-processing pipeline:
///
/// 1. Validates that a screenshot path was actually provided.
/// 2. Runs TFLite UI detection via [UiDetectionService] to get element labels.
/// 3. Sends the labels + screenshot image to [GemmaService] for a richer
///    accessibility description.
/// 4. Speaks the resulting description through [TtsService].
///
/// Business logic lives here; the ViewModel only reacts to the result.
final class ProcessScreenshotUseCase {
  const ProcessScreenshotUseCase({
    required TtsService ttsService,
    required UiDetectionService uiDetectionService,
    required GemmaService gemmaService,
  }) : _ttsService = ttsService,
       _uiDetectionService = uiDetectionService,
       _gemmaService = gemmaService;

  final TtsService _ttsService;
  final UiDetectionService _uiDetectionService;
  final GemmaService _gemmaService;

  Future<ProcessScreenshotResult> processScreenshot(
    String? screenshotPath,
  ) async {
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
    final labels = await _uiDetectionService.predictFromScreenshotFile(
      screenshotPath,
    );
    final bytes = await File(screenshotPath).readAsBytes();
    final compressed = await compute(_compressToJpeg, bytes);
    final prompt =
        'UI elements detected: $labels\n\n'
        'Generate accessibility descriptions (alt text, ARIA labels, markdown) '
        'for all UI elements visible in this screenshot.';
    return _gemmaService.sendMessage(prompt, imageBytes: compressed);
  }

  /// Decodes the screenshot, resizes to max 128 px on the longest side, and
  /// re-encodes as JPEG (quality 85) to reduce GPU memory pressure.
  static Uint8List _compressToJpeg(Uint8List raw) {
    final decoded = img.decodeImage(raw);
    if (decoded == null) return raw;
    final resized = decoded.width > decoded.height
        ? img.copyResize(decoded, width: 128)
        : img.copyResize(decoded, height: 128);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
  }
}
