import 'package:driver_diary/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // S берёт язык из Intl.defaultLocale в момент вызова, поэтому грузим его перед проверкой.
  Future<String> label(String locale, int count) async {
    final l10n = await S.load(Locale(locale));
    return l10n.tripsCountLabel(count);
  }

  test('ru: склонение «поездка» по числу', () async {
    final labels = {
      for (final n in [0, 1, 2, 4, 5, 11, 12, 21, 22, 25, 101, 111])
        n: await label('ru', n),
    };

    expect(labels, {
      0: '0 поездок',
      1: '1 поездка',
      2: '2 поездки',
      4: '4 поездки',
      5: '5 поездок',
      11: '11 поездок',
      12: '12 поездок',
      21: '21 поездка',
      22: '22 поездки',
      25: '25 поездок',
      101: '101 поездка',
      111: '111 поездок',
    });
  });

  test('en: единственное и множественное число', () async {
    expect(await label('en', 0), '0 trips');
    expect(await label('en', 1), '1 trip');
    expect(await label('en', 2), '2 trips');
  });
}
