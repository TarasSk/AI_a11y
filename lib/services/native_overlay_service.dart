import 'package:flutter/services.dart';

/// MethodChannel wrapper for communicating with native Android overlay service.
final class NativeOverlayService {
  static const _channel = MethodChannel('com.ai_a11y/overlay');

  NativeOverlayService() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> Function(String screenshotPath)? _onScreenshotCaptured;

  // ── Overlay permission ─────────────────────────────────────────

  /// Checks if the app has overlay (draw over other apps) permission.
  Future<bool> hasOverlayPermission() async {
    final result = await _channel.invokeMethod<bool>('hasOverlayPermission');
    return result ?? false;
  }

  /// Requests overlay permission. Opens system settings if not granted.
  Future<bool> requestOverlayPermission() async {
    final result = await _channel.invokeMethod<bool>(
      'requestOverlayPermission',
    );
    return result ?? false;
  }

  // ── Overlay service ────────────────────────────────────────────

  /// Starts the overlay service with the floating screenshot button.
  Future<void> startOverlay() async {
    await _channel.invokeMethod('startOverlay');
  }

  /// Stops the overlay service and removes the floating button.
  Future<void> stopOverlay() async {
    await _channel.invokeMethod('stopOverlay');
  }

  // ── Screenshot ────────────────────────────────────────────────

  /// Captures the current screen and returns the local file path.
  /// Returns `null` if the capture failed or permission was denied.
  Future<String?> takeScreenshot() async {
    return _channel.invokeMethod<String>('takeScreenshot');
  }

  // ── Accessibility permission ───────────────────────────────────

  /// Returns true if our AccessibilityService is enabled in system settings.
  Future<bool> hasAccessibilityPermission() async {
    final result = await _channel.invokeMethod<bool>(
      'hasAccessibilityPermission',
    );
    return result ?? false;
  }

  /// Opens the system Accessibility Settings so the user can enable the service.
  /// Always returns false — the user must toggle it manually.
  Future<void> requestAccessibilityPermission() async {
    await _channel.invokeMethod('requestAccessibilityPermission');
  }

  void setOnScreenshotCaptured(
    Future<void> Function(String screenshotPath)? listener,
  ) {
    _onScreenshotCaptured = listener;
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onScreenshotCaptured':
        final screenshotPath = call.arguments as String?;
        if (screenshotPath == null || screenshotPath.trim().isEmpty) {
          return;
        }
        await _onScreenshotCaptured?.call(screenshotPath);
      default:
        return;
    }
  }
}
