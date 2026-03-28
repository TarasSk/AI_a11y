import 'package:freezed_annotation/freezed_annotation.dart';

part 'process_screenshot_result.freezed.dart';

@freezed
sealed class ProcessScreenshotResult with _$ProcessScreenshotResult {
  const factory ProcessScreenshotResult.success({
    required String description,
  }) = ProcessScreenshotSuccess;

  const factory ProcessScreenshotResult.failure({
    required String error,
  }) = ProcessScreenshotFailure;
}
