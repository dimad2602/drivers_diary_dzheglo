import 'package:driver_diary/app/theme/app_motion.dart';
import 'package:driver_diary/shared/ui/app_button.dart';
import 'package:driver_diary/shared/ui/app_field_frame.dart';
import 'package:driver_diary/shared/ui/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppButton: эффект нажатия', () {
    double scaleOf(WidgetTester tester) => tester
        .widget<AnimatedScale>(
          find.descendant(
            of: find.byType(AppButton),
            matching: find.byType(AnimatedScale),
          ),
        )
        .scale;

    Future<TestGesture> pressButton(WidgetTester tester) =>
        tester.startGesture(tester.getCenter(find.byType(AppButton)));

    testWidgets('нажатая кнопка слегка сжимается, отпущенная возвращается', (
      tester,
    ) async {
      await pumpApp(tester, AppButton(label: 'Сохранить', onPressed: () {}));
      expect(scaleOf(tester), 1);

      final gesture = await pressButton(tester);
      await tester.pump(AppMotion.base);
      expect(scaleOf(tester), AppButton.pressedScale);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(scaleOf(tester), 1);
    });

    testWidgets('сжатие плавное: сразу после нажатия размер ещё меняется', (
      tester,
    ) async {
      await pumpApp(tester, AppButton(label: 'Сохранить', onPressed: () {}));
      final before = tester.getSize(find.byType(Material).last);

      final gesture = await pressButton(tester);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 40));
      final during = tester.getSize(find.byType(Material).last);
      await gesture.up();
      await tester.pumpAndSettle();

      // Размер самой кнопки (layout) не меняется — масштабируется только отрисовка.
      expect(during, before);
    });

    testWidgets('отключённая кнопка не реагирует на нажатие', (tester) async {
      await pumpApp(
        tester,
        const AppButton(label: 'Сохранить', onPressed: null),
      );

      final gesture = await pressButton(tester);
      await tester.pump(AppMotion.base);

      expect(scaleOf(tester), 1);
      await gesture.up();
    });

    testWidgets('во время загрузки кнопка не сжимается', (tester) async {
      await pumpApp(
        tester,
        AppButton(label: 'Сохранить', onPressed: () {}, isLoading: true),
        settle: false,
      );

      final gesture = await pressButton(tester);
      await tester.pump(AppMotion.base);

      expect(scaleOf(tester), 1);
      await gesture.up();
    });

    testWidgets('«убрать анимации»: сжатие мгновенное', (tester) async {
      await pumpApp(
        tester,
        AppButton(label: 'Сохранить', onPressed: () {}),
        reducedMotion: true,
      );

      final gesture = await pressButton(tester);
      await tester.pump(const Duration(milliseconds: 150));

      expect(scaleOf(tester), AppButton.pressedScale);
      expect(
        tester
            .widget<AnimatedScale>(
              find.descendant(
                of: find.byType(AppButton),
                matching: find.byType(AnimatedScale),
              ),
            )
            .duration,
        Duration.zero,
      );
      await gesture.up();
    });
  });

  group('поля формы: плавное появление ошибки', () {
    Future<void> pumpField(WidgetTester tester, {String? error}) => pumpApp(
      tester,
      AppTextField(
        controller: TextEditingController(),
        label: 'Сумма',
        errorText: error,
      ),
      settle: false,
    );

    // Область под полем, в которой появляется ошибка или подсказка.
    double frameHeight(WidgetTester tester) => tester
        .getSize(
          find.descendant(
            of: find.byType(AppFieldFrame),
            matching: find.byType(AnimatedSize),
          ),
        )
        .height;

    testWidgets('форма раздвигается постепенно, а не прыгает', (tester) async {
      await pumpField(tester);
      await tester.pump();
      final without = frameHeight(tester);

      await pumpField(tester, error: 'Заполните поле');
      await tester.pump(const Duration(milliseconds: 80));
      final during = frameHeight(tester);
      await tester.pumpAndSettle();
      final withError = frameHeight(tester);

      expect(withError, greaterThan(without));
      expect(during, greaterThan(without));
      expect(during, lessThan(withError));
    });

    testWidgets('при исчезновении ошибки форма так же плавно сжимается', (
      tester,
    ) async {
      await pumpField(tester, error: 'Заполните поле');
      await tester.pumpAndSettle();
      final withError = frameHeight(tester);

      await pumpField(tester);
      await tester.pump(const Duration(milliseconds: 80));
      final during = frameHeight(tester);
      await tester.pumpAndSettle();
      final without = frameHeight(tester);

      expect(without, lessThan(withError));
      expect(during, lessThan(withError));
      expect(during, greaterThan(without));
    });

    testWidgets('текст ошибки появляется сразу, а исчезает мгновенно', (
      tester,
    ) async {
      await pumpField(tester, error: 'Заполните поле');
      expect(find.text('Заполните поле'), findsOneWidget);

      await pumpField(tester);
      await tester.pump();

      // Тест на повторную правку не должен ждать окончания анимации.
      expect(find.text('Заполните поле'), findsNothing);
    });
  });
}
