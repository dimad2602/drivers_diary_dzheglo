// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Driver Diary`
  String get appTitle {
    return Intl.message('Driver Diary', name: 'appTitle', desc: '', args: []);
  }

  /// `Take-home`
  String get diaryNetLabel {
    return Intl.message('Take-home', name: 'diaryNetLabel', desc: '', args: []);
  }

  /// `Revenue`
  String get diaryRevenue {
    return Intl.message('Revenue', name: 'diaryRevenue', desc: '', args: []);
  }

  /// `Commission`
  String get diaryCommission {
    return Intl.message(
      'Commission',
      name: 'diaryCommission',
      desc: '',
      args: [],
    );
  }

  /// `Trips`
  String get diaryTripsCount {
    return Intl.message('Trips', name: 'diaryTripsCount', desc: '', args: []);
  }

  /// `By payment method`
  String get diaryByPayment {
    return Intl.message(
      'By payment method',
      name: 'diaryByPayment',
      desc: '',
      args: [],
    );
  }

  /// `Trips`
  String get diaryTripsHeader {
    return Intl.message('Trips', name: 'diaryTripsHeader', desc: '', args: []);
  }

  /// `{count, plural, one{{count} trip} other{{count} trips}}`
  String tripsCountLabel(num count) {
    return Intl.plural(
      count,
      one: '$count trip',
      other: '$count trips',
      name: 'tripsCountLabel',
      desc: '',
      args: [count],
    );
  }

  /// `No trips`
  String get diaryEmptyTitle {
    return Intl.message(
      'No trips',
      name: 'diaryEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `No trips were added for this day.`
  String get diaryEmptyMessage {
    return Intl.message(
      'No trips were added for this day.',
      name: 'diaryEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `New trip`
  String get addTripTitle {
    return Intl.message('New trip', name: 'addTripTitle', desc: '', args: []);
  }

  /// `Add trip`
  String get addTripAction {
    return Intl.message('Add trip', name: 'addTripAction', desc: '', args: []);
  }

  /// `Save`
  String get actionSave {
    return Intl.message('Save', name: 'actionSave', desc: '', args: []);
  }

  /// `Trip added`
  String get tripAdded {
    return Intl.message('Trip added', name: 'tripAdded', desc: '', args: []);
  }

  /// `Date`
  String get fieldDate {
    return Intl.message('Date', name: 'fieldDate', desc: '', args: []);
  }

  /// `Start`
  String get fieldStart {
    return Intl.message('Start', name: 'fieldStart', desc: '', args: []);
  }

  /// `End`
  String get fieldEnd {
    return Intl.message('End', name: 'fieldEnd', desc: '', args: []);
  }

  /// `Amount`
  String get fieldAmount {
    return Intl.message('Amount', name: 'fieldAmount', desc: '', args: []);
  }

  /// `Commission`
  String get fieldCommission {
    return Intl.message(
      'Commission',
      name: 'fieldCommission',
      desc: '',
      args: [],
    );
  }

  /// `Payment method`
  String get fieldPayment {
    return Intl.message(
      'Payment method',
      name: 'fieldPayment',
      desc: '',
      args: [],
    );
  }

  /// `Pick time`
  String get actionPickTime {
    return Intl.message(
      'Pick time',
      name: 'actionPickTime',
      desc: '',
      args: [],
    );
  }

  /// `HH:MM`
  String get hintTimeFormat {
    return Intl.message('HH:MM', name: 'hintTimeFormat', desc: '', args: []);
  }

  /// `Next day`
  String get endNextDayHint {
    return Intl.message('Next day', name: 'endNextDayHint', desc: '', args: []);
  }

  /// `{percent}% of the amount, you can change it`
  String commissionAutoHint(Object percent) {
    return Intl.message(
      '$percent% of the amount, you can change it',
      name: 'commissionAutoHint',
      desc: '',
      args: [percent],
    );
  }

  /// `Required field`
  String get formRequired {
    return Intl.message(
      'Required field',
      name: 'formRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter time as HH:MM, for example 08:30`
  String get formInvalidTime {
    return Intl.message(
      'Enter time as HH:MM, for example 08:30',
      name: 'formInvalidTime',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number`
  String get formInvalid {
    return Intl.message(
      'Enter a valid number',
      name: 'formInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Amount must be greater than zero`
  String get formAmountPositive {
    return Intl.message(
      'Amount must be greater than zero',
      name: 'formAmountPositive',
      desc: '',
      args: [],
    );
  }

  /// `End must be later than start`
  String get formEndAfterStart {
    return Intl.message(
      'End must be later than start',
      name: 'formEndAfterStart',
      desc: '',
      args: [],
    );
  }

  /// `Commission can't exceed the amount`
  String get formCommissionExceeds {
    return Intl.message(
      'Commission can\'t exceed the amount',
      name: 'formCommissionExceeds',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get paymentCash {
    return Intl.message('Cash', name: 'paymentCash', desc: '', args: []);
  }

  /// `Card`
  String get paymentCard {
    return Intl.message('Card', name: 'paymentCard', desc: '', args: []);
  }

  /// `Today`
  String get dayToday {
    return Intl.message('Today', name: 'dayToday', desc: '', args: []);
  }

  /// `Yesterday`
  String get dayYesterday {
    return Intl.message('Yesterday', name: 'dayYesterday', desc: '', args: []);
  }

  /// `Previous day`
  String get dayPrevious {
    return Intl.message(
      'Previous day',
      name: 'dayPrevious',
      desc: '',
      args: [],
    );
  }

  /// `Next day`
  String get dayNext {
    return Intl.message('Next day', name: 'dayNext', desc: '', args: []);
  }

  /// `Choose a day`
  String get dayPick {
    return Intl.message('Choose a day', name: 'dayPick', desc: '', args: []);
  }

  /// `Retry`
  String get actionRetry {
    return Intl.message('Retry', name: 'actionRetry', desc: '', args: []);
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message('Settings', name: 'settingsTitle', desc: '', args: []);
  }

  /// `Appearance`
  String get settingsAppearance {
    return Intl.message(
      'Appearance',
      name: 'settingsAppearance',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settingsTheme {
    return Intl.message('Theme', name: 'settingsTheme', desc: '', args: []);
  }

  /// `System`
  String get themeSystem {
    return Intl.message('System', name: 'themeSystem', desc: '', args: []);
  }

  /// `Light`
  String get themeLight {
    return Intl.message('Light', name: 'themeLight', desc: '', args: []);
  }

  /// `Dark`
  String get themeDark {
    return Intl.message('Dark', name: 'themeDark', desc: '', args: []);
  }

  /// `Language`
  String get settingsLanguage {
    return Intl.message(
      'Language',
      name: 'settingsLanguage',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get languageSystem {
    return Intl.message('System', name: 'languageSystem', desc: '', args: []);
  }

  /// `Refresh`
  String get actionRefresh {
    return Intl.message('Refresh', name: 'actionRefresh', desc: '', args: []);
  }

  /// `Can't reach the server`
  String get errorNoConnectionTitle {
    return Intl.message(
      'Can\'t reach the server',
      name: 'errorNoConnectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Check your connection and make sure the backend is running.`
  String get errorNoConnectionMessage {
    return Intl.message(
      'Check your connection and make sure the backend is running.',
      name: 'errorNoConnectionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Data rejected`
  String get errorValidationTitle {
    return Intl.message(
      'Data rejected',
      name: 'errorValidationTitle',
      desc: '',
      args: [],
    );
  }

  /// `The server did not accept the values. Check them and try again.`
  String get errorValidationMessage {
    return Intl.message(
      'The server did not accept the values. Check them and try again.',
      name: 'errorValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Trip already exists`
  String get errorConflictTitle {
    return Intl.message(
      'Trip already exists',
      name: 'errorConflictTitle',
      desc: '',
      args: [],
    );
  }

  /// `A trip with this ID is already saved with different data.`
  String get errorConflictMessage {
    return Intl.message(
      'A trip with this ID is already saved with different data.',
      name: 'errorConflictMessage',
      desc: '',
      args: [],
    );
  }

  /// `Server error`
  String get errorServerTitle {
    return Intl.message(
      'Server error',
      name: 'errorServerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong on the server. Try again later.`
  String get errorServerMessage {
    return Intl.message(
      'Something went wrong on the server. Try again later.',
      name: 'errorServerMessage',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get errorUnknownTitle {
    return Intl.message(
      'Something went wrong',
      name: 'errorUnknownTitle',
      desc: '',
      args: [],
    );
  }

  /// `The server sent an unexpected response. Try again.`
  String get errorUnknownMessage {
    return Intl.message(
      'The server sent an unexpected response. Try again.',
      name: 'errorUnknownMessage',
      desc: '',
      args: [],
    );
  }

  /// `{minutes} min`
  String durationMinutes(Object minutes) {
    return Intl.message(
      '$minutes min',
      name: 'durationMinutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `{hours} h`
  String durationHours(Object hours) {
    return Intl.message(
      '$hours h',
      name: 'durationHours',
      desc: '',
      args: [hours],
    );
  }

  /// `{hours} h {minutes} min`
  String durationHoursMinutes(Object hours, Object minutes) {
    return Intl.message(
      '$hours h $minutes min',
      name: 'durationHoursMinutes',
      desc: '',
      args: [hours, minutes],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
