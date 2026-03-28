import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @common_app_name.
  ///
  /// In en, this message translates to:
  /// **'AI A11Y'**
  String get common_app_name;

  /// No description provided for @overlay_status_active.
  ///
  /// In en, this message translates to:
  /// **'Overlay is active'**
  String get overlay_status_active;

  /// No description provided for @overlay_status_inactive.
  ///
  /// In en, this message translates to:
  /// **'Overlay is inactive'**
  String get overlay_status_inactive;

  /// No description provided for @overlay_description_active.
  ///
  /// In en, this message translates to:
  /// **'The screenshot button is floating over your screen.\nTap it to capture.'**
  String get overlay_description_active;

  /// No description provided for @overlay_description_inactive.
  ///
  /// In en, this message translates to:
  /// **'Start the overlay to show a floating\nscreenshot button over all apps.'**
  String get overlay_description_inactive;

  /// No description provided for @overlay_button_start.
  ///
  /// In en, this message translates to:
  /// **'Start Overlay'**
  String get overlay_button_start;

  /// No description provided for @overlay_button_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop Overlay'**
  String get overlay_button_stop;

  /// No description provided for @overlay_button_loading.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get overlay_button_loading;

  /// No description provided for @overlay_permission_overlay.
  ///
  /// In en, this message translates to:
  /// **'Overlay permission'**
  String get overlay_permission_overlay;

  /// No description provided for @overlay_permission_screen_capture.
  ///
  /// In en, this message translates to:
  /// **'Screen capture permission'**
  String get overlay_permission_screen_capture;

  /// No description provided for @overlay_error_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Overlay permission denied. Please allow drawing over other apps.'**
  String get overlay_error_permission_denied;

  /// No description provided for @overlay_error_screen_capture_denied.
  ///
  /// In en, this message translates to:
  /// **'Screen capture permission denied.'**
  String get overlay_error_screen_capture_denied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
