import 'package:driver_diary/shared/storage/api_key_store.dart';
import 'package:driver_diary/shared/storage/secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late _MockSecureStorage secure;
  late ApiKeyStore store;

  setUp(() {
    secure = _MockSecureStorage();
    store = ApiKeyStore(secure, defaultKey: 'from-env');
  });

  test('без сохранённого ключа возвращает ключ из .env', () async {
    when(() => secure.readApiKey()).thenAnswer((_) async => null);

    expect(await store.read(), 'from-env');
  });

  test('пустой сохранённый ключ тоже заменяется ключом из .env', () async {
    when(() => secure.readApiKey()).thenAnswer((_) async => '');

    expect(await store.read(), 'from-env');
  });

  test('сохранённый ключ приоритетнее ключа из .env', () async {
    when(() => secure.readApiKey()).thenAnswer((_) async => 'mine');

    expect(await store.read(), 'mine');
  });

  test('save обрезает пробелы', () async {
    when(() => secure.saveApiKey(any())).thenAnswer((_) async {});

    await store.save('  key  ');

    verify(() => secure.saveApiKey('key')).called(1);
  });

  test('reset удаляет сохранённый ключ', () async {
    when(() => secure.deleteApiKey()).thenAnswer((_) async {});

    await store.reset();

    verify(() => secure.deleteApiKey()).called(1);
  });
}
