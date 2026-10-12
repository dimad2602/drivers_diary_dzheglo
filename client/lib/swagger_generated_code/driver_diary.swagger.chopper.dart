// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'driver_diary.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$DriverDiary extends DriverDiary {
  _$DriverDiary([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = DriverDiary;

  @override
  Future<Response<DaySummary>> _getDaySummary({
    required String? date,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Число поездок, выручка, комиссия, «на руки» (выручка − комиссия) и разбивка по оплате.',
      summary: 'Сводка за день',
      operationId: 'getDaySummary',
      consumes: [],
      produces: [],
      security: ["APIKeyHeader"],
      tags: ["summary"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/v1/summary');
    final Map<String, dynamic> $params = <String, dynamic>{'date': date};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<DaySummary, DaySummary>($request);
  }

  @override
  Future<Response<List<Trip>>> _listTrips({
    required String? date,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Поездки, начавшиеся в выбранный день по местному времени поездки, по возрастанию начала.',
      summary: 'Поездки за день',
      operationId: 'listTrips',
      consumes: [],
      produces: [],
      security: ["APIKeyHeader"],
      tags: ["trips"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/v1/trips');
    final Map<String, dynamic> $params = <String, dynamic>{'date': date};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Trip>, Trip>($request);
  }

  @override
  Future<Response<Trip>> _createTrip({
    required TripCreate? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Идемпотентное добавление: `id` задаёт клиент и служит ключом идемпотентности.',
      summary: 'Добавить поездку',
      operationId: 'createTrip',
      consumes: [],
      produces: [],
      security: ["APIKeyHeader"],
      tags: ["trips"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/v1/trips');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<Trip, Trip>($request);
  }
}
