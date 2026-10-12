import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/domain/models/trip_draft.dart';
import 'package:driver_diary/presentation/bloc/add_trip/add_trip_bloc.dart';
import 'package:driver_diary/presentation/features/add_trip/add_trip_page.dart';
import 'package:driver_diary/shared/ui/app_button.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

/// Виджет-тесты работают с MockBloc: логика отправки проверена в add_trip_bloc_test.dart,
/// здесь — что форма проверяет ввод и отправляет правильный черновик.
class _MockAddTripBloc extends MockBloc<AddTripEvent, AddTripState>
    implements AddTripBloc {}

void main() {
  final initialDate = DateTime(2026, 10, 1);
  final today = DateTime(2026, 10, 12);

  late _MockAddTripBloc bloc;
  late StreamController<AddTripState> states;
  Trip? poppedTrip;

  /// Открывает форму поверх стартовой страницы, чтобы работал `context.pop`.
  Future<void> openForm(
    WidgetTester tester, {
    Locale locale = const Locale('ru'),
  }) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async =>
                    poppedTrip = await context.push<Trip>('/add'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => BlocProvider<AddTripBloc>.value(
            value: bloc,
            child: AddTripView(initialDate: initialDate, today: today),
          ),
        ),
      ],
    );
    await pumpRouterApp(tester, router, locale: locale);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Finder inField(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(TextField),
  );

  /// Вводит время в поле: форматтер сам расставляет двоеточие.
  Future<void> typeTime(
    WidgetTester tester,
    String fieldKey,
    String text,
  ) async {
    await tester.enterText(inField(fieldKey), text);
    await tester.pump();
  }

  /// Открывает циферблат по значку часов и подтверждает предложенное время.
  Future<void> pickOnDial(WidgetTester tester, String fieldKey) async {
    await tester.tap(
      find.descendant(
        of: find.byKey(Key(fieldKey)),
        matching: find.byIcon(Icons.schedule_outlined),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('ОК'));
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('submit')));
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pump();
  }

  /// Черновики, отправленные формой в Bloc.
  List<TripDraft> sentDrafts() =>
      verify(() => bloc.add(captureAny())).captured
          .cast<AddTripEvent>()
          .map((e) => e.map(submitted: (s) => s.draft))
          .toList();

  setUpAll(() async {
    registerFallbackValue(AddTripEvent.submitted(makeDraft()));
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  setUp(() {
    bloc = _MockAddTripBloc();
    states = StreamController<AddTripState>.broadcast();
    poppedTrip = null;
    whenListen(bloc, states.stream, initialState: const AddTripState.initial());
  });

  tearDown(() => states.close());

  group('начальный вид', () {
    testWidgets('дата из дневника, время и суммы пусты, оплата — картой', (
      tester,
    ) async {
      await openForm(tester);

      expect(find.text('Новая поездка'), findsOneWidget);
      expect(
        find.text(formatFullDate(DateTime(2026, 10, 1), 'ru')),
        findsOneWidget,
      );
      expect(find.text('ЧЧ:ММ'), findsNWidgets(2));
      expect(
        tester.widget<TextField>(inField('field-amount')).controller!.text,
        '',
      );
      expect(
        tester.widget<TextField>(inField('field-commission')).controller!.text,
        '',
      );
      expect(find.text('Сохранить'), findsOneWidget);
    });

    testWidgets('английский язык', (tester) async {
      await openForm(tester, locale: const Locale('en'));

      expect(find.text('New trip'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('HH:MM'), findsNWidgets(2));
      expect(find.text('Save'), findsOneWidget);
    });
  });

  group('проверка перед отправкой', () {
    testWidgets('пустая форма: ошибки у всех полей, в Bloc ничего не уходит', (
      tester,
    ) async {
      await openForm(tester);

      await save(tester);

      expect(find.text('Заполните поле'), findsNWidgets(4));
      verifyNever(() => bloc.add(any()));
    });

    testWidgets('ошибка поля исчезает, как только его начали править', (
      tester,
    ) async {
      await openForm(tester);
      await save(tester);
      expect(find.text('Заполните поле'), findsNWidgets(4));

      await tester.enterText(inField('field-amount'), '2400');
      await tester.pump();

      // Сумма заполнена, комиссия посчиталась сама, остались два времени.
      expect(find.text('Заполните поле'), findsNWidgets(2));
    });

    testWidgets('комиссия больше суммы: понятное сообщение', (tester) async {
      await openForm(tester);
      await typeTime(tester, 'field-start', '0900');
      await typeTime(tester, 'field-end', '0930');
      await tester.enterText(inField('field-amount'), '1000');
      await tester.enterText(inField('field-commission'), '1500');

      await save(tester);

      expect(find.text('Комиссия не может быть больше суммы'), findsOneWidget);
      verifyNever(() => bloc.add(any()));
    });

    testWidgets('сумма ноль: «должна быть больше нуля»', (tester) async {
      await openForm(tester);
      await typeTime(tester, 'field-start', '0900');
      await typeTime(tester, 'field-end', '0930');
      await tester.enterText(inField('field-amount'), '0');
      await tester.enterText(inField('field-commission'), '0');

      await save(tester);

      expect(find.text('Сумма должна быть больше нуля'), findsOneWidget);
      verifyNever(() => bloc.add(any()));
    });
  });

  group('отправка', () {
    Future<void> fillValidForm(WidgetTester tester) async {
      await typeTime(tester, 'field-start', '0900');
      await typeTime(tester, 'field-end', '0930');
      await tester.enterText(inField('field-amount'), '2400');
    }

    testWidgets('набор цифр превращается в «ЧЧ:ММ»', (tester) async {
      await openForm(tester);

      await fillValidForm(tester);

      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('09:30'), findsOneWidget);
    });

    testWidgets('циферблат: 09:00 для начала и 09:30 для окончания', (
      tester,
    ) async {
      await openForm(tester);

      await pickOnDial(tester, 'field-start');
      await pickOnDial(tester, 'field-end'); // полчаса после начала

      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('09:30'), findsOneWidget);
    });

    testWidgets('в диалоге нельзя набирать время с клавиатуры', (tester) async {
      await openForm(tester);

      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('field-start')),
          matching: find.byIcon(Icons.schedule_outlined),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_outlined), findsNothing);
    });

    testWidgets('корректная форма уходит в Bloc черновиком', (tester) async {
      await openForm(tester);
      await fillValidForm(tester);

      await save(tester);

      final drafts = sentDrafts();
      expect(drafts, hasLength(1));
      final draft = drafts.single;
      expect(draft.amount, 2400);
      expect(draft.commission, 360);
      expect(draft.payment, PaymentMethod.card);
      expect(draft.start.wallDate, initialDate);
      expect(draft.start.wallClock.hour, 9);
      expect(draft.end.wallClock.minute, 30);
      expect(find.text('Заполните поле'), findsNothing);
    });

    testWidgets('способ оплаты «Наличные» попадает в черновик', (tester) async {
      await openForm(tester);
      await fillValidForm(tester);
      await tester.tap(find.text('Наличные'));
      await tester.pump();

      await save(tester);

      expect(sentDrafts().single.payment, PaymentMethod.cash);
    });

    testWidgets('выбранная дата попадает в черновик', (tester) async {
      await openForm(tester);
      await fillValidForm(tester);
      await tester.tap(find.byKey(const Key('field-date')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pump();
      await tester.tap(find.text('ОК'));
      await tester.pumpAndSettle();
      expect(
        find.text(formatFullDate(DateTime(2026, 10, 10), 'ru')),
        findsOneWidget,
      );

      await save(tester);

      expect(sentDrafts().single.start.wallDate, DateTime(2026, 10, 10));
    });

    testWidgets('в календаре нельзя выбрать будущие дни', (tester) async {
      await openForm(tester);
      await tester.tap(find.byKey(const Key('field-date')));
      await tester.pumpAndSettle();
      // Ввод даты руками отключён: остаётся только календарь.
      expect(find.byIcon(Icons.edit_outlined), findsNothing);

      await tester.tap(find.text('13')); // завтра: день недоступен
      await tester.pump();
      await tester.tap(find.text('ОК'));
      await tester.pumpAndSettle();

      expect(
        find.text(formatFullDate(DateTime(2026, 10, 1), 'ru')),
        findsOneWidget,
      );
    });
  });

  group('поездка через полночь', () {
    testWidgets(
      'окончание раньше начала: подсказка и черновик на следующий день',
      (tester) async {
        await openForm(tester);

        await typeTime(tester, 'field-start', '2300');
        await typeTime(tester, 'field-end', '0030');
        await tester.enterText(inField('field-amount'), '800');

        expect(find.text('23:00'), findsOneWidget);
        expect(find.text('00:30'), findsOneWidget);
        expect(find.text('На следующий день'), findsOneWidget);

        await save(tester);

        expect(find.text('Окончание должно быть позже начала'), findsNothing);
        final draft = sentDrafts().single;
        expect(draft.start.wallDate, initialDate);
        expect(draft.end.wallDate, DateTime(2026, 10, 2));
        expect(draft.end.wallClock.hour, 0);
        expect(draft.end.wallClock.minute, 30);
      },
    );

    testWidgets('обычная поездка в пределах дня подсказки не показывает', (
      tester,
    ) async {
      await openForm(tester);

      await typeTime(tester, 'field-start', '0900');
      await typeTime(tester, 'field-end', '0930');

      expect(find.text('На следующий день'), findsNothing);
    });

    testWidgets('подсказка исчезает, когда окончание снова позже начала', (
      tester,
    ) async {
      await openForm(tester);
      await typeTime(tester, 'field-start', '2300');
      await typeTime(tester, 'field-end', '0030');
      expect(find.text('На следующий день'), findsOneWidget);

      await typeTime(tester, 'field-end', '2345');

      expect(find.text('На следующий день'), findsNothing);
    });

    testWidgets('одинаковое время — ошибка, а не поездка на сутки', (
      tester,
    ) async {
      await openForm(tester);
      await typeTime(tester, 'field-start', '0900');
      await typeTime(tester, 'field-end', '0900');
      await tester.enterText(inField('field-amount'), '800');

      await save(tester);

      expect(find.text('Окончание должно быть позже начала'), findsOneWidget);
      expect(find.text('На следующий день'), findsNothing);
      verifyNever(() => bloc.add(any()));
    });
  });

  group('строгий ввод (деньги и время)', () {
    String textOf(WidgetTester tester, String key) =>
        tester.widget<TextField>(inField(key)).controller!.text;

    testWidgets('в суммах нельзя набрать буквы', (tester) async {
      await openForm(tester);

      await tester.enterText(inField('field-amount'), 'abc');
      await tester.enterText(inField('field-commission'), 'x1');

      expect(textOf(tester, 'field-amount'), '');
      expect(textOf(tester, 'field-commission'), '');
    });

    testWidgets(
      'вставка суммы с копейками отклоняется, а не растёт в 100 раз',
      (tester) async {
        await openForm(tester);
        await tester.enterText(inField('field-amount'), '2400');

        await tester.enterText(inField('field-amount'), '2400,50');
        await tester.pump();
        expect(textOf(tester, 'field-amount'), '2400');

        await tester.enterText(inField('field-amount'), '2400.50');
        await tester.pump();
        expect(textOf(tester, 'field-amount'), '2400');
      },
    );

    testWidgets('отклонённая правка суммы не пересчитывает комиссию', (
      tester,
    ) async {
      await openForm(tester);
      await tester.enterText(inField('field-amount'), '2400');

      await tester.enterText(inField('field-amount'), '2400,50');
      await tester.pump();

      expect(textOf(tester, 'field-commission'), '360');
    });

    testWidgets('слишком длинная сумма отклоняется, а не обрезается', (
      tester,
    ) async {
      await openForm(tester);
      await tester.enterText(inField('field-amount'), '123456789');

      await tester.enterText(inField('field-amount'), '1234567890');
      await tester.pump();

      expect(textOf(tester, 'field-amount'), '123456789');
    });

    testWidgets('в полях времени нельзя набрать буквы и невозможное время', (
      tester,
    ) async {
      await openForm(tester);

      await tester.enterText(inField('field-start'), 'ab:cd');
      expect(textOf(tester, 'field-start'), '');

      await tester.enterText(inField('field-start'), '25:00');
      expect(textOf(tester, 'field-start'), '');

      await tester.enterText(inField('field-start'), '08:99');
      expect(textOf(tester, 'field-start'), '');
    });

    testWidgets('«930» превращается в «09:30»', (tester) async {
      await openForm(tester);

      await tester.enterText(inField('field-start'), '930');

      expect(textOf(tester, 'field-start'), '09:30');
    });

    testWidgets('неполное время («10:5») не проходит проверку и объясняется', (
      tester,
    ) async {
      await openForm(tester);
      await typeTime(tester, 'field-start', '0900');
      await typeTime(tester, 'field-end', '10:5');
      await tester.enterText(inField('field-amount'), '800');

      await save(tester);

      expect(
        find.text('Введите время как ЧЧ:ММ, например 08:30'),
        findsOneWidget,
      );
      verifyNever(() => bloc.add(any()));
    });
  });

  group('комиссия по умолчанию', () {
    testWidgets('считается от суммы и подписана как автоматическая', (
      tester,
    ) async {
      await openForm(tester);

      await tester.enterText(inField('field-amount'), '2400');
      await tester.pump();

      expect(
        tester.widget<TextField>(inField('field-commission')).controller!.text,
        '360',
      );
      expect(find.text('15% от суммы, можно изменить'), findsOneWidget);
    });

    testWidgets('пересчитывается при изменении суммы', (tester) async {
      await openForm(tester);

      await tester.enterText(inField('field-amount'), '2000');
      await tester.enterText(inField('field-amount'), '1000');
      await tester.pump();

      expect(
        tester.widget<TextField>(inField('field-commission')).controller!.text,
        '150',
      );
    });

    testWidgets('после ручной правки больше не перезаписывается', (
      tester,
    ) async {
      await openForm(tester);
      await tester.enterText(inField('field-amount'), '2400');
      await tester.enterText(inField('field-commission'), '100');
      await tester.pump();

      await tester.enterText(inField('field-amount'), '5000');
      await tester.pump();

      expect(
        tester.widget<TextField>(inField('field-commission')).controller!.text,
        '100',
      );
      expect(find.text('15% от суммы, можно изменить'), findsNothing);
    });

    testWidgets('очистка поля возвращает автоматический расчёт', (
      tester,
    ) async {
      await openForm(tester);
      await tester.enterText(inField('field-amount'), '2400');
      await tester.enterText(inField('field-commission'), '100');
      await tester.enterText(inField('field-commission'), '');

      await tester.enterText(inField('field-amount'), '1000');
      await tester.pump();

      expect(
        tester.widget<TextField>(inField('field-commission')).controller!.text,
        '150',
      );
    });

    testWidgets('сумма стёрта — комиссия очищается', (tester) async {
      await openForm(tester);
      await tester.enterText(inField('field-amount'), '2400');

      await tester.enterText(inField('field-amount'), '');
      await tester.pump();

      expect(
        tester.widget<TextField>(inField('field-commission')).controller!.text,
        '',
      );
    });
  });

  group('ответ Bloc', () {
    Future<void> emit(WidgetTester tester, AddTripState state) async {
      states.add(state);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('во время отправки кнопка показывает спиннер и не нажимается', (
      tester,
    ) async {
      await openForm(tester);

      await emit(tester, const AddTripState.submitting());

      final button = tester.widget<AppButton>(find.byKey(const Key('submit')));
      expect(button.isLoading, isTrue);
      expect(find.text('Сохранить'), findsNothing);
    });

    testWidgets('ошибка: форма остаётся, показывается SnackBar', (
      tester,
    ) async {
      await openForm(tester);

      await emit(tester, const AddTripState.failure(TripsError.noConnection));

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Нет связи с сервером'),
        ),
        findsOneWidget,
      );
      expect(find.text('Новая поездка'), findsOneWidget);
    });

    testWidgets('успех: форма закрывается и возвращает сохранённую поездку', (
      tester,
    ) async {
      await openForm(tester);
      final trip = makeTrip(id: 'saved');

      states.add(AddTripState.success(trip));
      await tester.pumpAndSettle();

      expect(find.text('Новая поездка'), findsNothing);
      expect(find.text('open'), findsOneWidget);
      expect(poppedTrip, trip);
    });
  });
}
