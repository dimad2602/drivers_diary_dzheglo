// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_diary.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ByPayment _$ByPaymentFromJson(Map<String, dynamic> json) => ByPayment(
  card: PaymentBreakdown.fromJson(json['card'] as Map<String, dynamic>),
  cash: PaymentBreakdown.fromJson(json['cash'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ByPaymentToJson(ByPayment instance) => <String, dynamic>{
  'card': instance.card.toJson(),
  'cash': instance.cash.toJson(),
};

DaySummary _$DaySummaryFromJson(Map<String, dynamic> json) => DaySummary(
  byPayment: ByPayment.fromJson(json['by_payment'] as Map<String, dynamic>),
  commission: (json['commission'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  net: (json['net'] as num).toInt(),
  revenue: (json['revenue'] as num).toInt(),
  tripsCount: (json['trips_count'] as num).toInt(),
);

Map<String, dynamic> _$DaySummaryToJson(DaySummary instance) =>
    <String, dynamic>{
      'by_payment': instance.byPayment.toJson(),
      'commission': instance.commission,
      'date': _dateToJson(instance.date),
      'net': instance.net,
      'revenue': instance.revenue,
      'trips_count': instance.tripsCount,
    };

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(detail: json['detail'] as String);

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{'detail': instance.detail};

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    HTTPValidationError(
      detail:
          (json['detail'] as List<dynamic>?)
              ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HTTPValidationErrorToJson(
  HTTPValidationError instance,
) => <String, dynamic>{
  'detail': instance.detail?.map((e) => e.toJson()).toList(),
};

PaymentBreakdown _$PaymentBreakdownFromJson(Map<String, dynamic> json) =>
    PaymentBreakdown(
      commission: (json['commission'] as num).toInt(),
      net: (json['net'] as num).toInt(),
      revenue: (json['revenue'] as num).toInt(),
      tripsCount: (json['trips_count'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentBreakdownToJson(PaymentBreakdown instance) =>
    <String, dynamic>{
      'commission': instance.commission,
      'net': instance.net,
      'revenue': instance.revenue,
      'trips_count': instance.tripsCount,
    };

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
  amount: (json['amount'] as num).toInt(),
  commission: (json['commission'] as num).toInt(),
  end: json['end'] as String,
  id: json['id'] as String,
  payment: paymentMethodFromJson(json['payment']),
  start: json['start'] as String,
);

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
  'amount': instance.amount,
  'commission': instance.commission,
  'end': instance.end,
  'id': instance.id,
  'payment': paymentMethodToJson(instance.payment),
  'start': instance.start,
};

TripCreate _$TripCreateFromJson(Map<String, dynamic> json) => TripCreate(
  amount: (json['amount'] as num).toInt(),
  commission: (json['commission'] as num).toInt(),
  end: json['end'] as String,
  id: json['id'] as String,
  payment: paymentMethodFromJson(json['payment']),
  start: json['start'] as String,
);

Map<String, dynamic> _$TripCreateToJson(TripCreate instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'commission': instance.commission,
      'end': instance.end,
      'id': instance.id,
      'payment': paymentMethodToJson(instance.payment),
      'start': instance.start,
    };

ValidationError _$ValidationErrorFromJson(
  Map<String, dynamic> json,
) => ValidationError(
  ctx: json['ctx'],
  input: json['input'],
  loc: (json['loc'] as List<dynamic>?)?.map((e) => e as Object).toList() ?? [],
  msg: json['msg'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'ctx': instance.ctx,
      'input': instance.input,
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
    };
