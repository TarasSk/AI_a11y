# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (Freezed state classes + localizations) — required after modifying *.freezed.dart sources or ARB files
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze / lint
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Build
flutter build apk        # Android
flutter build ios        # iOS
```

Flutter version is pinned via FVM (see `.fvmrc`). Use `fvm flutter` instead of `flutter` if FVM is active in your shell.

## Architecture

AI_a11y is a Flutter app that provides a persistent overlay floating button for capturing screenshots on Android, with an accessibility-first design.

### Flutter → Native Bridge

All native Android capabilities are exposed via a single `MethodChannel` named `com.ai_a11y/overlay`:

| Dart (`NativeOverlayService`) | Android (`MainActivity`) |
|---|---|
| `hasOverlayPermission()` | Returns whether `SYSTEM_ALERT_WINDOW` is granted |
| `requestOverlayPermission()` | Opens system Settings for the permission |
| `startOverlay()` | Starts `OverlayService` (foreground service + floating button) |
| `stopOverlay()` | Stops `OverlayService` |

### Android Native Services

Three Android components handle the capture flow:

1. **`OverlayService`** — long-lived foreground service that draws the draggable floating button. On tap: hides button, launches `ScreenshotActivity`.
2. **`ScreenshotActivity`** — transparent activity that shows the `MediaProjection` consent dialog. On approval: starts `CaptureService`.
3. **`CaptureService`** — short-lived service that uses `MediaProjection` to capture the screen, saves PNG to external storage (`/Pictures/screenshots/`), then tears down.

### Flutter State & DI

- **State management**: BLoC (`flutter_bloc`) — `OverlayViewModel` is a `Cubit` holding `OverlayState` (Freezed).
- **Dependency injection**: GetIt singleton (`service_locator.dart`) — `NativeOverlayService` is registered there.
- **Routing**: Go Router with a single overlay route.
- **Localization**: intl/ARB (`lib/app/localization/l10n/app_en.arb`). Generated files (`app_localizations*.dart`) are committed.

### Code Generation

Generated files (`*.freezed.dart`, `app_localizations*.dart`) are committed to version control. Re-run `build_runner` whenever you modify a `@freezed` class or ARB strings.
