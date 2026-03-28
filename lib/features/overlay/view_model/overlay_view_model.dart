import 'package:ai_a11y/app/localization/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ai_a11y/features/overlay/state/overlay_state.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';

final class OverlayViewModel extends Cubit<OverlayState> {
  OverlayViewModel({
    required NativeOverlayService overlayService,
    required AppLocalizations localization,
  })  : _overlayService = overlayService,
        _localization = localization,
        super(const OverlayState());

  final NativeOverlayService _overlayService;
  final AppLocalizations _localization;

  /// Toggles the overlay on/off.
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
        emit(state.copyWith(
          isLoading: false,
          error: _localization.overlay_error_permission_denied,
        ));
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

  /// Checks current permission status without requesting.
  Future<void> checkPermissions() async {
    if (isClosed) return;

    try {
      final hasOverlay = await _overlayService.hasOverlayPermission();
      if (isClosed) return;

      emit(state.copyWith(hasOverlayPermission: hasOverlay));
    } catch (_) {}
  }
}
