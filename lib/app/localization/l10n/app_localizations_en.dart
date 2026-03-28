// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_app_name => 'AI A11Y';

  @override
  String get overlay_status_active => 'Overlay is active';

  @override
  String get overlay_status_inactive => 'Overlay is inactive';

  @override
  String get overlay_description_active =>
      'The screenshot button is floating over your screen.\nTap it to capture.';

  @override
  String get overlay_description_inactive =>
      'Start the overlay to show a floating\nscreenshot button over all apps.';

  @override
  String get overlay_button_start => 'Start Overlay';

  @override
  String get overlay_button_stop => 'Stop Overlay';

  @override
  String get overlay_button_loading => 'Please wait...';

  @override
  String get overlay_permission_overlay => 'Overlay permission';

  @override
  String get overlay_permission_screen_capture => 'Screen capture permission';

  @override
  String get overlay_error_permission_denied =>
      'Overlay permission denied. Please allow drawing over other apps.';

  @override
  String get overlay_error_screen_capture_denied =>
      'Screen capture permission denied.';
}
