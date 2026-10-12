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

  static String m0(hours) => "${hours} h";

  static String m1(hours, minutes) => "${hours} h ${minutes} min";

  static String m2(minutes) => "${minutes} min";

  static String m3(count) =>
      "${Intl.plural(count, one: '${count} trip', other: '${count} trips')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "actionRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "actionRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Driver Diary"),
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
    "durationHours": m0,
    "durationHoursMinutes": m1,
    "durationMinutes": m2,
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
    "paymentCard": MessageLookupByLibrary.simpleMessage("Card"),
    "paymentCash": MessageLookupByLibrary.simpleMessage("Cash"),
    "tripsCountLabel": m3,
  };
}
