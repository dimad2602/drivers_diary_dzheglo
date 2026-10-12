import 'package:driver_diary/app/theme/app_motion.dart';
import 'package:flutter/animation.dart';

/// Значения по умолчанию для виджетов анимации. Источник правды — [AppMotion],
/// здесь только те из них, которые нужны этим виджетам.
abstract final class AnimationConstants {
  static const Duration duration = AppMotion.base;
  static const Duration durationFast = AppMotion.fast;
  static const Duration durationSlow = AppMotion.slow;

  /// easeOutCubic — для появления (быстрый старт, мягкая остановка).
  static const Curve curve = AppMotion.emphasized;

  /// Начальный вертикальный сдвиг при появлении, в пикселях.
  static const double slideOffset = 18;

  static const Duration staggerDelay = AppMotion.stagger;
}
