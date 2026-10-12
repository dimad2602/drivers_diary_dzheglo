import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/storage/theme_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ThemeStorage> createStorage([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return ThemeStorage(await SharedPreferences.getInstance());
  }

  test('по умолчанию — системная тема', () async {
    final storage = await createStorage();

    expect(storage.load(), ThemeMode.system);
  });

  test('сохранённая тема читается обратно', () async {
    final storage = await createStorage();

    await storage.save(ThemeMode.dark);

    expect(storage.load(), ThemeMode.dark);
  });

  test('неизвестное значение в хранилище даёт системную тему', () async {
    final storage = await createStorage({Constants.themeModeKey: 'sepia'});

    expect(storage.load(), ThemeMode.system);
  });
}
