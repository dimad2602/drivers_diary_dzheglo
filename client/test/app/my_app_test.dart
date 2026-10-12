import 'package:driver_diary/app/di/locator.dart';
import 'package:driver_diary/app/my_app.dart';
import 'package:driver_diary/app/theme/app_colors.dart';
import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/domain/models/day_diary.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/domain/repositories/i_trips_repo.dart';
import 'package:driver_diary/shared/models/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';

/// Оболочка приложения целиком: DI, роутер, тема и язык. Репозиторий подменён,
/// всё остальное — настоящее.
class _FakeTripsRepo implements ITripsRepo {
  @override
  Future<Result<DayDiary, TripsError>> getDay(DateTime date) async =>
      Success(makeDiary());

  @override
  Future<Result<Trip, TripsError>> addTrip(Trip trip) async => Success(trip);
}

void main() {
  Future<void> startApp(
    WidgetTester tester, {
    Map<String, Object> savedSettings = const {},
    Locale systemLocale = const Locale('ru'),
  }) async {
    SharedPreferences.setMockInitialValues(savedSettings);
    await locator.reset();
    await setupLocator();
    locator
      ..allowReassignment = true
      ..registerSingleton<ITripsRepo>(_FakeTripsRepo());
    addTearDown(locator.reset);

    tester.view.physicalSize = const Size(600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.localesTestValue = [systemLocale];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  ThemeMode themeMode(WidgetTester tester) =>
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;

  Future<String?> savedSetting(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
  }

  group('язык интерфейса', () {
    testWidgets('по умолчанию следует языку системы: русский', (tester) async {
      await startApp(tester);

      expect(find.text('Дневник водителя'), findsOneWidget);
      expect(find.text('На руки'), findsOneWidget);
    });

    testWidgets('английский язык системы', (tester) async {
      await startApp(tester, systemLocale: const Locale('en'));

      expect(find.text('Driver Diary'), findsOneWidget);
      expect(find.text('Take-home'), findsOneWidget);
    });

    testWidgets('неподдерживаемый язык системы — английский', (tester) async {
      await startApp(tester, systemLocale: const Locale('zh'));

      expect(find.text('Take-home'), findsOneWidget);
    });

    testWidgets('сохранённый язык важнее языка системы', (tester) async {
      await startApp(
        tester,
        savedSettings: {'language': 'en'},
        systemLocale: const Locale('ru'),
      );

      expect(find.text('Take-home'), findsOneWidget);
      expect(find.text('На руки'), findsNothing);
    });

    testWidgets('смена языка в настройках применяется сразу и сохраняется', (
      tester,
    ) async {
      await startApp(tester);
      await openSettings(tester);
      expect(find.text('Настройки'), findsOneWidget);

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(await savedSetting('language'), 'en');

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Take-home'), findsOneWidget);
    });
  });

  group('тема', () {
    testWidgets('по умолчанию — системная', (tester) async {
      await startApp(tester);

      expect(themeMode(tester), ThemeMode.system);
    });

    testWidgets('сохранённая тема применяется при запуске', (tester) async {
      await startApp(tester, savedSettings: {'theme_mode': 'dark'});

      expect(themeMode(tester), ThemeMode.dark);
    });

    testWidgets('выбор тёмной темы меняет оформление и сохраняется', (
      tester,
    ) async {
      await startApp(tester);
      await openSettings(tester);

      await tester.tap(find.text('Тёмная'));
      await tester.pumpAndSettle();

      expect(themeMode(tester), ThemeMode.dark);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(
        scaffold.backgroundColor ??
            Theme.of(tester.element(find.byType(Scaffold).first))
                .scaffoldBackgroundColor,
        AppColors.dark.backgroundGrouped,
      );
      expect(await savedSetting('theme_mode'), 'dark');
    });

    testWidgets('возврат на светлую тему', (tester) async {
      await startApp(tester, savedSettings: {'theme_mode': 'dark'});
      await openSettings(tester);

      await tester.tap(find.text('Светлая'));
      await tester.pumpAndSettle();

      expect(themeMode(tester), ThemeMode.light);
      expect(await savedSetting('theme_mode'), 'light');
    });
  });

  group('навигация', () {
    testWidgets('стартовый экран — дневник за сегодня', (tester) async {
      await startApp(tester);

      expect(find.text('Сегодня'), findsOneWidget);
      expect(find.text('Добавить поездку'), findsOneWidget);
    });

    testWidgets(
      'кнопка «Добавить поездку» открывает форму, «назад» возвращает',
      (tester) async {
        await startApp(tester);

        await tester.tap(find.text('Добавить поездку'));
        await tester.pumpAndSettle();
        expect(find.text('Новая поездка'), findsOneWidget);

        // pageBack ищет кнопку по английскому тултипу, а здесь интерфейс русский.
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.text('Дневник водителя'), findsOneWidget);
      },
    );

    testWidgets('сохранение поездки возвращает в дневник с подтверждением', (
      tester,
    ) async {
      await startApp(tester);
      await tester.tap(find.text('Добавить поездку'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('field-start')),
          matching: find.byType(TextField),
        ),
        '0900',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('field-end')),
          matching: find.byType(TextField),
        ),
        '0930',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('field-amount')),
          matching: find.byType(TextField),
        ),
        '2400',
      );
      await tester.ensureVisible(find.byKey(const Key('submit')));
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pumpAndSettle();

      expect(find.text('Дневник водителя'), findsOneWidget);
      expect(find.text('Поездка добавлена'), findsOneWidget);
    });
  });
}
