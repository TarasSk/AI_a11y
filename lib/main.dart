import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

import 'package:ai_a11y/app/app.dart';
import 'package:ai_a11y/app/di/service_locator.dart';

/// Returns the HuggingFace token.
/// Priority: --dart-define (CI/prod) → .env asset (local dev).
Future<String> _resolveToken() async {
  const defined = String.fromEnvironment('HUGGINGFACE_TOKEN');
  if (defined.isNotEmpty) return defined;

  try {
    final raw = await rootBundle.loadString('.env');
    for (final line in raw.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('HUGGINGFACE_TOKEN=')) {
        return trimmed.substring('HUGGINGFACE_TOKEN='.length).trim();
      }
    }
  } catch (_) {}
  return '';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await _resolveToken();
  await FlutterGemma.initialize(huggingFaceToken: token);
  setupServiceLocator(hfToken: token);
  runApp(const App());
}
