import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/app/theme/app_motion.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/presentation/bloc/diary/diary_bloc.dart';
import 'package:driver_diary/presentation/features/diary/diary_page.dart';
import 'package:driver_diary/presentation/features/diary/widgets/day_switcher.dart';
import 'package:driver_diary/presentation/features/diary/widgets/payment_split_bar.dart';
import 'package:driver_diary/presentation/features/diary/widgets/summary_card.dart';
import 'package:driver_diary/shared/ui/animations/animations.dart';
import 'package:driver_diary/shared/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

class _MockDiaryBloc extends MockBloc<DiaryEvent, DiaryState>
    implements DiaryBloc {}

String ru(int amount) => formatMoney(amount, 'ru');

double opacityOf(WidgetTester tester, Finder within) => tester
    .widget<FadeTransition>(
      find.descendant(of: within, matching: find.byType(FadeTransition)).first,
    )
    .opacity
    .value;

void main() {
  final today = DateTime(2026, 10, 12);
  const emptyDiary = DayDiary(summary: emptySummary, trips: []);

  late _MockDiaryBloc bloc;

  Future<void> pumpDiary(
    WidgetTester tester,
    DiaryState state, {
    bool settle = false,
    bool reducedMotion = false,
  }) async {
    when(() => bloc.today).thenReturn(today);
    when(() => bloc.canGoNext).thenReturn(false);
    whenListen(bloc, const Stream<DiaryState>.empty(), initialState: state);
    await pumpApp(
      tester,
      BlocProvider<DiaryBloc>.value(value: bloc, child: const DiaryView()),
      scaffold: false,
      settle: settle,
      reducedMotion: reducedMotion,
    );
  }

  setUpAll(() async {
    registerFallbackValue(const DiaryEvent.started());
    await initializeDateFormatting('ru');
  });

  setUp(() => bloc = _MockDiaryBloc());

  group('появление содержимого дня', () {
    testWidgets('сводка и список появляются каскадом', (tester) async {
      await pumpDiary(
        tester,
        DiaryState.success(date: today, diary: makeDiary()),
      );

      expect(find.byType(StaggeredList), findsOneWidget);
      expect(find.byType(SummaryCard), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      final summary = find.ancestor(
        of: find.byType(SummaryCard),
        matching: find.byType(FadeSlideIn),
      );
      final trips = find.ancestor(
        of: find.text('Поездки'),
        matching: find.byType(FadeSlideIn),
      );
      // Сводка опережает список: список стартует позже на шаг каскада.
      expect(opacityOf(tester, summary), greaterThan(opacityOf(tester, trips)));

      await tester.pumpAndSettle();
      expect(opacityOf(tester, summary), 1);
      expect(opacityOf(tester, trips), 1);
    });

    testWidgets('сумма «на руки» досчитывается от нуля до итога', (
      tester,
    ) async {
      await pumpDiary(
        tester,
        DiaryState.success(date: today, diary: makeDiary()),
      );
      Text net() => tester.widget<Text>(find.byKey(const Key('summary-net')));

      expect(net().data, ru(0));

      await tester.pump(const Duration(milliseconds: 200));
      expect(net().data, isNot(ru(0)));
      expect(net().data, isNot(ru(3315)));

      await tester.pumpAndSettle();
      expect(net().data, ru(3315));
    });

    testWidgets('полоса «наличные / карта» вырастает слева направо', (
      tester,
    ) async {
      await pumpDiary(
        tester,
        DiaryState.success(date: today, diary: makeDiary()),
      );
      final bar = find.descendant(
        of: find.byType(PaymentSplitBar),
        matching: find.byType(FractionallySizedBox),
      );
      double grown() => tester.widget<FractionallySizedBox>(bar).widthFactor!;

      expect(grown(), 0);
      await tester.pump(const Duration(milliseconds: 150));
      expect(grown(), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(grown(), 1);
    });

    testWidgets('пустой день проявляется fade-ом', (tester) async {
      await pumpDiary(
        tester,
        DiaryState.success(date: today, diary: emptyDiary),
      );
      final empty = find.ancestor(
        of: find.text('Поездок нет'),
        matching: find.byType(FadeIn),
      );

      expect(opacityOf(tester, empty), 0);
      await tester.pumpAndSettle();
      expect(opacityOf(tester, empty), 1);
    });

    testWidgets('ошибка проявляется fade-ом', (tester) async {
      await pumpDiary(
        tester,
        DiaryState.failure(date: today, error: TripsError.server),
      );
      final error = find.ancestor(
        of: find.text('Ошибка сервера'),
        matching: find.byType(FadeIn),
      );

      expect(opacityOf(tester, error), 0);
      await tester.pumpAndSettle();
      expect(opacityOf(tester, error), 1);
    });

    testWidgets(
      'спиннер загрузки появляется с задержкой — быстрые ответы без мигания',
      (tester) async {
        await pumpDiary(tester, DiaryState.loading(date: today));
        final spinner = find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(FadeIn),
        );

        await tester.pump(const Duration(milliseconds: 100));
        expect(opacityOf(tester, spinner), 0);

        await tester.pump(AppMotion.base);
        expect(opacityOf(tester, spinner), greaterThan(0));
      },
    );

    testWidgets(
      '«убрать анимации»: всё сразу на месте с итоговыми значениями',
      (tester) async {
        await pumpDiary(
          tester,
          DiaryState.success(date: today, diary: makeDiary()),
          reducedMotion: true,
        );
        await tester.pump();

        expect(
          tester.widget<Text>(find.byKey(const Key('summary-net'))).data,
          ru(3315),
        );
        expect(
          tester
              .widget<FractionallySizedBox>(
                find.descendant(
                  of: find.byType(PaymentSplitBar),
                  matching: find.byType(FractionallySizedBox),
                ),
              )
              .widthFactor,
          1,
        );
        final summary = find.ancestor(
          of: find.byType(SummaryCard),
          matching: find.byType(FadeSlideIn),
        );
        expect(opacityOf(tester, summary), 1);
      },
    );
  });

  group('переключатель дня', () {
    testWidgets('при смене дня подпись плавно сменяется', (tester) async {
      Future<void> pumpSwitcher(DateTime date) => pumpApp(
        tester,
        DaySwitcher(
          date: date,
          today: today,
          onPrevious: () {},
          onNext: () {},
          onPickDate: () {},
        ),
        settle: false,
      );

      await pumpSwitcher(DateTime(2026, 10, 1));
      await tester.pump(AppMotion.fast);
      expect(find.text('Четверг'), findsOneWidget);

      await pumpSwitcher(DateTime(2026, 10, 2));
      await tester.pump(const Duration(milliseconds: 80));
      // В середине перехода видны обе подписи.
      expect(find.text('Четверг'), findsOneWidget);
      expect(find.text('Пятница'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Четверг'), findsNothing);
      expect(find.text('Пятница'), findsOneWidget);
    });
  });
}
