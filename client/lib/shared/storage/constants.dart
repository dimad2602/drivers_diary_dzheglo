import 'package:driver_diary/shared/storage/env/env.dart';

abstract final class Constants {
  static String get baseUrl => Env.baseUrl;

  /// Ключ API по умолчанию — используется, пока пользователь не задал свой в настройках.
  static String get defaultApiKey => Env.apiKey;

  static const String currencySymbol = '₸';

  static const String apiKeyStorageKey = 'api_key';
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
}
