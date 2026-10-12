import 'package:flutter/animation.dart';

/// Общие длительности и кривые, чтобы движение было одинаковым на всех экранах.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration base = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);

  /// Для изменения размера и перекрёстных переходов.
  static const Curve standard = Curves.easeInOutCubic;

  /// Для появления: быстрый старт и плавная остановка.
  static const Curve emphasized = Curves.easeOutCubic;

  /// Шаг между элементами каскадного появления.
  static const Duration stagger = Duration(milliseconds: 55);
}
