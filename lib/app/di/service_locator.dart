import 'package:get_it/get_it.dart';

import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';
import 'package:ai_a11y/services/tts_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // ── Services
  getIt.registerLazySingleton<NativeOverlayService>(
    () => NativeOverlayService(),
  );

  getIt.registerLazySingleton<TtsService>(
    () => TtsService(),
  );

  // ── Use cases
  getIt.registerLazySingleton<ProcessScreenshotUseCase>(
    () => ProcessScreenshotUseCase(
      ttsService: getIt<TtsService>(),
      overlayService: getIt<NativeOverlayService>(),
    ),
  );
}

