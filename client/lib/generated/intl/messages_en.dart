// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(percent) => "${percent}% of the amount, you can change it";

  static String m1(hours) => "${hours} h";

  static String m2(hours, minutes) => "${hours} h ${minutes} min";

  static String m3(minutes) => "${minutes} min";

  static String m4(count) =>
      "${Intl.plural(count, one: '${count} trip', other: '${count} trips')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "actionPickTime": MessageLookupByLibrary.simpleMessage("Pick time"),
    "actionRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "actionRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "actionSave": MessageLookupByLibrary.simpleMessage("Save"),
    "addTripAction": MessageLookupByLibrary.simpleMessage("Add trip"),
    "addTripTitle": MessageLookupByLibrary.simpleMessage("New trip"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Driver Diary"),
    "commissionAutoHint": m0,
    "dayNext": MessageLookupByLibrary.simpleMessage("Next day"),
    "dayPick": MessageLookupByLibrary.simpleMessage("Choose a day"),
    "dayPrevious": MessageLookupByLibrary.simpleMessage("Previous day"),
    "dayToday": MessageLookupByLibrary.simpleMessage("Today"),
    "dayYesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
    "diaryByPayment": MessageLookupByLibrary.simpleMessage("By payment method"),
    "diaryCommission": MessageLookupByLibrary.simpleMessage("Commission"),
    "diaryEmptyMessage": MessageLookupByLibrary.simpleMessage(
      "No trips were added for this day.",
    ),
    "diaryEmptyTitle": MessageLookupByLibrary.simpleMessage("No trips"),
    "diaryNetLabel": MessageLookupByLibrary.simpleMessage("Take-home"),
    "diaryRevenue": MessageLookupByLibrary.simpleMessage("Revenue"),
    "diaryTripsCount": MessageLookupByLibrary.simpleMessage("Trips"),
    "diaryTripsHeader": MessageLookupByLibrary.simpleMessage("Trips"),
    "durationHours": m1,
    "durationHoursMinutes": m2,
    "durationMinutes": m3,
    "endNextDayHint": MessageLookupByLibrary.simpleMessage("Next day"),
    "errorConflictMessage": MessageLookupByLibrary.simpleMessage(
      "A trip with this ID is already saved with different data.",
    ),
    "errorConflictTitle": MessageLookupByLibrary.simpleMessage(
      "Trip already exists",
    ),
    "errorNoConnectionMessage": MessageLookupByLibrary.simpleMessage(
      "Check your connection and make sure the backend is running.",
    ),
    "errorNoConnectionTitle": MessageLookupByLibrary.simpleMessage(
      "Can\'t reach the server",
    ),
    "errorServerMessage": MessageLookupByLibrary.simpleMessage(
      "Something went wrong on the server. Try again later.",
    ),
    "errorServerTitle": MessageLookupByLibrary.simpleMessage("Server error"),
    "errorUnauthorizedMessage": MessageLookupByLibrary.simpleMessage(
      "The API key is missing or incorrect.",
    ),
    "errorUnauthorizedTitle": MessageLookupByLibrary.simpleMessage(
      "Access denied",
    ),
    "errorUnknownMessage": MessageLookupByLibrary.simpleMessage(
      "The server sent an unexpected response. Try again.",
    ),
    "errorUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "errorValidationMessage": MessageLookupByLibrary.simpleMessage(
      "The server did not accept the values. Check them and try again.",
    ),
    "errorValidationTitle": MessageLookupByLibrary.simpleMessage(
      "Data rejected",
    ),
    "fieldAmount": MessageLookupByLibrary.simpleMessage("Amount"),
    "fieldCommission": MessageLookupByLibrary.simpleMessage("Commission"),
    "fieldDate": MessageLookupByLibrary.simpleMessage("Date"),
    "fieldEnd": MessageLookupByLibrary.simpleMessage("End"),
    "fieldPayment": MessageLookupByLibrary.simpleMessage("Payment method"),
    "fieldStart": MessageLookupByLibrary.simpleMessage("Start"),
    "formAmountPositive": MessageLookupByLibrary.simpleMessage(
      "Amount must be greater than zero",
    ),
    "formCommissionExceeds": MessageLookupByLibrary.simpleMessage(
      "Commission can\'t exceed the amount",
    ),
    "formEndAfterStart": MessageLookupByLibrary.simpleMessage(
      "End must be later than start",
    ),
    "formInvalid": MessageLookupByLibrary.simpleMessage("Enter a valid number"),
    "formInvalidTime": MessageLookupByLibrary.simpleMessage(
      "Enter time as HH:MM, for example 08:30",
    ),
    "formRequired": MessageLookupByLibrary.simpleMessage("Required field"),
    "hintTimeFormat": MessageLookupByLibrary.simpleMessage("HH:MM"),
    "paymentCard": MessageLookupByLibrary.simpleMessage("Card"),
    "paymentCash": MessageLookupByLibrary.simpleMessage("Cash"),
    "tripAdded": MessageLookupByLibrary.simpleMessage("Trip added"),
    "tripsCountLabel": m4,
  };
}
