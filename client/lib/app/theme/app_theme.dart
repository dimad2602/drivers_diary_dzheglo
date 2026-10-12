import 'package:driver_diary/app/theme/app_colors.dart';
import 'package:driver_diary/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    // Остальные роли ColorScheme генерируются из акцента, ключевые перекрываем нашими.
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.accent,
          brightness: brightness,
        ).copyWith(
          primary: c.accent,
          onPrimary: c.onAccent,
          surface: c.backgroundCard,
          onSurface: c.labelPrimary,
          onSurfaceVariant: c.labelSecondary,
          error: c.negative,
          outline: c.separatorOpaque,
          outlineVariant: c.separator,
        );
    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: c.labelPrimary,
      displayColor: c.labelPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.backgroundGrouped,
      textTheme: textTheme,
      extensions: [c],
      dividerColor: c.separator,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: c.backgroundGrouped,
        foregroundColor: c.labelPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.backgroundCard,
        surfaceTintColor: Colors.transparent,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.backgroundCard,
        surfaceTintColor: Colors.transparent,
      ),
      timePickerTheme: TimePickerThemeData(backgroundColor: c.backgroundCard),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        shape: const StadiumBorder(),
        extendedTextStyle: textTheme.labelLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.labelPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: c.background),
      ),
    );
  }
}
