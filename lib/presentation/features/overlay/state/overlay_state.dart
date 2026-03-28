import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_state.freezed.dart';

enum GemmaModelStatus {
  notInstalled,
  downloading,
  installed,
  initializing,
  ready,
  error,
}

@freezed
sealed class OverlayState with _$OverlayState {
  const factory OverlayState({
    @Default(false) bool hasOverlayPermission,
    @Default(false) bool hasAccessibilityPermission,
    @Default(false) bool isOverlayActive,
    @Default(false) bool isLoading,
    @Default(GemmaModelStatus.notInstalled) GemmaModelStatus modelStatus,
    @Default(0) int downloadProgress,
    @Default(false) bool isGenerating,
    String? aiResponse,
    String? lastScreenshotPath,
    String? error,
  }) = _OverlayState;
}
