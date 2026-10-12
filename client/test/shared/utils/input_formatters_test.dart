import 'package:driver_diary/shared/utils/digits_input_formatter.dart';
import 'package:driver_diary/shared/utils/time_input.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _value(String text, [int? caret]) => TextEditingValue(
  text: text,
  selection: TextSelection.collapsed(offset: caret ?? text.length),
);

/// Правка: старое значение → новый текст целиком (вставка или удаление).
String _edit(TextInputFormatter formatter, String old, String next) =>
    formatter.formatEditUpdate(_value(old), _value(next)).text;

/// Набор по одному символу, как с клавиатуры.
String _typed(TextInputFormatter formatter, String keys) {
  var text = '';
  for (final key in keys.split('')) {
    text = _edit(formatter, text, text + key);
  }
  return text;
}

void main() {
  group('DigitsInputFormatter (деньги)', () {
    const formatter = DigitsInputFormatter();

    test('цифры принимаются', () {
      expect(_typed(formatter, '2400'), '2400');
    });

    test('буква при наборе игнорируется', () {
      expect(_typed(formatter, '12a3'), '123');
    });

    for (final pasted in ['2400,50', '2400.50', '-5', '1e5', '١٢٣', '2400₸']) {
      test(
        'вставка «$pasted» отклоняется целиком, а не превращается в число',
        () {
          expect(_edit(formatter, '', pasted), '');
          expect(_edit(formatter, '77', '77$pasted'), '77');
        },
      );
    }

    test('пробелы-разделители разрядов убираются (обычные и неразрывные)', () {
      expect(_edit(formatter, '', '2 400'), '2400');
      expect(_edit(formatter, '', '2 400 000'), '2400000');
    });

    test('девять цифр — предел; десятая отклоняется', () {
      expect(_typed(formatter, '123456789'), '123456789');
      expect(_typed(formatter, '1234567890'), '123456789');
    });

    test('слишком длинная вставка отклоняется, а не обрезается', () {
      expect(_edit(formatter, '', '123456789012'), '');
    });

    test('предел длины настраивается', () {
      const short = DigitsInputFormatter(maxLength: 3);

      expect(_typed(short, '12345'), '123');
    });

    test('ведущие нули срезаются, но один ноль остаётся', () {
      expect(_typed(formatter, '0'), '0');
      expect(_typed(formatter, '08'), '8');
      expect(_edit(formatter, '', '0005'), '5');
      expect(_edit(formatter, '', '000'), '0');
    });

    test('удаление цифр работает', () {
      expect(_edit(formatter, '2400', '240'), '240');
      expect(_edit(formatter, '2', ''), '');
    });

    test('курсор остаётся на месте при правке посередине', () {
      final result = formatter.formatEditUpdate(
        _value('1234'),
        _value('12534', 3),
      );

      expect(result.text, '12534');
      expect(result.selection.baseOffset, 3);
    });

    test('курсор сдвигается на число срезанных нулей', () {
      final result = formatter.formatEditUpdate(
        _value('123'),
        _value('0123', 1),
      );

      expect(result.text, '123');
      expect(result.selection.baseOffset, 0);
    });

    test('курсор без позиции уходит в конец', () {
      final result = formatter.formatEditUpdate(
        _value(''),
        const TextEditingValue(text: '55'),
      );

      expect(result.selection.baseOffset, 2);
    });
  });

  group('TimeInputFormatter', () {
    const formatter = TimeInputFormatter();

    test('набор четырёх цифр ставит двоеточие сам', () {
      expect(_typed(formatter, '0830'), '08:30');
      expect(_typed(formatter, '2359'), '23:59');
      expect(_typed(formatter, '0000'), '00:00');
    });

    test('двоеточие появляется на третьей цифре', () {
      expect(_typed(formatter, '08'), '08');
      expect(_typed(formatter, '083'), '08:3');
    });

    test('первая цифра 3–9 сразу превращается в «0X:»', () {
      expect(_typed(formatter, '9'), '09:');
      expect(_typed(formatter, '930'), '09:30');
      expect(_typed(formatter, '845'), '08:45');
    });

    test('набор с двоеточием: «9:30» → «09:30»', () {
      expect(_typed(formatter, '9:30'), '09:30');
      expect(_typed(formatter, '12:05'), '12:05');
    });

    test('второе двоеточие игнорируется', () {
      expect(_typed(formatter, '12::'), '12:');
      expect(_edit(formatter, '', '08:30:00'), '');
    });

    test('буквы и знаки не принимаются', () {
      expect(_typed(formatter, '08a30'), '08:30');
      expect(_typed(formatter, '08-30'), '08:30');
      expect(_edit(formatter, '', 'ab:cd'), '');
    });

    test('час больше 23 набрать нельзя', () {
      expect(_typed(formatter, '25'), '2');
      expect(_typed(formatter, '24'), '2');
      expect(_edit(formatter, '', '25:00'), '');
    });

    test('минуты больше 59 набрать нельзя', () {
      // Недопустимая цифра пропускается, следующая принимается как первая цифра минут.
      expect(_typed(formatter, '0860'), '08:0');
      expect(_typed(formatter, '0875'), '08:5');
      expect(_edit(formatter, '08:', '08:6'), '08:');
      expect(_edit(formatter, '', '08:99'), '');
    });

    test('больше четырёх цифр отклоняется', () {
      expect(_typed(formatter, '083012'), '08:30');
      expect(_edit(formatter, '08:30', '08:301'), '08:30');
    });

    test('вставка целого времени приводится к маске', () {
      expect(_edit(formatter, '', '0830'), '08:30');
      expect(_edit(formatter, '', '8:30'), '08:30');
      expect(_edit(formatter, '', '08:30'), '08:30');
      expect(_edit(formatter, '', ' 08 : 30 '), '08:30');
    });

    test('двоеточие в начале отклоняется', () {
      expect(_edit(formatter, '', ':30'), '');
    });

    test('удаление цифр: двоеточие уходит последним', () {
      expect(_edit(formatter, '08:30', '08:3'), '08:3');
      expect(_edit(formatter, '08:3', '08:'), '08:');
      expect(_edit(formatter, '08:', '08'), '08');
      expect(_edit(formatter, '08', '0'), '0');
      expect(_edit(formatter, '0', ''), '');
    });

    test('курсор всегда в конце', () {
      final result = formatter.formatEditUpdate(_value(''), _value('0830'));

      expect(result.selection.baseOffset, result.text.length);
    });
  });

  group('parseClockTime', () {
    test('корректное время', () {
      expect(parseClockTime('08:30'), const TimeOfDay(hour: 8, minute: 30));
      expect(parseClockTime('00:00'), const TimeOfDay(hour: 0, minute: 0));
      expect(parseClockTime('23:59'), const TimeOfDay(hour: 23, minute: 59));
    });

    test('час из одной цифры и пробелы по краям допустимы', () {
      expect(parseClockTime('8:30'), const TimeOfDay(hour: 8, minute: 30));
      expect(parseClockTime(' 08:30 '), const TimeOfDay(hour: 8, minute: 30));
    });

    for (final bad in [
      '24:00',
      '12:60',
      '9:5',
      '08:3',
      '08',
      '',
      'ab:cd',
      '08.30',
      '08:30:00',
      '-1:30',
    ]) {
      test('«$bad» — не время', () {
        expect(parseClockTime(bad), isNull);
      });
    }
  });

  test('formatTimeText дополняет нулями', () {
    expect(formatTimeText(const TimeOfDay(hour: 9, minute: 5)), '09:05');
    expect(formatTimeText(const TimeOfDay(hour: 0, minute: 0)), '00:00');
    expect(formatTimeText(const TimeOfDay(hour: 23, minute: 59)), '23:59');
  });
}
