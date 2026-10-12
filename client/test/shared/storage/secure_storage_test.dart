import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockFlutterSecureStorage platform;
  late SecureStorage storage;

  setUp(() {
    platform = _MockFlutterSecureStorage();
    storage = SecureStorage(platform);
  });

  test('читает ключ из хранилища по ожидаемому имени', () async {
    when(() => platform.read(key: Constants.apiKeyStorageKey))
        .thenAnswer((_) async => 'secret');

    expect(await storage.readApiKey(), 'secret');
  });

  test('ошибка чтения превращается в «ключ не задан»', () async {
    when(() => platform.read(key: any(named: 'key')))
        .thenThrow(Exception('keychain'));

    expect(await storage.readApiKey(), isNull);
  });

  test('записывает и удаляет ключ', () async {
    when(
      () => platform.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(() => platform.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});

    await storage.saveApiKey('abc');
    await storage.deleteApiKey();

    verify(() => platform.write(key: Constants.apiKeyStorageKey, value: 'abc'))
        .called(1);
    verify(() => platform.delete(key: Constants.apiKeyStorageKey)).called(1);
  });
}
