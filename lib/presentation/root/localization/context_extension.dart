import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

extension LocalizationBuildContextExtension on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;

  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}
