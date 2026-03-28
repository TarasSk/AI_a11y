import 'package:ai_a11y/data/services/native_overlay_service.dart';
import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/presentation/features/overlay/state/overlay_state.dart';
import 'package:ai_a11y/presentation/root/localization/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class OverlayViewModel extends Cubit<OverlayState> {
  OverlayViewModel({
    required NativeOverlayService overlayService,
    required ProcessScreenshotUseCase processScreenshotUseCase,
    required AppLocalizations localization,
  }) : _overlayService = overlayService,
       _processScreenshotUseCase = processScreenshotUseCase,
       _localization = localization,
       super(const OverlayState()) {
    _overlayService.setOnScreenshotCaptured(_handleScreenshotCaptured);
  }

  final NativeOverlayService _overlayService;
  final ProcessScreenshotUseCase _processScreenshotUseCase;
  final AppLocalizations _localization;

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

  Future<void> _handleScreenshotCaptured(String screenshotPath) async {
    if (isClosed) return;
    emit(state.copyWith(lastScreenshotPath: screenshotPath, error: null));

    try {
      final result = await _processScreenshotUseCase.processScreenshot(
        screenshotPath,
      );

      if (isClosed) return;

      switch (result) {
        case ProcessScreenshotSuccess():
          debugPrint('Description: ${result.description}');
        case ProcessScreenshotFailure():
          debugPrint('ProcessScreenshot failed: ${result.error}');
          emit(state.copyWith(error: result.error));
      }
    } catch (error, stackTrace) {
      debugPrint('ProcessScreenshot unexpected error: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!isClosed) {
        emit(state.copyWith(error: error.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _overlayService.setOnScreenshotCaptured(null);
    return super.close();
  }
}
