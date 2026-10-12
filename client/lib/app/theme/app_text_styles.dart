import 'package:flutter/material.dart';

/// Типографика в духе iOS: размеры и трекинг из fusion-ui. Шрифт — системный.
abstract final class AppTextStyles {
  static const _largeTitle = TextStyle(
    fontSize: 34,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.53,
  );
  static const _title1 = TextStyle(
    fontSize: 28,
    height: 1.29,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.2,
  );
  static const _title2 = TextStyle(
    fontSize: 22,
    height: 1.36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.05,
  );
  static const _title3 = TextStyle(
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.68,
  );
  static const _headline = TextStyle(
    fontSize: 17,
    height: 1.29,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.385,
  );
  static const _body = TextStyle(
    fontSize: 17,
    height: 1.29,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.385,
  );
  static const _callout = TextStyle(
    fontSize: 15,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.235,
  );
  static const _calloutMedium = TextStyle(
    fontSize: 15,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.235,
  );
  static const _footnote = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.047,
  );
  static const _footnoteMedium = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.047,
  );
  static const _caption = TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
  );

  /// Соответствие ролей Material ролям iOS:
  /// display* — крупные числа, headline/title — заголовки, body — текст,
  /// label — подписи кнопок и мелкие метки.
  static const TextTheme textTheme = TextTheme(
    displayLarge: _largeTitle,
    displayMedium: _title1,
    displaySmall: _title2,
    headlineMedium: _title2,
    headlineSmall: _title3,
    titleLarge: _title3,
    titleMedium: _headline,
    titleSmall: _calloutMedium,
    bodyLarge: _body,
    bodyMedium: _callout,
    bodySmall: _footnote,
    labelLarge: _headline,
    labelMedium: _footnoteMedium,
    labelSmall: _caption,
  );
}
