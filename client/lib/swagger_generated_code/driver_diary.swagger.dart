// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';

import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;

import 'driver_diary.enums.swagger.dart' as enums;
import 'driver_diary.metadata.swagger.dart';
export 'driver_diary.enums.swagger.dart';

part 'driver_diary.swagger.chopper.dart';
part 'driver_diary.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class DriverDiary extends ChopperService {
  static DriverDiary create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$DriverDiary(client);
    }

    final newClient = ChopperClient(
      services: [_$DriverDiary()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$DriverDiary(newClient);
  }

  ///Сводка за день
  ///@param date День в формате YYYY-MM-DD
  Future<chopper.Response<DaySummary>> getDaySummary({required String? date}) {
    generatedMapping.putIfAbsent(DaySummary, () => DaySummary.fromJsonFactory);

    return _getDaySummary(date: date);
  }

  ///Сводка за день
  ///@param date День в формате YYYY-MM-DD
  @GET(path: '/api/v1/summary')
  Future<chopper.Response<DaySummary>> _getDaySummary({
    @Query('date') required String? date,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Число поездок, выручка, комиссия, «на руки» (выручка − комиссия) и разбивка по оплате.',
      summary: 'Сводка за день',
      operationId: 'getDaySummary',
      consumes: [],
      produces: [],
      security: [],
      tags: ["summary"],
      deprecated: false,
    ),
  });

  ///Поездки за день
  ///@param date День в формате YYYY-MM-DD
  Future<chopper.Response<List<Trip>>> listTrips({required String? date}) {
    generatedMapping.putIfAbsent(Trip, () => Trip.fromJsonFactory);

    return _listTrips(date: date);
  }

  ///Поездки за день
  ///@param date День в формате YYYY-MM-DD
  @GET(path: '/api/v1/trips')
  Future<chopper.Response<List<Trip>>> _listTrips({
    @Query('date') required String? date,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Поездки, начавшиеся в выбранный день по местному времени поездки, по возрастанию начала.',
      summary: 'Поездки за день',
      operationId: 'listTrips',
      consumes: [],
      produces: [],
      security: [],
      tags: ["trips"],
      deprecated: false,
    ),
  });

  ///Добавить поездку
  Future<chopper.Response<Trip>> createTrip({required TripCreate? body}) {
    generatedMapping.putIfAbsent(Trip, () => Trip.fromJsonFactory);

    return _createTrip(body: body);
  }

  ///Добавить поездку
  @POST(path: '/api/v1/trips', optionalBody: true)
  Future<chopper.Response<Trip>> _createTrip({
    @Body() required TripCreate? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Идемпотентное добавление: `id` задаёт клиент и служит ключом идемпотентности.',
      summary: 'Добавить поездку',
      operationId: 'createTrip',
      consumes: [],
      produces: [],
      security: [],
      tags: ["trips"],
      deprecated: false,
    ),
  });
}

@JsonSerializable(explicitToJson: true)
class ByPayment {
  const ByPayment({required this.card, required this.cash});

  factory ByPayment.fromJson(Map<String, dynamic> json) =>
      _$ByPaymentFromJson(json);

  static const toJsonFactory = _$ByPaymentToJson;
  Map<String, dynamic> toJson() => _$ByPaymentToJson(this);

  @JsonKey(name: 'card')
  final PaymentBreakdown card;
  @JsonKey(name: 'cash')
  final PaymentBreakdown cash;
  static const fromJsonFactory = _$ByPaymentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ByPayment &&
            (identical(other.card, card) ||
                const DeepCollectionEquality().equals(other.card, card)) &&
            (identical(other.cash, cash) ||
                const DeepCollectionEquality().equals(other.cash, cash)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(card) ^
      const DeepCollectionEquality().hash(cash) ^
      runtimeType.hashCode;
}

extension $ByPaymentExtension on ByPayment {
  ByPayment copyWith({PaymentBreakdown? card, PaymentBreakdown? cash}) {
    return ByPayment(card: card ?? this.card, cash: cash ?? this.cash);
  }

