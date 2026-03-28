import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'package:ai_a11y/data/repository/gemini_repository.dart';
import 'package:ai_a11y/domain/repository/i_gemini_repository.dart';
import 'package:ai_a11y/domain/use_case/process_screenshot_use_case.dart';
import 'package:ai_a11y/services/native_overlay_service.dart';
import 'package:ai_a11y/services/tts_service.dart';
import 'package:ai_a11y/services/ui_detection_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<NativeOverlayService>(
    () => NativeOverlayService(),
  );
  getIt.registerLazySingleton<UiDetectionService>(() => UiDetectionService());
  getIt.registerLazySingleton<TtsService>(() => TtsService());

  getIt.registerLazySingleton<IGeminiRepository>(
    () => GeminiRepository(apiKey: dotenv.get('GEMINI_API_KEY')),
  );

  getIt.registerLazySingleton<ProcessScreenshotUseCase>(
    () => ProcessScreenshotUseCase(
      ttsService: getIt<TtsService>(),
      uiDetectionService: getIt<UiDetectionService>(),
      geminiRepository: getIt<IGeminiRepository>(),
    ),
  );
}


