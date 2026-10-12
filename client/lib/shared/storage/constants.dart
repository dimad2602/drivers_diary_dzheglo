import 'package:driver_diary/shared/storage/env/env.dart';

abstract final class Constants {
  static String get baseUrl => Env.baseUrl;

  /// Ключ API по умолчанию — используется, пока пользователь не задал свой в настройках.
  static String get defaultApiKey => Env.apiKey;

  static const String currencySymbol = '₸';

  /// Комиссия по умолчанию в форме новой поездки, % от суммы (как в примере задания).
  static const int defaultCommissionPercent = 15;

  static const String apiKeyStorageKey = 'api_key';
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
}
