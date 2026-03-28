import 'package:flutter/services.dart';

/// MethodChannel wrapper for communicating with native Android overlay service.
final class NativeOverlayService {
  static const _channel = MethodChannel('com.ai_a11y/overlay');

  /// Checks if the app has overlay (draw over other apps) permission.
  Future<bool> hasOverlayPermission() async {
    final result = await _channel.invokeMethod<bool>('hasOverlayPermission');
    return result ?? false;
  }

  /// Requests overlay permission. Opens system settings if not granted.
  Future<bool> requestOverlayPermission() async {
    final result =
        await _channel.invokeMethod<bool>('requestOverlayPermission');
    return result ?? false;
  }

  /// Starts the overlay service with the floating screenshot button.
  Future<void> startOverlay() async {
    await _channel.invokeMethod('startOverlay');
  }

  /// Stops the overlay service and removes the floating button.
  Future<void> stopOverlay() async {
    await _channel.invokeMethod('stopOverlay');
  }
}
