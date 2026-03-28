import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'presentation/root/app.dart';
import 'presentation/root/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupServiceLocator();
  final token = dotenv.env['HUGGINGFACE_TOKEN']!;
  await FlutterGemma.initialize(huggingFaceToken: token);
  runApp(const App());
}
