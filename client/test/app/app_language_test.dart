import 'dart:ui';

import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('system не навязывает locale, остальные языки — навязывают', () {
    expect(AppLanguage.system.locale, isNull);
    expect(AppLanguage.ru.locale, const Locale('ru'));
    expect(AppLanguage.en.locale, const Locale('en'));
  });

  test('fromName разбирает имена и возвращает system для неизвестных', () {
    expect(AppLanguage.fromName('ru'), AppLanguage.ru);
    expect(AppLanguage.fromName('en'), AppLanguage.en);
    expect(AppLanguage.fromName('xx'), AppLanguage.system);
    expect(AppLanguage.fromName(null), AppLanguage.system);
  });
}
