import 'package:driver_diary/data/api/interceptors/api_key_interceptor.dart';
import 'package:driver_diary/shared/storage/api_key_store.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

void main() {
  late _MockApiKeyStore store;
  late List<http.BaseRequest> requests;
  late sw.DriverDiary api;

  setUp(() {
    store = _MockApiKeyStore();
    requests = [];
    final httpClient = MockClient((request) async {
      requests.add(request);
      return http.Response(
        '[]',
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    api = sw.DriverDiary.create(
      httpClient: httpClient,
      baseUrl: Uri.parse('http://test.local'),
      interceptors: [ApiKeyInterceptor(store)],
    );
  });

  test('добавляет заголовок X-API-Key из хранилища', () async {
    when(() => store.read()).thenAnswer((_) async => 'secret');

    await api.listTrips(date: '2026-10-01');

    expect(requests.single.headers['X-API-Key'], 'secret');
  });

  test(
    'ключ читается на каждый запрос — смена ключа действует сразу',
    () async {
      when(() => store.read()).thenAnswer((_) async => 'first');
      await api.listTrips(date: '2026-10-01');

      when(() => store.read()).thenAnswer((_) async => 'second');
      await api.listTrips(date: '2026-10-01');

      expect(requests.map((r) => r.headers['X-API-Key']), ['first', 'second']);
    },
  );
}
