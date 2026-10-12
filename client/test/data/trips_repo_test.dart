import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' as chopper;
import 'package:driver_diary/data/api/interceptors/api_key_interceptor.dart';
import 'package:driver_diary/data/repositories/trips_repo.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:driver_diary/shared/storage/api_key_store.dart';
import 'package:driver_diary/swagger_generated_code/driver_diary.swagger.dart'
    as sw;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fixtures.dart';

class _MockApi extends Mock implements sw.DriverDiary {}

class _MockApiKeyStore extends Mock implements ApiKeyStore {}

chopper.Response<T> _response<T>(int status, [T? body]) =>
    chopper.Response<T>(http.Response('', status), body);

const _tripJson = {
  'id': 't1',
  'start': '2026-10-01T08:10:00+05:00',
  'end': '2026-10-01T08:32:00+05:00',
  'amount': 2400,
  'payment': 'card',
  'commission': 360,
};

sw.Trip _dtoTrip() => sw.Trip.fromJson(_tripJson);

sw.DaySummary _dtoSummary() => sw.DaySummary(
  date: DateTime(2026, 10, 1),
  tripsCount: 1,
  revenue: 2400,
  commission: 360,
  net: 2040,
  byPayment: const sw.ByPayment(
    cash: sw.PaymentBreakdown(tripsCount: 0, revenue: 0, commission: 0, net: 0),
    card: sw.PaymentBreakdown(
      tripsCount: 1,
      revenue: 2400,
      commission: 360,
      net: 2040,
    ),
  ),
);

TripsError _errorOf(Result<Object, TripsError> result) => switch (result) {
  Failure(:final error) => error,
  Success() => fail('ожидалась ошибка, а пришёл успех'),
};

