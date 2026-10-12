import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/app/routes/app_routes.dart';
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
  final day = DateTime(2026, 10, 12);

  late _MockDiaryBloc bloc;

  /// Дневник + заглушка экрана настроек с кнопкой «Назад».
  Future<void> openDiary(WidgetTester tester, DiaryState state) async {
    when(() => bloc.today).thenReturn(day);
    when(() => bloc.canGoNext).thenReturn(false);
    whenListen(bloc, const Stream<DiaryState>.empty(), initialState: state);
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
          path: AppRoutes.settings,
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.pop(),
              child: const Text('settings-back'),
            ),
          ),
        ),
      ],
    );
    await pumpRouterApp(tester, router);
  }

  setUpAll(() async {
    registerFallbackValue(const DiaryEvent.started());
    await initializeDateFormatting('ru');
  });

  setUp(() => bloc = _MockDiaryBloc());

  testWidgets('значок настроек в шапке открывает экран настроек', (
    tester,
  ) async {
    await openDiary(tester, DiaryState.success(date: day, diary: makeDiary()));

    await tester.tap(find.byTooltip('Настройки'));
    await tester.pumpAndSettle();

    expect(find.text('settings-back'), findsOneWidget);
  });

  testWidgets('возврат из настроек ничего не перезагружает', (tester) async {
    await openDiary(tester, DiaryState.success(date: day, diary: makeDiary()));
    await tester.tap(find.byTooltip('Настройки'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('settings-back'));
    await tester.pumpAndSettle();

    verifyNever(() => bloc.add(any()));
  });
}
