import 'package:flutter/material.dart';

import 'package:ai_a11y/app/app.dart';
import 'package:ai_a11y/app/di/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const App());
}
