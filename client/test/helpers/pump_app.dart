import 'package:driver_diary/app/theme/app_theme.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Запускает [child] внутри MaterialApp с темой и локализацией приложения.
///
/// [settle] = false нужен, когда на экране бесконечная анимация (спиннер) —
/// иначе `pumpAndSettle` не дождётся конца.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('ru'),
  ThemeMode themeMode = ThemeMode.light,
  bool scaffold = true,
  bool settle = true,
  Size size = const Size(600, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
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
