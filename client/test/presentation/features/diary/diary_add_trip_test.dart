import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/app/routes/app_routes.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/presentation/bloc/diary/diary_bloc.dart';
import 'package:driver_diary/presentation/features/diary/diary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/pump_app.dart';

class _MockDiaryBloc extends MockBloc<DiaryEvent, DiaryState>
    implements DiaryBloc {}

void main() {
  final selectedDay = DateTime(2026, 10, 1);

  late _MockDiaryBloc bloc;
  Object? receivedExtra;

  /// Дневник + заглушка формы: кнопки «Сохранить» и «Назад» закрывают её
  /// с результатом / без результата.
  Future<void> openDiary(WidgetTester tester, {required Trip savedTrip}) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: AppRoutes.diary,
          builder: (context, state) => BlocProvider<DiaryBloc>.value(
            value: bloc,
            child: const DiaryView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addTrip,
          builder: (context, state) {
            receivedExtra = state.extra;
            return Scaffold(
              body: Column(
                children: [
                  TextButton(
                    onPressed: () => context.pop(savedTrip),
                    child: const Text('form-save'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('form-back'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
    await pumpRouterApp(tester, router);
  }

  setUpAll(() async {
    registerFallbackValue(const DiaryEvent.started());
    await initializeDateFormatting('ru');
  });

  setUp(() {
    bloc = _MockDiaryBloc();
    receivedExtra = null;
    when(() => bloc.today).thenReturn(DateTime(2026, 10, 12));
    when(() => bloc.canGoNext).thenReturn(true);
    whenListen(
      bloc,
      const Stream<DiaryState>.empty(),
      initialState: DiaryState.success(date: selectedDay, diary: makeDiary()),
    );
  });

  testWidgets('кнопка «Добавить поездку» открывает форму с выбранным днём', (
    tester,
  ) async {
    await openDiary(tester, savedTrip: makeTrip());

    expect(find.text('Добавить поездку'), findsOneWidget);
    await tester.tap(find.text('Добавить поездку'));
    await tester.pumpAndSettle();

    expect(find.text('form-save'), findsOneWidget);
    expect(receivedExtra, selectedDay);
  });

  testWidgets(
    'после сохранения открывается день новой поездки и появляется подтверждение',
    (tester) async {
      await openDiary(
        tester,
        savedTrip: makeTrip(start: at(5, 10, 0), end: at(5, 10, 30)),
      );
      await tester.tap(find.text('Добавить поездку'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('form-save'));
      await tester.pumpAndSettle();

      verify(() => bloc.add(DiaryEvent.dateSelected(DateTime(2026, 10, 5))))
          .called(1);
      expect(find.text('Поездка добавлена'), findsOneWidget);
    },
  );

  testWidgets('возврат из формы без сохранения ничего не меняет', (
    tester,
  ) async {
    await openDiary(tester, savedTrip: makeTrip());
    await tester.tap(find.text('Добавить поездку'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('form-back'));
    await tester.pumpAndSettle();

    verifyNever(() => bloc.add(any()));
    expect(find.text('Поездка добавлена'), findsNothing);
  });
}
