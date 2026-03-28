import 'package:ai_a11y/app/localization/l10n/app_localizations.dart';
import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_a11y/features/overlay/state/overlay_state.dart';
import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';

final class OverlayViewModel extends Cubit<OverlayState> {
  OverlayViewModel({
    required NativeOverlayService overlayService,
    required AppLocalizations localization,
    required ProcessScreenshotUseCase processScreenshotUseCase,
  }) : _overlayService = overlayService,
       _localization = localization,
       _processScreenshotUseCase = processScreenshotUseCase,
       super(const OverlayState());

  final NativeOverlayService _overlayService;
  final AppLocalizations _localization;
  final ProcessScreenshotUseCase _processScreenshotUseCase;

  Future<void> toggleOverlay() async {
    if (state.isOverlayActive) {
      await stopOverlay();
    } else {
      await startOverlay();
    }
  }

  /// Requests overlay permission and starts the overlay service.
  /// MediaProjection consent is handled natively per screenshot tap.
  Future<void> startOverlay() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final hasOverlay = await _overlayService.requestOverlayPermission();
      if (isClosed) return;

      if (!hasOverlay) {
        emit(
          state.copyWith(
            isLoading: false,
            error: _localization.overlay_error_permission_denied,
          ),
        );
        return;
      }
      emit(state.copyWith(hasOverlayPermission: true));

      await _overlayService.startOverlay();
      if (isClosed) return;

      emit(state.copyWith(isOverlayActive: true, isLoading: false));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Stops the overlay service.
  Future<void> stopOverlay() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _overlayService.stopOverlay();
      if (isClosed) return;

      emit(state.copyWith(isOverlayActive: false, isLoading: false));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> checkPermissions() async {
    if (isClosed) return;
    try {
      final hasOverlay = await _overlayService.hasOverlayPermission();
      final hasAccessibility = await _overlayService
          .hasAccessibilityPermission();
      if (isClosed) return;
      emit(
        state.copyWith(
          hasOverlayPermission: hasOverlay,
          hasAccessibilityPermission: hasAccessibility,
        ),
      );
    } catch (_) {}
  }

  /// Opens the system Accessibility Settings page so the user can enable our service.
  Future<void> requestAccessibilityPermission() async {
    await _overlayService.requestAccessibilityPermission();
    // Re-check after returning from settings.
    await checkPermissions();
  }

  /// Processes a screenshot: runs the full pipeline (analyse → speak).
  ///
  /// [screenshotPath] is the local file path received from the native overlay.
  /// Pass `null` to test the error-handling branch.
  Future<void> processScreenshot(String? screenshotPath) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _processScreenshotUseCase(screenshotPath);

    if (isClosed) return;

    switch (result) {
      case ProcessScreenshotSuccess():
        emit(
          state.copyWith(isLoading: false, lastScreenshotPath: screenshotPath),
        );
      case ProcessScreenshotFailure(:final error):
        emit(state.copyWith(isLoading: false, error: error));
    }
  }
}
