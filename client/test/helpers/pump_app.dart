import 'package:driver_diary/app/theme/app_theme.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// То же, что [pumpApp], но через `MaterialApp.router`: для экранов, которые
/// пользуются go_router (`context.push` / `context.pop`).
Future<void> pumpRouterApp(
  WidgetTester tester,
  GoRouter router, {
  Locale locale = const Locale('ru'),
  Size size = const Size(600, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    ),
  );
  await tester.pumpAndSettle();
}

/// Запускает [child] внутри MaterialApp с темой и локализацией приложения.
///
/// [settle] = false нужен, когда на экране бесконечная анимация (спиннер) —
/// иначе `pumpAndSettle` не дождётся конца. [reducedMotion] включает системный
/// режим «убрать анимации».
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('ru'),
  ThemeMode themeMode = ThemeMode.light,
  bool scaffold = true,
  bool settle = true,
  bool reducedMotion = false,
  Size size = const Size(600, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      builder: reducedMotion
          ? (context, app) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: app!,
            )
          : null,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: scaffold ? Scaffold(body: child) : child,
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
