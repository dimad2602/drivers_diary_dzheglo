import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/storage/env/env.dart';
import 'package:driver_diary/shared/utils/base_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveBaseUrl на Android (эмулятор)', () {
    String android(String url) => resolveBaseUrl(url, isAndroid: true);

    test('127.0.0.1 заменяется на 10.0.2.2, порт сохраняется', () {
      expect(android('http://127.0.0.1:8000'), 'http://10.0.2.2:8000');
    });

    test('localhost тоже заменяется', () {
      expect(android('http://localhost:8000'), 'http://10.0.2.2:8000');
    });

    test('схема, порт и путь сохраняются', () {
      expect(
        android('https://127.0.0.1:8443/api'),
        'https://10.0.2.2:8443/api',
      );
    });

    test('адрес без порта', () {
      expect(android('http://127.0.0.1'), 'http://10.0.2.2');
    });

    for (final untouched in [
      'http://192.168.1.10:8000', // IP компьютера в сети — задан явно
      'https://diary.example.kz',
      'http://10.0.2.2:8000', // уже правильный
    ]) {
      test('«$untouched» остаётся как есть', () {
        expect(android(untouched), untouched);
      });
    }

    test('некорректная строка возвращается без изменений', () {
      expect(android('::не адрес::'), '::не адрес::');
      expect(android(''), '');
    });
  });

  group('resolveBaseUrl на остальных платформах', () {
    test('адрес не меняется, в том числе loopback', () {
      expect(
        resolveBaseUrl('http://127.0.0.1:8000', isAndroid: false),
        'http://127.0.0.1:8000',
      );
      expect(
        resolveBaseUrl('http://localhost:8000', isAndroid: false),
        'http://localhost:8000',
      );
    });
  });

  test('Constants.baseUrl вне Android равен значению из .env', () {
    expect(Constants.baseUrl, Env.baseUrl);
  });

  test('адрес эмулятора — 10.0.2.2', () {
    expect(androidEmulatorHost, '10.0.2.2');
  });
}
