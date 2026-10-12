import 'package:driver_diary/presentation/features/add_trip/widgets/money_field.dart';
import 'package:driver_diary/shared/ui/app_picker_field.dart';
import 'package:driver_diary/shared/ui/app_segmented_control.dart';
import 'package:driver_diary/shared/ui/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppTextField', () {
    testWidgets('показывает подпись, подсказку и знак справа', (tester) async {
      await pumpApp(
        tester,
        AppTextField(
          controller: TextEditingController(),
          label: 'Сумма',
          hint: 'Введите сумму',
          suffixText: '₸',
        ),
      );

      expect(find.text('Сумма'), findsOneWidget);
      expect(find.text('Введите сумму'), findsOneWidget);
      expect(find.text('₸'), findsOneWidget);
    });

    testWidgets('ввод попадает в контроллер и в onChanged', (tester) async {
      final controller = TextEditingController();
      final changes = <String>[];
      await pumpApp(
        tester,
        AppTextField(
          controller: controller,
          label: 'Поле',
          onChanged: changes.add,
        ),
      );

      await tester.enterText(find.byType(TextField), 'abc');

      expect(controller.text, 'abc');
      expect(changes, ['abc']);
    });

    testWidgets('ошибка показывается красным и перекрывает подсказку', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AppTextField(
          controller: TextEditingController(),
          label: 'Поле',
          errorText: 'Заполните поле',
          helperText: 'Подсказка',
        ),
      );

      expect(find.byKey(const Key('field-error')), findsOneWidget);
      expect(find.text('Заполните поле'), findsOneWidget);
      expect(find.text('Подсказка'), findsNothing);
    });

    testWidgets('без ошибки показывается подсказка', (tester) async {
      await pumpApp(
        tester,
        AppTextField(
          controller: TextEditingController(),
          label: 'Поле',
          helperText: 'Подсказка',
        ),
      );

      expect(find.text('Подсказка'), findsOneWidget);
      expect(find.byKey(const Key('field-error')), findsNothing);
    });

    testWidgets('принимает внешний FocusNode и реагирует на фокус', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pumpApp(
        tester,
        AppTextField(
          controller: TextEditingController(),
          label: 'Поле',
          focusNode: focusNode,
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
    });
  });

  group('MoneyField', () {
    Future<TextEditingController> pumpMoney(WidgetTester tester) async {
      final controller = TextEditingController();
      await pumpApp(
        tester,
        MoneyField(controller: controller, label: 'Сумма', onChanged: (_) {}),
      );
      return controller;
    }

    testWidgets('цифры и пробелы-разделители принимаются', (tester) async {
      final controller = await pumpMoney(tester);

      await tester.enterText(find.byType(TextField), '2 400');

      expect(controller.text, '2400');
    });

    testWidgets('правка с буквой, точкой или запятой отклоняется целиком', (
      tester,
    ) async {
      final controller = await pumpMoney(tester);
      await tester.enterText(find.byType(TextField), '2400');

      for (final bad in ['2400a', '2400.50', '2400,50', '-2400', '12a-3 4.5']) {
        await tester.enterText(find.byType(TextField), bad);
        expect(controller.text, '2400', reason: bad);
      }
    });

    testWidgets('длиннее девяти цифр — отклоняется, а не обрезается', (
      tester,
    ) async {
      final controller = await pumpMoney(tester);
      await tester.enterText(find.byType(TextField), '123456789');

      await tester.enterText(find.byType(TextField), '12345678901');

      expect(controller.text, '123456789');
    });

    testWidgets('знак валюты справа', (tester) async {
      await pumpMoney(tester);

      expect(find.text('₸'), findsOneWidget);
    });
  });

  group('AppPickerField', () {
    testWidgets('без значения показывает подсказку', (tester) async {
      await pumpApp(
        tester,
        AppPickerField(
          label: 'Начало',
          placeholder: 'Выбрать время',
          onTap: () {},
        ),
      );

      expect(find.text('Начало'), findsOneWidget);
      expect(find.text('Выбрать время'), findsOneWidget);
    });

    testWidgets('со значением показывает его вместо подсказки', (tester) async {
      await pumpApp(
        tester,
        AppPickerField(
          label: 'Начало',
          value: '08:10',
          placeholder: 'Выбрать время',
          onTap: () {},
        ),
      );

      expect(find.text('08:10'), findsOneWidget);
      expect(find.text('Выбрать время'), findsNothing);
    });

    testWidgets('нажатие вызывает onTap', (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        AppPickerField(label: 'Дата', value: '1 октября', onTap: () => taps++),
      );

      await tester.tap(find.text('1 октября'));

      expect(taps, 1);
    });

    testWidgets('показывает ошибку и значок', (tester) async {
      await pumpApp(
        tester,
        AppPickerField(
          label: 'Конец',
          placeholder: 'Выбрать время',
          icon: Icons.schedule,
          errorText: 'Заполните поле',
          onTap: () {},
        ),
      );

      expect(find.text('Заполните поле'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });
  });

  group('AppSegmentedControl', () {
    Future<void> pumpControl(
      WidgetTester tester, {
      String value = 'a',
      ValueChanged<String>? onChanged,
    }) => pumpApp(
      tester,
      AppSegmentedControl<String>(
        segments: const {'a': 'Наличные', 'b': 'Карта'},
        value: value,
        onChanged: onChanged ?? (_) {},
      ),
    );

    testWidgets('показывает все варианты', (tester) async {
      await pumpControl(tester);

      expect(find.text('Наличные'), findsOneWidget);
      expect(find.text('Карта'), findsOneWidget);
    });

    testWidgets('нажатие на вариант отдаёт его значение', (tester) async {
      final selected = <String>[];
      await pumpControl(tester, onChanged: selected.add);

      await tester.tap(find.text('Карта'));

      expect(selected, ['b']);
    });

    testWidgets('ползунок стоит под выбранным вариантом и переезжает', (
      tester,
    ) async {
      await pumpControl(tester, value: 'a');
      final first = tester.getCenter(find.byKey(const Key('segment-thumb')));

      await pumpControl(tester, value: 'b');
      await tester.pumpAndSettle();
      final second = tester.getCenter(find.byKey(const Key('segment-thumb')));

      expect(second.dx, greaterThan(first.dx));
      expect(first.dx, lessThan(tester.getCenter(find.text('Карта')).dx));
      expect(second.dx, closeTo(tester.getCenter(find.text('Карта')).dx, 2));
    });

    testWidgets('значение вне списка — ползунка нет', (tester) async {
      await pumpControl(tester, value: 'zzz');

      expect(find.byKey(const Key('segment-thumb')), findsNothing);
    });
  });
}
