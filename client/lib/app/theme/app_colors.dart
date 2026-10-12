import 'package:flutter/material.dart';

/// Цветовые токены приложения в стиле iOS-палитры (как в fusion-ui):
/// полупрозрачные подписи и заливки, карточки без теней.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelQuaternary,
    required this.fillPrimary,
    required this.fillSecondary,
    required this.fillTertiary,
    required this.background,
    required this.backgroundGrouped,
    required this.backgroundCard,
    required this.separator,
    required this.separatorOpaque,
    required this.segmentedThumb,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.positive,
    required this.positiveSoft,
    required this.negative,
    required this.negativeSoft,
    required this.warning,
  });

  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color labelQuaternary;

  /// Дорожка segmented-контрола.
  final Color fillPrimary;

  /// Нажатое состояние.
  final Color fillSecondary;

  /// Поле ввода, вторичная кнопка.
  final Color fillTertiary;

  final Color background;

  /// Фон страницы под карточками.
  final Color backgroundGrouped;
  final Color backgroundCard;
  final Color separator;
  final Color separatorOpaque;
  final Color segmentedThumb;

  final Color accent;
  final Color onAccent;
  final Color accentSoft;

  final Color positive;
  final Color positiveSoft;
  final Color negative;
  final Color negativeSoft;
  final Color warning;

  static const light = AppColors(
    labelPrimary: Color(0xFF000000),
    labelSecondary: Color(0x993C3C43),
    labelTertiary: Color(0x4D3C3C43),
    labelQuaternary: Color(0x2E3C3C43),
    fillPrimary: Color(0x33787880),
    fillSecondary: Color(0x29787880),
    fillTertiary: Color(0x1F767680),
    background: Color(0xFFFFFFFF),
    backgroundGrouped: Color(0xFFF2F2F7),
    backgroundCard: Color(0xFFFFFFFF),
    separator: Color(0x1F000000),
    separatorOpaque: Color(0xFFC6C6C8),
    segmentedThumb: Color(0xFFFFFFFF),
    accent: Color(0xFF8060FF),
    onAccent: Color(0xFFFFFFFF),
    accentSoft: Color(0x1F8060FF),
    positive: Color(0xFF34C759),
    positiveSoft: Color(0x1F34C759),
    negative: Color(0xFFFF3B30),
    negativeSoft: Color(0x1FFF3B30),
    warning: Color(0xFFFFCC00),
  );

  static const dark = AppColors(
    labelPrimary: Color(0xFFFFFFFF),
    labelSecondary: Color(0xB3EBEBF5),
    labelTertiary: Color(0x4DEBEBF5),
    labelQuaternary: Color(0x29EBEBF5),
    fillPrimary: Color(0x5C787880),
    fillSecondary: Color(0x52787880),
    fillTertiary: Color(0x3D767680),
    background: Color(0xFF000000),
    backgroundGrouped: Color(0xFF000000),
    backgroundCard: Color(0xFF1C1C1E),
    separator: Color(0x2BFFFFFF),
    separatorOpaque: Color(0xFF38383A),
    segmentedThumb: Color(0xFF636366),
    accent: Color(0xFF8253FF),
    onAccent: Color(0xFFFFFFFF),
    accentSoft: Color(0x338253FF),
    positive: Color(0xFF30D158),
    positiveSoft: Color(0x2930D158),
    negative: Color(0xFFFF453A),
    negativeSoft: Color(0x29FF453A),
    warning: Color(0xFFFFD60A),
  );

  @override
  AppColors copyWith({
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? labelQuaternary,
    Color? fillPrimary,
    Color? fillSecondary,
    Color? fillTertiary,
    Color? background,
    Color? backgroundGrouped,
    Color? backgroundCard,
    Color? separator,
    Color? separatorOpaque,
    Color? segmentedThumb,
    Color? accent,
    Color? onAccent,
    Color? accentSoft,
    Color? positive,
    Color? positiveSoft,
    Color? negative,
    Color? negativeSoft,
    Color? warning,
  }) {
    return AppColors(
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      labelQuaternary: labelQuaternary ?? this.labelQuaternary,
      fillPrimary: fillPrimary ?? this.fillPrimary,
      fillSecondary: fillSecondary ?? this.fillSecondary,
      fillTertiary: fillTertiary ?? this.fillTertiary,
      background: background ?? this.background,
      backgroundGrouped: backgroundGrouped ?? this.backgroundGrouped,
      backgroundCard: backgroundCard ?? this.backgroundCard,
      separator: separator ?? this.separator,
      separatorOpaque: separatorOpaque ?? this.separatorOpaque,
      segmentedThumb: segmentedThumb ?? this.segmentedThumb,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentSoft: accentSoft ?? this.accentSoft,
      positive: positive ?? this.positive,
      positiveSoft: positiveSoft ?? this.positiveSoft,
      negative: negative ?? this.negative,
      negativeSoft: negativeSoft ?? this.negativeSoft,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      labelPrimary: mix(labelPrimary, other.labelPrimary),
      labelSecondary: mix(labelSecondary, other.labelSecondary),
      labelTertiary: mix(labelTertiary, other.labelTertiary),
      labelQuaternary: mix(labelQuaternary, other.labelQuaternary),
      fillPrimary: mix(fillPrimary, other.fillPrimary),
      fillSecondary: mix(fillSecondary, other.fillSecondary),
      fillTertiary: mix(fillTertiary, other.fillTertiary),
      background: mix(background, other.background),
      backgroundGrouped: mix(backgroundGrouped, other.backgroundGrouped),
      backgroundCard: mix(backgroundCard, other.backgroundCard),
      separator: mix(separator, other.separator),
      separatorOpaque: mix(separatorOpaque, other.separatorOpaque),
      segmentedThumb: mix(segmentedThumb, other.segmentedThumb),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      accentSoft: mix(accentSoft, other.accentSoft),
      positive: mix(positive, other.positive),
      positiveSoft: mix(positiveSoft, other.positiveSoft),
      negative: mix(negative, other.negative),
      negativeSoft: mix(negativeSoft, other.negativeSoft),
      warning: mix(warning, other.warning),
    );
  }
}
