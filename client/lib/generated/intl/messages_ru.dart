// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(percent) => "${percent}% от суммы, можно изменить";

  static String m1(hours) => "${hours} ч";

  static String m2(hours, minutes) => "${hours} ч ${minutes} мин";

  static String m3(minutes) => "${minutes} мин";

  static String m4(count) =>
      "${Intl.plural(count, one: '${count} поездка', few: '${count} поездки', many: '${count} поездок', other: '${count} поездки')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "actionPickTime": MessageLookupByLibrary.simpleMessage("Выбрать время"),
    "actionRefresh": MessageLookupByLibrary.simpleMessage("Обновить"),
    "actionRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "actionSave": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "addTripAction": MessageLookupByLibrary.simpleMessage("Добавить поездку"),
    "addTripTitle": MessageLookupByLibrary.simpleMessage("Новая поездка"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Дневник водителя"),
    "commissionAutoHint": m0,
    "dayNext": MessageLookupByLibrary.simpleMessage("Следующий день"),
    "dayPick": MessageLookupByLibrary.simpleMessage("Выбрать день"),
    "dayPrevious": MessageLookupByLibrary.simpleMessage("Предыдущий день"),
    "dayToday": MessageLookupByLibrary.simpleMessage("Сегодня"),
    "dayYesterday": MessageLookupByLibrary.simpleMessage("Вчера"),
    "diaryByPayment": MessageLookupByLibrary.simpleMessage("По способу оплаты"),
    "diaryCommission": MessageLookupByLibrary.simpleMessage("Комиссия"),
    "diaryEmptyMessage": MessageLookupByLibrary.simpleMessage(
      "За этот день поездки не добавлены.",
    ),
    "diaryEmptyTitle": MessageLookupByLibrary.simpleMessage("Поездок нет"),
    "diaryNetLabel": MessageLookupByLibrary.simpleMessage("На руки"),
    "diaryRevenue": MessageLookupByLibrary.simpleMessage("Выручка"),
    "diaryTripsCount": MessageLookupByLibrary.simpleMessage("Поездок"),
    "diaryTripsHeader": MessageLookupByLibrary.simpleMessage("Поездки"),
    "durationHours": m1,
    "durationHoursMinutes": m2,
    "durationMinutes": m3,
    "endNextDayHint": MessageLookupByLibrary.simpleMessage("На следующий день"),
    "errorConflictMessage": MessageLookupByLibrary.simpleMessage(
      "Поездка с таким идентификатором уже сохранена с другими данными.",
    ),
    "errorConflictTitle": MessageLookupByLibrary.simpleMessage(
      "Поездка уже существует",
    ),
    "errorNoConnectionMessage": MessageLookupByLibrary.simpleMessage(
      "Проверьте подключение и убедитесь, что backend запущен.",
    ),
    "errorNoConnectionTitle": MessageLookupByLibrary.simpleMessage(
      "Нет связи с сервером",
    ),
    "errorServerMessage": MessageLookupByLibrary.simpleMessage(
      "На сервере что-то пошло не так. Повторите позже.",
    ),
    "errorServerTitle": MessageLookupByLibrary.simpleMessage("Ошибка сервера"),
    "errorUnauthorizedMessage": MessageLookupByLibrary.simpleMessage(
      "API-ключ не задан или неверен.",
    ),
    "errorUnauthorizedTitle": MessageLookupByLibrary.simpleMessage(
      "Доступ запрещён",
    ),
    "errorUnknownMessage": MessageLookupByLibrary.simpleMessage(
      "Сервер прислал неожиданный ответ. Повторите попытку.",
    ),
    "errorUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "Что-то пошло не так",
    ),
    "errorValidationMessage": MessageLookupByLibrary.simpleMessage(
      "Сервер не принял значения. Проверьте их и повторите.",
    ),
    "errorValidationTitle": MessageLookupByLibrary.simpleMessage(
      "Данные не приняты",
    ),
    "fieldAmount": MessageLookupByLibrary.simpleMessage("Сумма"),
    "fieldCommission": MessageLookupByLibrary.simpleMessage("Комиссия"),
    "fieldDate": MessageLookupByLibrary.simpleMessage("Дата"),
    "fieldEnd": MessageLookupByLibrary.simpleMessage("Окончание"),
    "fieldPayment": MessageLookupByLibrary.simpleMessage("Способ оплаты"),
    "fieldStart": MessageLookupByLibrary.simpleMessage("Начало"),
    "formAmountPositive": MessageLookupByLibrary.simpleMessage(
      "Сумма должна быть больше нуля",
    ),
    "formCommissionExceeds": MessageLookupByLibrary.simpleMessage(
      "Комиссия не может быть больше суммы",
    ),
    "formEndAfterStart": MessageLookupByLibrary.simpleMessage(
      "Окончание должно быть позже начала",
    ),
    "formInvalid": MessageLookupByLibrary.simpleMessage(
      "Введите корректное число",
    ),
    "formInvalidTime": MessageLookupByLibrary.simpleMessage(
      "Введите время как ЧЧ:ММ, например 08:30",
    ),
    "formRequired": MessageLookupByLibrary.simpleMessage("Заполните поле"),
    "hintTimeFormat": MessageLookupByLibrary.simpleMessage("ЧЧ:ММ"),
    "paymentCard": MessageLookupByLibrary.simpleMessage("Карта"),
    "paymentCash": MessageLookupByLibrary.simpleMessage("Наличные"),
    "tripAdded": MessageLookupByLibrary.simpleMessage("Поездка добавлена"),
    "tripsCountLabel": m4,
  };
}
