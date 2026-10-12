import 'package:driver_diary/shared/ui/app_button.dart';
import 'package:driver_diary/shared/ui/app_card_section.dart';
import 'package:driver_diary/shared/ui/app_list_row.dart';
import 'package:driver_diary/shared/ui/app_spinner.dart';
import 'package:driver_diary/shared/ui/app_status_view.dart';
import 'package:driver_diary/shared/ui/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppButton', () {
    testWidgets('вызывает onPressed по нажатию', (tester) async {
      var taps = 0;
      await pumpApp(
        tester,
        AppButton(label: 'Сохранить', onPressed: () => taps++),
      );

      await tester.tap(find.text('Сохранить'));

      expect(taps, 1);
    });

    testWidgets('без onPressed отключена и не реагирует', (tester) async {
      await pumpApp(
        tester,
        const AppButton(label: 'Сохранить', onPressed: null),
      );

      await tester.tap(find.text('Сохранить'), warnIfMissed: false);
      await tester.pump();

      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    });

    testWidgets('при загрузке вместо подписи спиннер и нажатие заблокировано', (
      tester,
    ) async {
      var taps = 0;
      await pumpApp(
        tester,
        AppButton(label: 'Сохранить', onPressed: () => taps++, isLoading: true),
        settle: false,
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Сохранить'), findsNothing);
      expect(taps, 0);
    });

    testWidgets('показывает значок рядом с подписью', (tester) async {
      await pumpApp(
        tester,
        AppButton(label: 'Добавить', onPressed: () {}, icon: Icons.add),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Добавить'), findsOneWidget);
    });

    testWidgets('expanded растягивает кнопку на всю ширину', (tester) async {
      await pumpApp(
        tester,
        Align(
          alignment: Alignment.topCenter,
          child: AppButton(label: 'Ок', onPressed: () {}, expanded: true),
        ),
        size: const Size(400, 800),
      );

      expect(tester.getSize(find.byType(AppButton)).width, 400);
    });

    for (final variant in AppButtonVariant.values) {
      testWidgets('вариант ${variant.name} отрисовывается в обеих темах', (
        tester,
      ) async {
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await pumpApp(
            tester,
            AppButton(label: 'Кнопка', onPressed: () {}, variant: variant),
            themeMode: mode,
          );

          expect(find.text('Кнопка'), findsOneWidget);
        }
      });
    }
  });

  group('AppListRow', () {
    testWidgets('показывает заголовок, подпись, значок и значение', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AppListRow(
          title: 'Заголовок',
          subtitle: 'Подпись',
          leading: Icon(Icons.star),
          trailing: Text('42'),
        ),
      );

      expect(find.text('Заголовок'), findsOneWidget);
      expect(find.text('Подпись'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('без onTap не создаёт интерактивной области', (tester) async {
      await pumpApp(tester, const AppListRow(title: 'Строка'));

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('с onTap реагирует на нажатие', (tester) async {
      var taps = 0;
      await pumpApp(tester, AppListRow(title: 'Строка', onTap: () => taps++));

      await tester.tap(find.text('Строка'));

      expect(taps, 1);
    });
  });

  group('AppCardSection', () {
    testWidgets('рисует заголовок и разделители только между строками', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AppCardSection(
          header: 'Секция',
          children: [Text('Первая'), Text('Вторая'), Text('Третья')],
        ),
      );

      expect(find.text('Секция'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('одна строка — без разделителей, заголовок необязателен', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const AppCardSection(children: [Text('Единственная')]),
      );

      expect(find.byType(Divider), findsNothing);
      expect(find.text('Единственная'), findsOneWidget);
    });
  });

  group('AppStatusView', () {
    testWidgets('показывает заголовок и пояснение', (tester) async {
      await pumpApp(
        tester,
        const AppStatusView(
          icon: Icons.inbox,
          title: 'Пусто',
          message: 'Здесь ничего нет',
        ),
      );

      expect(find.text('Пусто'), findsOneWidget);
      expect(find.text('Здесь ничего нет'), findsOneWidget);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('кнопки появляются только вместе с обработчиками', (
      tester,
    ) async {
      var primary = 0;
      var secondary = 0;
      await pumpApp(
        tester,
        AppStatusView(
          icon: Icons.error,
          title: 'Ошибка',
          isError: true,
          actionLabel: 'Повторить',
          onAction: () => primary++,
          secondaryActionLabel: 'Настройки',
          onSecondaryAction: () => secondary++,
        ),
      );

      await tester.tap(find.text('Повторить'));
      await tester.tap(find.text('Настройки'));

      expect((primary, secondary), (1, 1));
    });

    testWidgets('подпись без обработчика кнопку не создаёт', (tester) async {
      await pumpApp(
        tester,
        const AppStatusView(
          icon: Icons.error,
          title: 'Ошибка',
          actionLabel: 'Повторить',
        ),
      );

      expect(find.byType(AppButton), findsNothing);
    });
  });

  testWidgets('AppSpinner рисует индикатор заданного размера', (tester) async {
    await pumpApp(
      tester,
      const Center(child: AppSpinner(size: 40)),
      settle: false,
    );

    expect(tester.getSize(find.byType(AppSpinner)), const Size(40, 40));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  group('pagePadding', () {
    Future<EdgeInsets> padding(WidgetTester tester, double width) async {
      late EdgeInsets result;
      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            result = pagePadding(context);
            return const SizedBox();
          },
        ),
        size: Size(width, 800),
      );
      return result;
    }

    testWidgets('на узком экране поля равны минимальным', (tester) async {
      final result = await padding(tester, 400);

      expect(result.left, kPageGutter);
      expect(result.right, kPageGutter);
    });

    testWidgets('на широком экране контент центрируется в колонке', (
      tester,
    ) async {
      final result = await padding(tester, 1176);

      expect(result.left, (1176 - kMaxContentWidth) / 2);
      expect(result.left, result.right);
    });
  });
}
