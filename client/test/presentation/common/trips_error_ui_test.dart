import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/common/trips_error_ui.dart';
import 'package:driver_diary/shared/storage/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // S берёт язык из Intl.defaultLocale в момент вызова, поэтому грузим его перед проверкой.
  Future<S> l10n(String code) => S.load(Locale(code));

  group('сообщение «нет связи»', () {
    test('называет адрес, к которому не удалось подключиться (ru)', () async {
      final text = TripsError.noConnection.message(await l10n('ru'));

      expect(text, contains(Constants.baseUrl));
      expect(text, contains('backend запущен'));
    });

    test('то же на английском', () async {
      final text = TripsError.noConnection.message(await l10n('en'));

      expect(text, contains(Constants.baseUrl));
      expect(text, contains('backend is running'));
    });
  });

  test('у каждой ошибки есть заголовок, сообщение и значок', () async {
    final s = await l10n('ru');

    for (final error in TripsError.values) {
      expect(error.title(s), isNotEmpty, reason: error.name);
      expect(error.message(s), isNotEmpty, reason: error.name);
      expect(error.icon, isA<IconData>(), reason: error.name);
    }
  });

  test('заголовки разных ошибок различаются', () async {
    final s = await l10n('ru');

    final titles = TripsError.values.map((e) => e.title(s)).toSet();

    // unknown и validation могут делить значок, но не заголовок.
    expect(titles.length, TripsError.values.length);
  });
}
