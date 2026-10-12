import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _readArb(String locale) =>
    jsonDecode(File('lib/l10n/intl_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

final _placeholder = RegExp(r'\{(\w+)');

Set<String?> _placeholders(Object? message) =>
    _placeholder.allMatches(message as String).map((m) => m[1]).toSet();

void main() {
  final en = _readArb('en');
  final ru = _readArb('ru');

  test('в ru и en одинаковые ключи', () {
    expect(_messageKeys(ru), _messageKeys(en));
  });

  test('плейсхолдеры в переводе совпадают с английским шаблоном', () {
    for (final key in _messageKeys(en)) {
      expect(_placeholders(ru[key]), _placeholders(en[key]), reason: key);
    }
  });

  test('переводы не пустые', () {
    for (final key in _messageKeys(ru)) {
      expect((ru[key] as String).trim(), isNotEmpty, reason: key);
    }
  });
}
