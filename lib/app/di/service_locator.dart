import 'package:get_it/get_it.dart';

import 'package:ai_a11y/services/native_overlay_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<NativeOverlayService>(
    () => NativeOverlayService(),
  );
}

