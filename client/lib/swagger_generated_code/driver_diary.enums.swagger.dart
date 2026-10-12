// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum PaymentMethod {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cash')
  cash('cash'),
  @JsonValue('card')
  card('card');

  final String? value;

  const PaymentMethod(this.value);
}
