import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/storage/locale_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<LocaleStorage> createStorage([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return LocaleStorage(await SharedPreferences.getInstance());
  }

  test('по умолчанию — язык системы', () async {
    final storage = await createStorage();

    expect(storage.load(), AppLanguage.system);
  });

  test('сохранённый язык читается обратно', () async {
    final storage = await createStorage();

    await storage.save(AppLanguage.ru);

    expect(storage.load(), AppLanguage.ru);
  });

  test('неизвестный код языка даёт язык системы', () async {
    final storage = await createStorage({Constants.languageKey: 'kk'});

    expect(storage.load(), AppLanguage.system);
  });
}
