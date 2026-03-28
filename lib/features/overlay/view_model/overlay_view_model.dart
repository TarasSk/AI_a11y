import 'dart:async';

import 'package:ai_a11y/app/localization/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_a11y/domain/entity/process_screenshot_result.dart';
import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/features/overlay/state/overlay_state.dart';
import 'package:ai_a11y/services/gemma_service.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';

final class OverlayViewModel extends Cubit<OverlayState> {
  OverlayViewModel({
    required NativeOverlayService overlayService,
    required ProcessScreenshotUseCase processScreenshotUseCase,
    required GemmaService gemmaService,
    required AppLocalizations localization,
  }) : _overlayService = overlayService,
       _processScreenshotUseCase = processScreenshotUseCase,
       _gemmaService = gemmaService,
       _localization = localization,
       super(const OverlayState()) {
    _overlayService.setOnScreenshotCaptured(_handleScreenshotCaptured);
  }

  final NativeOverlayService _overlayService;
  final ProcessScreenshotUseCase _processScreenshotUseCase;
  final GemmaService _gemmaService;
  final AppLocalizations _localization;

  Future<void> toggleOverlay() async {
    if (state.isOverlayActive) {
      await stopOverlay();
    } else {
      await startOverlay();
    }
  }

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

  Future<void> requestAccessibilityPermission() async {
    await _overlayService.requestAccessibilityPermission();
    await checkPermissions();
  }

  Future<void> initModel() async {
    if (isClosed) return;
    emit(state.copyWith(modelStatus: GemmaModelStatus.initializing, error: null));
    try {
      final installed = await _gemmaService.isModelInstalled();
      if (!installed) {
        emit(state.copyWith(modelStatus: GemmaModelStatus.downloading));
        await _gemmaService.installModel(
          onProgress: (p) {
            if (!isClosed) emit(state.copyWith(downloadProgress: p));
          },
        );
        if (isClosed) return;
        emit(state.copyWith(
          modelStatus: GemmaModelStatus.installed,
          downloadProgress: 100,
        ));
      }
      await _gemmaService.initSession();
      if (isClosed) return;
      emit(state.copyWith(modelStatus: GemmaModelStatus.ready));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(modelStatus: GemmaModelStatus.error, error: e.toString()));
    }
  }

  Future<void> _handleScreenshotCaptured(String screenshotPath) async {
    if (isClosed) return;
    if (state.modelStatus != GemmaModelStatus.ready) return;
    emit(state.copyWith(isGenerating: true, lastScreenshotPath: screenshotPath, error: null));
    try {
      final result = await _processScreenshotUseCase.processScreenshot(screenshotPath);
      if (isClosed) return;
      switch (result) {
        case ProcessScreenshotSuccess(:final description):
          emit(state.copyWith(isGenerating: false, aiResponse: description));
        case ProcessScreenshotFailure(:final error):
          emit(state.copyWith(isGenerating: false, error: error));
      }
    } catch (error, stackTrace) {
      debugPrint('Screenshot processing failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!isClosed) {
        emit(state.copyWith(isGenerating: false, error: error.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    _overlayService.setOnScreenshotCaptured(null);
    await _gemmaService.closeSession();
    return super.close();
  }
}
