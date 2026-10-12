import 'package:driver_diary/domain/models/offset_date_time.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/domain/models/trip_draft.dart';
import 'package:driver_diary/domain/validators/trip_validator.dart';
import 'package:driver_diary/shared/storage/constants.dart';
import 'package:driver_diary/shared/utils/time_input.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_form.freezed.dart';

enum TripFormField { start, end, amount, commission }

enum TripFormError {
  required,
  invalid,
  invalidTime,
  amountNotPositive,
  endNotAfterStart,
  commissionExceedsAmount,
}

/// То, что водитель ввёл в форме: дата, тексты времени (`ЧЧ:ММ`) и сумм, способ оплаты.
@freezed
abstract class TripFormInput with _$TripFormInput {
  const factory TripFormInput({
    required DateTime date,
    @Default('') String start,
    @Default('') String end,
    @Default('') String amount,
    @Default('') String commission,
    @Default(PaymentMethod.card) PaymentMethod payment,
  }) = _TripFormInput;
}

/// Итог проверки формы: либо готовый [draft], либо ошибки по полям.
@freezed
abstract class TripFormResult with _$TripFormResult {
  const factory TripFormResult({
    TripDraft? draft,
    @Default({}) Map<TripFormField, TripFormError> errors,
  }) = _TripFormResult;
}

TripFormResult validateTripForm(TripFormInput input) {
  final errors = <TripFormField, TripFormError>{};
  final amount = _parseNumber(input.amount, TripFormField.amount, errors);
  final commission = _parseNumber(
    input.commission,
    TripFormField.commission,
    errors,
  );
  final startTime = _parseTime(input.start, TripFormField.start, errors);
  final endTime = _parseTime(input.end, TripFormField.end, errors);

  // Правила про суммы нельзя проверить, пока числа не разобраны.
  if (amount == null || commission == null) {
    return TripFormResult(errors: errors);
  }

  final timesGiven = startTime != null && endTime != null;
  // Без времени проверяем только суммы: подставляем заведомо корректную пару.
  final start = startTime ?? const TimeOfDay(hour: 0, minute: 0);
  final end = endTime ?? const TimeOfDay(hour: 23, minute: 59);
  final endDate = timesGiven && endsNextDay(start, end)
      ? DateTime(input.date.year, input.date.month, input.date.day + 1)
      : input.date;
  final draft = TripDraft(
    start: _at(input.date, start),
    end: _at(endDate, end),
    amount: amount,
    payment: input.payment,
    commission: commission,
  );

  for (final error in TripValidator.validate(draft)) {
    if (error == TripValidationError.endNotAfterStart && !timesGiven) {
      continue;
    }
    errors.putIfAbsent(_fieldOf(error), () => _formErrorOf(error));
  }
  return errors.isEmpty
      ? TripFormResult(draft: draft)
      : TripFormResult(errors: errors);
}

/// Окончание «раньше» начала на часах значит, что поездка закончилась после полуночи
/// (ночная смена: 23:00 → 00:30). Одинаковое время — не переход, а ошибка ввода.
bool endsNextDay(TimeOfDay start, TimeOfDay end) =>
    end.hour * 60 + end.minute < start.hour * 60 + start.minute;

/// Комиссия по умолчанию для введённой суммы, `null` — если сумма ещё не число > 0.
int? suggestCommission(String amountText) {
  final amount = int.tryParse(amountText.trim());
  if (amount == null || amount <= 0) return null;
  return (amount * Constants.defaultCommissionPercent / 100).round();
}

TimeOfDay? _parseTime(
  String text,
  TripFormField field,
  Map<TripFormField, TripFormError> errors,
) {
  if (text.trim().isEmpty) {
    errors[field] = TripFormError.required;
    return null;
  }
  final time = parseClockTime(text);
  if (time == null) errors[field] = TripFormError.invalidTime;
  return time;
}

int? _parseNumber(
  String text,
  TripFormField field,
  Map<TripFormField, TripFormError> errors,
) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) {
    errors[field] = TripFormError.required;
    return null;
  }
  final value = int.tryParse(trimmed);
  if (value == null) errors[field] = TripFormError.invalid;
  return value;
}

OffsetDateTime _at(DateTime date, TimeOfDay time) => OffsetDateTime.fromLocal(
  DateTime(date.year, date.month, date.day, time.hour, time.minute),
);

TripFormField _fieldOf(TripValidationError error) => switch (error) {
  TripValidationError.amountNotPositive => TripFormField.amount,
  TripValidationError.endNotAfterStart => TripFormField.end,
  TripValidationError.commissionNegative ||
  TripValidationError.commissionExceedsAmount => TripFormField.commission,
};

TripFormError _formErrorOf(TripValidationError error) => switch (error) {
  TripValidationError.amountNotPositive => TripFormError.amountNotPositive,
  TripValidationError.endNotAfterStart => TripFormError.endNotAfterStart,
  TripValidationError.commissionNegative => TripFormError.invalid,
  TripValidationError.commissionExceedsAmount =>
    TripFormError.commissionExceedsAmount,
};