void main() {
  group('с замоканным API', () {
    late _MockApi api;
    late TripsRepo repo;

    setUp(() {
      api = _MockApi();
      repo = TripsRepo(api, timeout: const Duration(milliseconds: 50));
    });

    void stubDay({
      chopper.Response<List<sw.Trip>>? trips,
      chopper.Response<sw.DaySummary>? summary,
    }) {
      when(() => api.listTrips(date: any(named: 'date')))
          .thenAnswer((_) async => trips ?? _response(200, [_dtoTrip()]));
      when(() => api.getDaySummary(date: any(named: 'date')))
          .thenAnswer((_) async => summary ?? _response(200, _dtoSummary()));
    }

    group('getDay', () {
      test('собирает сводку и поездки в доменную модель', () async {
        stubDay();

        final result = await repo.getDay(DateTime(2026, 10, 1, 15));

        final diary = (result as Success).data;
        expect(diary.summary.net, 2040);
        expect(diary.trips.single.id, 't1');
        expect(diary.trips.single.payment, PaymentMethod.card);
        verify(() => api.listTrips(date: '2026-10-01')).called(1);
        verify(() => api.getDaySummary(date: '2026-10-01')).called(1);
      });

      test('пустой день — пустой список и нулевая сводка', () async {
        stubDay(trips: _response(200, <sw.Trip>[]));

        final result = await repo.getDay(DateTime(2026, 10, 1));

        expect((result as Success).data.trips, isEmpty);
      });

      for (final entry in {
        401: TripsError.unauthorized,
        422: TripsError.validation,
        500: TripsError.server,
        503: TripsError.server,
        404: TripsError.unknown,
      }.entries) {
        test('статус ${entry.key} → ${entry.value.name}', () async {
          stubDay(trips: _response(entry.key));

          expect(
            _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
            entry.value,
          );
        });
      }

      test('ошибка любого из двух запросов проваливает весь день', () async {
        stubDay(summary: _response(401));

        expect(
          _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
          TripsError.unauthorized,
        );
      });

      test('успех без тела считается неизвестной ошибкой', () async {
        stubDay(summary: _response(200));

        expect(
          _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
          TripsError.unknown,
        );
      });

      test('поездка со временем без пояса — неизвестная ошибка', () async {
        final broken = sw.Trip.fromJson({
          ..._tripJson,
          'start': '2026-10-01T08:10:00',
        });
        stubDay(trips: _response(200, [broken]));

        expect(
          _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
          TripsError.unknown,
        );
      });

      for (final entry in <String, Object>{
        'SocketException': const SocketException('refused'),
        'ClientException': http.ClientException('refused'),
      }.entries) {
        test('${entry.key} → noConnection', () async {
          stubDay();
          when(() => api.listTrips(date: any(named: 'date')))
              .thenThrow(entry.value);

          expect(
            _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
            TripsError.noConnection,
          );
        });
      }

      test('зависший запрос обрывается по таймауту → noConnection', () async {
        stubDay();
        when(() => api.getDaySummary(date: any(named: 'date'))).thenAnswer(
          (_) => Completer<chopper.Response<sw.DaySummary>>().future,
        );

        expect(
          _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
          TripsError.noConnection,
        );
      });

      test('неожиданное исключение → unknown', () async {
        stubDay();
        when(() => api.listTrips(date: any(named: 'date')))
            .thenThrow(StateError('boom'));

        expect(
          _errorOf(await repo.getDay(DateTime(2026, 10, 1))),
          TripsError.unknown,
        );
      });
    });

    group('addTrip', () {
      setUp(() {
        registerFallbackValue(
          sw.TripCreate(
            id: '',
            start: '',
            end: '',
            amount: 1,
            payment: sw.PaymentMethod.cash,
            commission: 0,
          ),
        );
      });

      test('201 → созданная поездка', () async {
        when(() => api.createTrip(body: any(named: 'body')))
            .thenAnswer((_) async => _response(201, _dtoTrip()));

        final result = await repo.addTrip(makeTrip());

        expect((result as Success).data, makeTrip());
      });

      test('200 (повтор) тоже успех и возвращает ту же поездку', () async {
        when(() => api.createTrip(body: any(named: 'body')))
            .thenAnswer((_) async => _response(200, _dtoTrip()));

        final result = await repo.addTrip(makeTrip());

        expect((result as Success).data.id, 't1');
      });

      test('в запрос уходят id и время со смещением', () async {
        when(() => api.createTrip(body: any(named: 'body')))
            .thenAnswer((_) async => _response(201, _dtoTrip()));

        await repo.addTrip(makeTrip());

        final sent =
            verify(() => api.createTrip(body: captureAny(named: 'body')))
                    .captured
                    .single
                as sw.TripCreate;
        expect(sent.id, 't1');
        expect(sent.start, '2026-10-01T08:10:00+05:00');
      });

      for (final entry in {
        409: TripsError.conflict,
        422: TripsError.validation,
        401: TripsError.unauthorized,
      }.entries) {
        test('статус ${entry.key} → ${entry.value.name}', () async {
          when(() => api.createTrip(body: any(named: 'body')))
              .thenAnswer((_) async => _response(entry.key));

          expect(_errorOf(await repo.addTrip(makeTrip())), entry.value);
        });
      }

      test('обрыв связи → noConnection', () async {
        when(() => api.createTrip(body: any(named: 'body')))
            .thenThrow(const SocketException('down'));

        expect(
          _errorOf(await repo.addTrip(makeTrip())),
          TripsError.noConnection,
        );
      });
    });
  });

  group('со сгенерированным клиентом и настоящим JSON', () {
    late List<http.Request> requests;
    late TripsRepo repo;

    http.Response json(Object body, [int status = 200]) => http.Response.bytes(
      utf8.encode(jsonEncode(body)),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

    TripsRepo createRepo(http.Response Function(http.Request) handler) {
      final store = _MockApiKeyStore();
      when(() => store.read()).thenAnswer((_) async => 'dev-key');
      final httpClient = MockClient((request) async {
        requests.add(request);
        return handler(request);
      });
      return TripsRepo(
        sw.DriverDiary.create(
          httpClient: httpClient,
          baseUrl: Uri.parse('http://test.local'),
          interceptors: [ApiKeyInterceptor(store)],
        ),
      );
    }

    setUp(() => requests = []);

    test('получает день: запрос, заголовок ключа и разбор ответа', () async {
      repo = createRepo((request) {
        return request.url.path.endsWith('/summary')
            ? json({
                'date': '2026-10-01',
                'trips_count': 2,
                'revenue': 3900,
                'commission': 585,
                'net': 3315,
                'by_payment': {
                  'cash': {
                    'trips_count': 1,
                    'revenue': 1500,
                    'commission': 225,
                    'net': 1275,
                  },
                  'card': {
                    'trips_count': 1,
                    'revenue': 2400,
                    'commission': 360,
                    'net': 2040,
                  },
                },
              })
            : json([
                _tripJson,
                {
                  ..._tripJson,
                  'id': 't2',
                  'start': '2026-10-01T09:05:00+05:00',
                  'end': '2026-10-01T09:20:00+05:00',
                  'amount': 1500,
                  'payment': 'cash',
                  'commission': 225,
                },
              ]);
      });

      final result = await repo.getDay(DateTime(2026, 10, 1));

      final diary = (result as Success).data;
      expect(diary.summary, exampleSummary);
      expect(diary.trips.map((t) => t.id), ['t1', 't2']);
      expect(diary.trips.first.start.offset, const Duration(hours: 5));
      expect(diary.trips.last.payment, PaymentMethod.cash);
      expect(requests, hasLength(2));
      for (final request in requests) {
        expect(request.url.queryParameters['date'], '2026-10-01');
        expect(request.headers['X-API-Key'], 'dev-key');
      }
    });

    test(
      'создаёт поездку: тело запроса со смещением и разбор ответа',
      () async {
        repo = createRepo((request) => json(_tripJson, 201));

        final result = await repo.addTrip(makeTrip());

        expect((result as Success).data, makeTrip());
        final request = requests.single;
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/trips');
        expect(jsonDecode(request.body), {..._tripJson, 'payment': 'card'});
      },
    );

    test('ошибка 409 от сервера → conflict', () async {
      repo = createRepo(
        (request) => json({'detail': 'Поездка уже существует'}, 409),
      );

      expect(_errorOf(await repo.addTrip(makeTrip())), TripsError.conflict);
    });

    test('ответ не JSON (например, 502 от прокси) → server', () async {
      repo = createRepo(
        (request) => http.Response('<html>Bad gateway</html>', 502),
      );

      expect(_errorOf(await repo.addTrip(makeTrip())), TripsError.server);
    });
  });
}
