import 'package:ai_a11y/presentation/root/route/app_router.dart';
import 'package:flutter/material.dart';

import 'localization/context_extension.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI A11Y',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationsDelegates,
      supportedLocales: context.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
