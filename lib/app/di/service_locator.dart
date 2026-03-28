import 'package:get_it/get_it.dart';

import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/services/gemma_service.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';
import 'package:ai_a11y/services/tts_service.dart';
import 'package:ai_a11y/services/ui_detection_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator({required String hfToken}) {
  getIt.registerLazySingleton<NativeOverlayService>(
    () => NativeOverlayService(),
  );
  getIt.registerLazySingleton<UiDetectionService>(() => UiDetectionService());
  getIt.registerLazySingleton<TtsService>(() => TtsService());
  getIt.registerLazySingleton<GemmaService>(
    () => GemmaService(token: hfToken),
  );
  getIt.registerLazySingleton<ProcessScreenshotUseCase>(
    () => ProcessScreenshotUseCase(
      ttsService: getIt<TtsService>(),
      uiDetectionService: getIt<UiDetectionService>(),
      gemmaService: getIt<GemmaService>(),
    ),
  );
}
