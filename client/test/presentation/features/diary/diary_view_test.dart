import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/presentation/bloc/diary/diary_bloc.dart';
import 'package:driver_diary/presentation/features/diary/diary_page.dart';
import 'package:driver_diary/presentation/features/diary/widgets/trip_tile.dart';
import 'package:driver_diary/shared/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

/// Виджет-тесты работают с MockBloc: логика Bloc проверена в diary_bloc_test.dart,
/// здесь — что экран рисует состояния и отправляет правильные события.
class _MockDiaryBloc extends MockBloc<DiaryEvent, DiaryState>
    implements DiaryBloc {}

String ru(int amount) => formatMoney(amount, 'ru');

void main() {
  final today = DateTime(2026, 10, 12);
  const emptyDiary = DayDiary(summary: emptySummary, trips: []);

  late _MockDiaryBloc bloc;
  late StreamController<DiaryState> states;

  DiaryState success({bool refreshing = false, TripsError? lastError}) =>
      DiaryState.success(
        date: today,
        diary: makeDiary(),
        isRefreshing: refreshing,
        lastError: lastError,
      );

  /// Задаёт текущее состояние Bloc; [states] позволяет менять его по ходу теста.
  void givenState(DiaryState state, {bool canGoNext = false}) {
    when(() => bloc.canGoNext).thenReturn(canGoNext);
    whenListen(bloc, states.stream, initialState: state);
  }

  /// Тот же `bloc.state`, что и у BlocBuilder, после [DiaryState] в [states].
  Future<void> emitState(WidgetTester tester, DiaryState state) async {
    when(() => bloc.state).thenReturn(state);
    states.add(state);
    await tester.pump();
    await tester.pump();
  }

  Future<void> pumpView(
    WidgetTester tester, {
    bool settle = true,
    Locale locale = const Locale('ru'),
  }) {
    return pumpApp(
      tester,
      BlocProvider<DiaryBloc>.value(value: bloc, child: const DiaryView()),
      scaffold: false,
      settle: settle,
      locale: locale,
    );
  }

  /// События, отправленные в Bloc экраном.
  List<DiaryEvent> sentEvents() =>
      verify(() => bloc.add(captureAny())).captured.cast<DiaryEvent>();

  setUpAll(() async {
    registerFallbackValue(const DiaryEvent.started());
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  setUp(() {
    bloc = _MockDiaryBloc();
    states = StreamController<DiaryState>.broadcast();
    when(() => bloc.today).thenReturn(today);
  });

  tearDown(() => states.close());

  group('состояния', () {
    testWidgets('загрузка: спиннер, переключатель дня остаётся', (
      tester,
    ) async {
      givenState(DiaryState.loading(date: today));

      await pumpView(tester, settle: false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Сегодня'), findsOneWidget);
    });

    testWidgets('день с поездками: сводка и список', (tester) async {
      givenState(success());

      await pumpView(tester);

      expect(find.text('На руки'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('summary-net'))).data,
        ru(3315),
      );
      expect(find.byType(TripTile), findsNWidgets(2));
      expect(find.text('Поездки'), findsOneWidget);
    });

    testWidgets('день без поездок: пустое состояние вместо нулевой сводки', (
      tester,
    ) async {
      givenState(DiaryState.success(date: today, diary: emptyDiary));

      await pumpView(tester);

      expect(find.text('Поездок нет'), findsOneWidget);
      expect(find.text('На руки'), findsNothing);
      expect(find.byType(TripTile), findsNothing);
    });

    testWidgets('ошибка: заголовок и пояснение, данных нет', (tester) async {
      givenState(
        DiaryState.failure(date: today, error: TripsError.noConnection),
      );

      await pumpView(tester);

      expect(find.text('Нет связи с сервером'), findsOneWidget);
      expect(find.byType(TripTile), findsNothing);
    });

    testWidgets('неверный ключ показывает свой текст ошибки', (tester) async {
      givenState(
        DiaryState.failure(date: today, error: TripsError.unauthorized),
      );

      await pumpView(tester);

      expect(find.text('Доступ запрещён'), findsOneWidget);
      expect(find.text('API-ключ не задан или неверен.'), findsOneWidget);
    });

    testWidgets('английский язык', (tester) async {
      givenState(success());

      await pumpView(tester, locale: const Locale('en'));

      expect(find.text('Take-home'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Trips'), findsWidgets);
    });

    testWidgets('смена состояния перерисовывает экран', (tester) async {
      givenState(DiaryState.loading(date: today), canGoNext: false);
      await pumpView(tester, settle: false);
      expect(find.byType(TripTile), findsNothing);

      await emitState(tester, success());

      expect(find.byType(TripTile), findsNWidgets(2));
    });
  });

  group('события', () {
    testWidgets('«Повторить» после ошибки отправляет reloadRequested', (
      tester,
    ) async {
      givenState(DiaryState.failure(date: today, error: TripsError.server));
      await pumpView(tester);

      await tester.tap(find.text('Повторить'));

      expect(sentEvents(), [const DiaryEvent.reloadRequested()]);
    });

    testWidgets('кнопка «Обновить» отправляет reloadRequested', (tester) async {
      givenState(success());
      await pumpView(tester);

      await tester.tap(find.byTooltip('Обновить'));

      expect(sentEvents(), [const DiaryEvent.reloadRequested()]);
    });

    testWidgets('стрелка «назад» отправляет previousDayRequested', (
      tester,
    ) async {
      givenState(success());
      await pumpView(tester);

      await tester.tap(find.byTooltip('Предыдущий день'));

      expect(sentEvents(), [const DiaryEvent.previousDayRequested()]);
    });

    testWidgets('на сегодняшнем дне «вперёд» отключено', (tester) async {
      givenState(success(), canGoNext: false);
      await pumpView(tester);

      final next = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );

      expect(next.onPressed, isNull);
    });

    testWidgets('в прошлом «вперёд» работает и отправляет nextDayRequested', (
      tester,
    ) async {
      givenState(
        DiaryState.success(date: DateTime(2026, 10, 11), diary: emptyDiary),
        canGoNext: true,
      );
      await pumpView(tester);

      await tester.tap(find.byTooltip('Следующий день'));

      expect(sentEvents(), [const DiaryEvent.nextDayRequested()]);
    });

    testWidgets('календарь: выбранный день уходит в dateSelected', (
      tester,
    ) async {
      givenState(success());
      await pumpView(tester);

      await tester.tap(find.byTooltip('Выбрать день'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('10'));
      await tester.pump();
      await tester.tap(
        find
            .descendant(
              of: find.byType(DatePickerDialog),
              matching: find.byType(TextButton),
            )
            .last,
      );
      await tester.pumpAndSettle();

      expect(sentEvents(), [DiaryEvent.dateSelected(DateTime(2026, 10, 10))]);
    });

    testWidgets('в календаре нельзя выбрать будущие дни', (tester) async {
      givenState(success());
      await pumpView(tester);

      await tester.tap(find.byTooltip('Выбрать день'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('13')); // завтра: день недоступен
      await tester.pump();
      await tester.tap(
        find
            .descendant(
              of: find.byType(DatePickerDialog),
              matching: find.byType(TextButton),
            )
            .last,
      );
      await tester.pumpAndSettle();

      // Остался исходный день — «завтра» выбрать не получилось.
      expect(sentEvents(), [DiaryEvent.dateSelected(today)]);
    });

    testWidgets(
      'pull-to-refresh отправляет refreshRequested и ждёт его завершения',
      (tester) async {
        givenState(success());
        // Bloc завершает completer, когда обновление закончено.
        when(() => bloc.add(any())).thenAnswer((invocation) {
          final event = invocation.positionalArguments.first as DiaryEvent;
          event.mapOrNull(refreshRequested: (e) => e.completer?.complete());
        });
        await pumpView(tester);

        await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
        await tester.pumpAndSettle();

        final events = sentEvents();
        expect(events, hasLength(1));
        expect(
          events.single.mapOrNull(refreshRequested: (e) => e.completer),
          isNotNull,
        );
        expect(find.byType(RefreshProgressIndicator), findsNothing);
        expect(find.byType(TripTile), findsNWidgets(2));
      },
    );
  });

  group('ошибка тихого обновления', () {
    testWidgets('данные остаются, показывается SnackBar', (tester) async {
      givenState(success());
      await pumpView(tester);

      await emitState(tester, success(refreshing: true));
      await emitState(tester, success(lastError: TripsError.noConnection));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Нет связи с сервером'),
        ),
        findsOneWidget,
      );
      expect(find.byType(TripTile), findsNWidgets(2));
    });

    testWidgets('повторная ошибка снова показывает сообщение', (tester) async {
      givenState(success());
      await pumpView(tester);
      await emitState(tester, success(refreshing: true));
      await emitState(tester, success(lastError: TripsError.noConnection));
      // Таймер SnackBar стартует после анимации появления: дожидаемся её,
      // затем времени показа (4 с) и анимации ухода.
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);

      await emitState(tester, success(refreshing: true));
      await emitState(tester, success(lastError: TripsError.noConnection));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('без ошибки SnackBar не появляется', (tester) async {
      givenState(success());
      await pumpView(tester);

      await emitState(tester, success(refreshing: true));
      await emitState(tester, success());

      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
