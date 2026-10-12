import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/presentation/features/diary/widgets/day_switcher.dart';
import 'package:driver_diary/presentation/features/diary/widgets/payment_split_bar.dart';
import 'package:driver_diary/presentation/features/diary/widgets/summary_card.dart';
import 'package:driver_diary/presentation/features/diary/widgets/trip_tile.dart';
import 'package:driver_diary/presentation/features/diary/widgets/trips_list.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:driver_diary/shared/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

String ru(int amount) => formatMoney(amount, 'ru');

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  group('DaySwitcher', () {
    final today = DateTime(2026, 10, 12);

    Future<void> pumpSwitcher(
      WidgetTester tester,
      DateTime date, {
      VoidCallback? onPrevious,
      VoidCallback? onNext,
      VoidCallback? onPick,
      Locale locale = const Locale('ru'),
    }) => pumpApp(
      tester,
      DaySwitcher(
        date: date,
        today: today,
        onPrevious: onPrevious ?? () {},
        onNext: onNext,
        onPickDate: onPick ?? () {},
      ),
      locale: locale,
    );

    testWidgets('сегодня подписан «Сегодня»', (tester) async {
      await pumpSwitcher(tester, today);

      expect(find.text('Сегодня'), findsOneWidget);
      expect(find.text(formatFullDate(today, 'ru')), findsOneWidget);
    });

    testWidgets('вчера подписан «Вчера»', (tester) async {
      await pumpSwitcher(tester, DateTime(2026, 10, 11));

      expect(find.text('Вчера'), findsOneWidget);
    });

    testWidgets('прошлые дни подписаны днём недели', (tester) async {
      await pumpSwitcher(tester, DateTime(2026, 10, 1));

      expect(find.text('Четверг'), findsOneWidget);
      expect(
        find.text(formatFullDate(DateTime(2026, 10, 1), 'ru')),
        findsOneWidget,
      );
    });

    testWidgets('на английском подписи тоже переводятся', (tester) async {
      await pumpSwitcher(tester, today, locale: const Locale('en'));

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('October 12, 2026'), findsOneWidget);
    });

    testWidgets('стрелки и дата вызывают свои обработчики', (tester) async {
      final calls = <String>[];
      await pumpSwitcher(
        tester,
        DateTime(2026, 10, 1),
        onPrevious: () => calls.add('prev'),
        onNext: () => calls.add('next'),
        onPick: () => calls.add('pick'),
      );

      await tester.tap(find.byTooltip('Предыдущий день'));
      await tester.tap(find.byTooltip('Следующий день'));
      await tester.tap(find.text('Четверг'));

      expect(calls, ['prev', 'next', 'pick']);
    });

    testWidgets('без onNext стрелка «вперёд» отключена', (tester) async {
      await pumpSwitcher(tester, today);

      final next = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(next.onPressed, isNull);
    });
  });

  group('PaymentSplitBar', () {
    testWidgets('оба способа — две части пропорционально выручке', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const PaymentSplitBar(cashRevenue: 1500, cardRevenue: 2500),
      );

      final cash = tester.getSize(find.byKey(const Key('split-cash'))).width;
      final card = tester.getSize(find.byKey(const Key('split-card'))).width;
      expect(card / cash, closeTo(2500 / 1500, 0.01));
    });

    testWidgets('только карта — одна часть', (tester) async {
      await pumpApp(
        tester,
        const PaymentSplitBar(cashRevenue: 0, cardRevenue: 800),
      );

      expect(find.byKey(const Key('split-card')), findsOneWidget);
      expect(find.byKey(const Key('split-cash')), findsNothing);
      expect(find.byKey(const Key('split-empty')), findsNothing);
    });

    testWidgets('без выручки — пустая дорожка', (tester) async {
      await pumpApp(
        tester,
        const PaymentSplitBar(cashRevenue: 0, cardRevenue: 0),
      );

      expect(find.byKey(const Key('split-empty')), findsOneWidget);
      expect(find.byKey(const Key('split-cash')), findsNothing);
      expect(find.byKey(const Key('split-card')), findsNothing);
    });
  });

  group('SummaryCard', () {
    testWidgets('показывает «на руки», выручку, комиссию и число поездок', (
      tester,
    ) async {
      await pumpApp(tester, const SummaryCard(summary: exampleSummary));

      expect(find.text('На руки'), findsOneWidget);
      expect(find.byKey(const Key('summary-net')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('summary-net'))).data,
        ru(3315),
      );
      expect(find.text(ru(3900)), findsOneWidget);
      expect(find.text(ru(-585)), findsOneWidget);
      expect(find.text('Поездок'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('разбивка: у каждого способа своя выручка и число поездок', (
      tester,
    ) async {
      await pumpApp(tester, const SummaryCard(summary: exampleSummary));

      expect(find.text('Наличные'), findsOneWidget);
      expect(find.text('Карта'), findsOneWidget);
      expect(find.text(ru(1500)), findsOneWidget);
      expect(find.text(ru(2400)), findsOneWidget);
      expect(find.text('1 поездка'), findsNWidgets(2));
      expect(find.byKey(const Key('legend-count-cash')), findsOneWidget);
      expect(find.byKey(const Key('legend-count-card')), findsOneWidget);
      expect(find.byKey(const Key('split-cash')), findsOneWidget);
      expect(find.byKey(const Key('split-card')), findsOneWidget);
    });

    testWidgets('работает на английском и в тёмной теме', (tester) async {
      await pumpApp(
        tester,
        const SummaryCard(summary: exampleSummary),
        locale: const Locale('en'),
        themeMode: ThemeMode.dark,
      );

      expect(find.text('Take-home'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
    });
  });

  group('TripTile', () {
    testWidgets('время, длительность, способ оплаты, сумма и комиссия', (
      tester,
    ) async {
      await pumpApp(tester, TripTile(trip: makeTrip()));

      expect(find.text('08:10 – 08:32'), findsOneWidget);
      expect(find.text('22 мин · Карта'), findsOneWidget);
      expect(find.text(ru(2400)), findsOneWidget);
      expect(find.text(ru(-360)), findsOneWidget);
      expect(find.byIcon(Icons.credit_card_outlined), findsOneWidget);
    });

    testWidgets('наличные получают свой значок', (tester) async {
      await pumpApp(
        tester,
        TripTile(trip: makeTrip(payment: PaymentMethod.cash)),
      );

      expect(find.byIcon(Icons.payments_outlined), findsOneWidget);
      expect(find.textContaining('Наличные'), findsOneWidget);
    });

    testWidgets('без комиссии строка комиссии не рисуется', (tester) async {
      await pumpApp(tester, TripTile(trip: makeTrip(commission: 0)));

      expect(find.text(ru(2400)), findsOneWidget);
      expect(find.textContaining('−'), findsNothing);
    });

    testWidgets('часы и минуты в длительности', (tester) async {
      await pumpApp(
        tester,
        TripTile(
          trip: makeTrip(start: at(1, 8, 0), end: at(1, 9, 5)),
        ),
      );

      expect(find.textContaining('1 ч 05 мин'), findsOneWidget);
    });

    testWidgets('время показывается по поясу поездки, а не устройства', (
      tester,
    ) async {
      // 08:10 по +05:00 = 03:10 UTC; на экране должно остаться 08:10.
      await pumpApp(tester, TripTile(trip: makeTrip()));

      expect(find.textContaining('08:10'), findsOneWidget);
    });

    testWidgets('на английском', (tester) async {
      await pumpApp(
        tester,
        TripTile(trip: makeTrip()),
        locale: const Locale('en'),
      );

      expect(find.text('22 min · Card'), findsOneWidget);
    });
  });

  testWidgets('TripsList выводит заголовок и все поездки по порядку', (
    tester,
  ) async {
    await pumpApp(tester, TripsList(trips: makeDiary().trips));

    expect(find.text('Поездки'), findsOneWidget);
    expect(find.byType(TripTile), findsNWidgets(2));
    expect(
      tester.getTopLeft(find.text('08:10 – 08:32')).dy,
      lessThan(tester.getTopLeft(find.text('09:05 – 09:20')).dy),
    );
  });
}