  ByPayment copyWithWrapped({
    Wrapped<PaymentBreakdown>? card,
    Wrapped<PaymentBreakdown>? cash,
  }) {
    return ByPayment(
      card: (card != null ? card.value : this.card),
      cash: (cash != null ? cash.value : this.cash),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class DaySummary {
  const DaySummary({
    required this.byPayment,
    required this.commission,
    required this.date,
    required this.net,
    required this.revenue,
    required this.tripsCount,
  });

  factory DaySummary.fromJson(Map<String, dynamic> json) =>
      _$DaySummaryFromJson(json);

  static const toJsonFactory = _$DaySummaryToJson;
  Map<String, dynamic> toJson() => _$DaySummaryToJson(this);

  @JsonKey(name: 'by_payment')
  final ByPayment byPayment;
  @JsonKey(name: 'commission')
  final int commission;
  @JsonKey(name: 'date', toJson: _dateToJson)
  final DateTime date;
  @JsonKey(name: 'net')
  final int net;
  @JsonKey(name: 'revenue')
  final int revenue;
  @JsonKey(name: 'trips_count')
  final int tripsCount;
  static const fromJsonFactory = _$DaySummaryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DaySummary &&
            (identical(other.byPayment, byPayment) ||
                const DeepCollectionEquality().equals(
                  other.byPayment,
                  byPayment,
                )) &&
            (identical(other.commission, commission) ||
                const DeepCollectionEquality().equals(
                  other.commission,
                  commission,
                )) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.net, net) ||
                const DeepCollectionEquality().equals(other.net, net)) &&
            (identical(other.revenue, revenue) ||
                const DeepCollectionEquality().equals(
                  other.revenue,
                  revenue,
                )) &&
            (identical(other.tripsCount, tripsCount) ||
                const DeepCollectionEquality().equals(
                  other.tripsCount,
                  tripsCount,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(byPayment) ^
      const DeepCollectionEquality().hash(commission) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(net) ^
      const DeepCollectionEquality().hash(revenue) ^
      const DeepCollectionEquality().hash(tripsCount) ^
      runtimeType.hashCode;
}

extension $DaySummaryExtension on DaySummary {
  DaySummary copyWith({
    ByPayment? byPayment,
    int? commission,
    DateTime? date,
    int? net,
    int? revenue,
    int? tripsCount,
  }) {
    return DaySummary(
      byPayment: byPayment ?? this.byPayment,
      commission: commission ?? this.commission,
      date: date ?? this.date,
      net: net ?? this.net,
      revenue: revenue ?? this.revenue,
      tripsCount: tripsCount ?? this.tripsCount,
    );
  }

  DaySummary copyWithWrapped({
    Wrapped<ByPayment>? byPayment,
    Wrapped<int>? commission,
    Wrapped<DateTime>? date,
    Wrapped<int>? net,
    Wrapped<int>? revenue,
    Wrapped<int>? tripsCount,
  }) {
    return DaySummary(
      byPayment: (byPayment != null ? byPayment.value : this.byPayment),
      commission: (commission != null ? commission.value : this.commission),
      date: (date != null ? date.value : this.date),
      net: (net != null ? net.value : this.net),
      revenue: (revenue != null ? revenue.value : this.revenue),
      tripsCount: (tripsCount != null ? tripsCount.value : this.tripsCount),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ErrorResponse {
  const ErrorResponse({required this.detail});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  static const toJsonFactory = _$ErrorResponseToJson;
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @JsonKey(name: 'detail')
  final String detail;
  static const fromJsonFactory = _$ErrorResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorResponse &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $ErrorResponseExtension on ErrorResponse {
  ErrorResponse copyWith({String? detail}) {
    return ErrorResponse(detail: detail ?? this.detail);
  }

  ErrorResponse copyWithWrapped({Wrapped<String>? detail}) {
    return ErrorResponse(detail: (detail != null ? detail.value : this.detail));
  }
}

@JsonSerializable(explicitToJson: true)
class HTTPValidationError {
  const HTTPValidationError({this.detail});

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) =>
      _$HTTPValidationErrorFromJson(json);

  static const toJsonFactory = _$HTTPValidationErrorToJson;
  Map<String, dynamic> toJson() => _$HTTPValidationErrorToJson(this);

  @JsonKey(name: 'detail', defaultValue: <ValidationError>[])
  final List<ValidationError>? detail;
  static const fromJsonFactory = _$HTTPValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HTTPValidationError &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $HTTPValidationErrorExtension on HTTPValidationError {
  HTTPValidationError copyWith({List<ValidationError>? detail}) {
    return HTTPValidationError(detail: detail ?? this.detail);
  }

  HTTPValidationError copyWithWrapped({
    Wrapped<List<ValidationError>?>? detail,
  }) {
    return HTTPValidationError(
      detail: (detail != null ? detail.value : this.detail),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class PaymentBreakdown {
  const PaymentBreakdown({
    required this.commission,
    required this.net,
    required this.revenue,
    required this.tripsCount,
  });

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PaymentBreakdownFromJson(json);

  static const toJsonFactory = _$PaymentBreakdownToJson;
  Map<String, dynamic> toJson() => _$PaymentBreakdownToJson(this);

  @JsonKey(name: 'commission')
  final int commission;
  @JsonKey(name: 'net')
  final int net;
  @JsonKey(name: 'revenue')
  final int revenue;
  @JsonKey(name: 'trips_count')
  final int tripsCount;
  static const fromJsonFactory = _$PaymentBreakdownFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PaymentBreakdown &&
            (identical(other.commission, commission) ||
                const DeepCollectionEquality().equals(
                  other.commission,
                  commission,
                )) &&
            (identical(other.net, net) ||
                const DeepCollectionEquality().equals(other.net, net)) &&
            (identical(other.revenue, revenue) ||
                const DeepCollectionEquality().equals(
                  other.revenue,
                  revenue,
                )) &&
            (identical(other.tripsCount, tripsCount) ||
                const DeepCollectionEquality().equals(
                  other.tripsCount,
                  tripsCount,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(commission) ^
      const DeepCollectionEquality().hash(net) ^
      const DeepCollectionEquality().hash(revenue) ^
      const DeepCollectionEquality().hash(tripsCount) ^
      runtimeType.hashCode;
}

extension $PaymentBreakdownExtension on PaymentBreakdown {
  PaymentBreakdown copyWith({
    int? commission,
    int? net,
    int? revenue,
    int? tripsCount,
  }) {
    return PaymentBreakdown(
      commission: commission ?? this.commission,
      net: net ?? this.net,
      revenue: revenue ?? this.revenue,
      tripsCount: tripsCount ?? this.tripsCount,
    );
  }

  PaymentBreakdown copyWithWrapped({
    Wrapped<int>? commission,
    Wrapped<int>? net,
    Wrapped<int>? revenue,
    Wrapped<int>? tripsCount,
  }) {
    return PaymentBreakdown(
      commission: (commission != null ? commission.value : this.commission),
      net: (net != null ? net.value : this.net),
      revenue: (revenue != null ? revenue.value : this.revenue),
      tripsCount: (tripsCount != null ? tripsCount.value : this.tripsCount),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Trip {
  const Trip({
    required this.amount,
    required this.commission,
    required this.end,
    required this.id,
    required this.payment,
    required this.start,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  static const toJsonFactory = _$TripToJson;
  Map<String, dynamic> toJson() => _$TripToJson(this);

  @JsonKey(name: 'amount')
  final int amount;
  @JsonKey(name: 'commission')
  final int commission;
  @JsonKey(name: 'end')
  final String end;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(
    name: 'payment',
    toJson: paymentMethodToJson,
    fromJson: paymentMethodFromJson,
  )
  final enums.PaymentMethod payment;
  @JsonKey(name: 'start')
  final String start;
  static const fromJsonFactory = _$TripFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Trip &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.commission, commission) ||
                const DeepCollectionEquality().equals(
                  other.commission,
                  commission,
                )) &&
            (identical(other.end, end) ||
                const DeepCollectionEquality().equals(other.end, end)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.payment, payment) ||
                const DeepCollectionEquality().equals(
                  other.payment,
                  payment,
                )) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(commission) ^
      const DeepCollectionEquality().hash(end) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(payment) ^
      const DeepCollectionEquality().hash(start) ^
      runtimeType.hashCode;
}

extension $TripExtension on Trip {
  Trip copyWith({
    int? amount,
    int? commission,
    String? end,
    String? id,
    enums.PaymentMethod? payment,
    String? start,
  }) {
    return Trip(
      amount: amount ?? this.amount,
      commission: commission ?? this.commission,
      end: end ?? this.end,
      id: id ?? this.id,
      payment: payment ?? this.payment,
      start: start ?? this.start,
    );
  }

  Trip copyWithWrapped({
    Wrapped<int>? amount,
    Wrapped<int>? commission,
    Wrapped<String>? end,
    Wrapped<String>? id,
    Wrapped<enums.PaymentMethod>? payment,
    Wrapped<String>? start,
  }) {
    return Trip(
      amount: (amount != null ? amount.value : this.amount),
      commission: (commission != null ? commission.value : this.commission),
      end: (end != null ? end.value : this.end),
      id: (id != null ? id.value : this.id),
      payment: (payment != null ? payment.value : this.payment),
      start: (start != null ? start.value : this.start),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TripCreate {
  const TripCreate({
    required this.amount,
    required this.commission,
    required this.end,
    required this.id,
    required this.payment,
    required this.start,
  });

  factory TripCreate.fromJson(Map<String, dynamic> json) =>
      _$TripCreateFromJson(json);

  static const toJsonFactory = _$TripCreateToJson;
  Map<String, dynamic> toJson() => _$TripCreateToJson(this);

  @JsonKey(name: 'amount')
  final int amount;
  @JsonKey(name: 'commission')
  final int commission;
  @JsonKey(name: 'end')
  final String end;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(
    name: 'payment',
    toJson: paymentMethodToJson,
    fromJson: paymentMethodFromJson,
  )
  final enums.PaymentMethod payment;
  @JsonKey(name: 'start')
  final String start;
  static const fromJsonFactory = _$TripCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TripCreate &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.commission, commission) ||
                const DeepCollectionEquality().equals(
                  other.commission,
                  commission,
                )) &&
            (identical(other.end, end) ||
                const DeepCollectionEquality().equals(other.end, end)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.payment, payment) ||
                const DeepCollectionEquality().equals(
                  other.payment,
                  payment,
                )) &&
            (identical(other.start, start) ||
                const DeepCollectionEquality().equals(other.start, start)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(commission) ^
      const DeepCollectionEquality().hash(end) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(payment) ^
      const DeepCollectionEquality().hash(start) ^
      runtimeType.hashCode;
}

extension $TripCreateExtension on TripCreate {
  TripCreate copyWith({
    int? amount,
    int? commission,
    String? end,
    String? id,
    enums.PaymentMethod? payment,
    String? start,
  }) {
    return TripCreate(
      amount: amount ?? this.amount,
      commission: commission ?? this.commission,
      end: end ?? this.end,
      id: id ?? this.id,
      payment: payment ?? this.payment,
      start: start ?? this.start,
    );
  }

  TripCreate copyWithWrapped({
    Wrapped<int>? amount,
    Wrapped<int>? commission,
    Wrapped<String>? end,
    Wrapped<String>? id,
    Wrapped<enums.PaymentMethod>? payment,
    Wrapped<String>? start,
  }) {
    return TripCreate(
      amount: (amount != null ? amount.value : this.amount),
      commission: (commission != null ? commission.value : this.commission),
      end: (end != null ? end.value : this.end),
      id: (id != null ? id.value : this.id),
      payment: (payment != null ? payment.value : this.payment),
      start: (start != null ? start.value : this.start),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationError {
  const ValidationError({
    this.ctx,
    this.input,
    required this.loc,
    required this.msg,
    required this.type,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  static const toJsonFactory = _$ValidationErrorToJson;
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @JsonKey(name: 'ctx')
  final Object? ctx;
  @JsonKey(name: 'input')
  final dynamic input;
  @JsonKey(name: 'loc', defaultValue: <Object>[])
  final List<Object> loc;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'type')
  final String type;
  static const fromJsonFactory = _$ValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationError &&
            (identical(other.ctx, ctx) ||
                const DeepCollectionEquality().equals(other.ctx, ctx)) &&
            (identical(other.input, input) ||
                const DeepCollectionEquality().equals(other.input, input)) &&
            (identical(other.loc, loc) ||
                const DeepCollectionEquality().equals(other.loc, loc)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ctx) ^
      const DeepCollectionEquality().hash(input) ^
      const DeepCollectionEquality().hash(loc) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(type) ^
      runtimeType.hashCode;
}

extension $ValidationErrorExtension on ValidationError {
  ValidationError copyWith({
    Object? ctx,
    dynamic input,
    List<Object>? loc,
    String? msg,
    String? type,
  }) {
    return ValidationError(
      ctx: ctx ?? this.ctx,
      input: input ?? this.input,
      loc: loc ?? this.loc,
      msg: msg ?? this.msg,
      type: type ?? this.type,
    );
  }

  ValidationError copyWithWrapped({
    Wrapped<Object?>? ctx,
    Wrapped<dynamic>? input,
    Wrapped<List<Object>>? loc,
    Wrapped<String>? msg,
    Wrapped<String>? type,
  }) {
    return ValidationError(
      ctx: (ctx != null ? ctx.value : this.ctx),
      input: (input != null ? input.value : this.input),
      loc: (loc != null ? loc.value : this.loc),
      msg: (msg != null ? msg.value : this.msg),
      type: (type != null ? type.value : this.type),
    );
  }
}

String? paymentMethodNullableToJson(enums.PaymentMethod? paymentMethod) {
  return paymentMethod?.value;
}

String? paymentMethodToJson(enums.PaymentMethod paymentMethod) {
  return paymentMethod.value;
}

enums.PaymentMethod paymentMethodFromJson(
  Object? paymentMethod, [
  enums.PaymentMethod? defaultValue,
]) {
  return enums.PaymentMethod.values.firstWhereOrNull(
        (e) => e.value == paymentMethod,
      ) ??
      defaultValue ??
      enums.PaymentMethod.swaggerGeneratedUnknown;
}

enums.PaymentMethod? paymentMethodNullableFromJson(
  Object? paymentMethod, [
  enums.PaymentMethod? defaultValue,
]) {
  if (paymentMethod == null) {
    return null;
  }
  return enums.PaymentMethod.values.firstWhereOrNull(
        (e) => e.value == paymentMethod,
      ) ??
      defaultValue;
}

String paymentMethodExplodedListToJson(
  List<enums.PaymentMethod>? paymentMethod,
) {
  return paymentMethod?.map((e) => e.value!).join(',') ?? '';
}

List<String> paymentMethodListToJson(List<enums.PaymentMethod>? paymentMethod) {
  if (paymentMethod == null) {
    return [];
  }

  return paymentMethod.map((e) => e.value!).toList();
}

List<enums.PaymentMethod> paymentMethodListFromJson(
  List? paymentMethod, [
  List<enums.PaymentMethod>? defaultValue,
]) {
  if (paymentMethod == null) {
    return defaultValue ?? [];
  }

  return paymentMethod.map((e) => paymentMethodFromJson(e.toString())).toList();
}

List<enums.PaymentMethod>? paymentMethodNullableListFromJson(
  List? paymentMethod, [
  List<enums.PaymentMethod>? defaultValue,
]) {
  if (paymentMethod == null) {
    return defaultValue;
  }

  return paymentMethod.map((e) => paymentMethodFromJson(e.toString())).toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body: DateTime.parse(
          (response.body as String).replaceAll('"', ''),
        ) as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
