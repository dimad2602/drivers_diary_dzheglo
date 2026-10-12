import 'dart:io' show Platform;

import 'package:driver_diary/shared/storage/env/env.dart';
import 'package:driver_diary/shared/utils/base_url.dart';

abstract final class Constants {
  /// Адрес backend из `.env` с учётом платформы (см. [resolveBaseUrl]).
  static String get baseUrl =>
      resolveBaseUrl(Env.baseUrl, isAndroid: Platform.isAndroid);

  static const String currencySymbol = '₸';

  /// Комиссия по умолчанию в форме новой поездки, % от суммы (как в примере задания).
  static const int defaultCommissionPercent = 15;

  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
}
