import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_state.freezed.dart';

@freezed
sealed class OverlayState with _$OverlayState {
  const factory OverlayState({
    @Default(false) bool hasOverlayPermission,
    @Default(false) bool hasAccessibilityPermission,
    @Default(false) bool isOverlayActive,
    @Default(false) bool isLoading,
    String? lastScreenshotPath,
    String? error,
  }) = _OverlayState;
}
