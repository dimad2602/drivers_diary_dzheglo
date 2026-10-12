import 'package:bloc_test/bloc_test.dart';
import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/app/theme/cubit/locale_cubit.dart';
import 'package:driver_diary/app/theme/cubit/theme_cubit.dart';
import 'package:driver_diary/presentation/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

class _MockLocaleCubit extends MockCubit<AppLanguage> implements LocaleCubit {}

void main() {
  late _MockThemeCubit theme;
  late _MockLocaleCubit locale;

  Future<void> pumpSettings(
    WidgetTester tester, {
    ThemeMode themeMode = ThemeMode.system,
    AppLanguage language = AppLanguage.system,
    Locale uiLocale = const Locale('ru'),
  }) async {
    whenListen(theme, const Stream<ThemeMode>.empty(), initialState: themeMode);
    whenListen(
      locale,
      const Stream<AppLanguage>.empty(),
      initialState: language,
    );

    await pumpApp(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: theme),
          BlocProvider<LocaleCubit>.value(value: locale),
        ],
        child: const SettingsPage(),
      ),
      scaffold: false,
      locale: uiLocale,
    );
  }

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(AppLanguage.system);
  });

  setUp(() {
    theme = _MockThemeCubit();
    locale = _MockLocaleCubit();
    when(() => theme.setThemeMode(any())).thenAnswer((_) async {});
    when(() => locale.setLanguage(any())).thenAnswer((_) async {});
  });

  testWidgets('показывает заголовки, варианты темы и языка', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Внешний вид'), findsOneWidget);
    expect(find.text('Тема'), findsOneWidget);
    expect(find.text('Светлая'), findsOneWidget);
    expect(find.text('Тёмная'), findsOneWidget);
    expect(find.text('Язык'), findsOneWidget);
    expect(find.text('Русский'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Как в системе'), findsNWidgets(2));
  });

  testWidgets('выбор темы вызывает setThemeMode', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('Тёмная'));
    await tester.tap(find.text('Светлая'));

    verify(() => theme.setThemeMode(ThemeMode.dark)).called(1);
    verify(() => theme.setThemeMode(ThemeMode.light)).called(1);
  });

  testWidgets('выбор языка вызывает setLanguage', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('English'));
    await tester.tap(find.text('Русский'));

    verify(() => locale.setLanguage(AppLanguage.en)).called(1);
    verify(() => locale.setLanguage(AppLanguage.ru)).called(1);
  });

  testWidgets('выбранные значения отражаются в переключателях', (tester) async {
    await pumpSettings(
      tester,
      themeMode: ThemeMode.dark,
      language: AppLanguage.en,
    );

    // «Тёмная» и «English» — выбранные сегменты, у остальных ползунка нет.
    expect(find.byKey(const Key('segment-thumb')), findsNWidgets(2));
  });

  testWidgets('на английском все подписи переведены', (tester) async {
    await pumpSettings(tester, uiLocale: const Locale('en'));

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    // Названия языков не переводятся.
    expect(find.text('Русский'), findsOneWidget);
  });

  testWidgets('настройки ключа или сервера на экране отсутствуют', (
    tester,
  ) async {
    await pumpSettings(tester);

    expect(find.byType(TextField), findsNothing);
    expect(find.text('API-ключ'), findsNothing);
  });
}
