import 'package:driver_diary/app/theme/app_colors.dart';
import 'package:driver_diary/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('светлая и тёмная темы несут свою палитру', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(light.extension<AppColors>(), AppColors.light);
      expect(dark.extension<AppColors>(), AppColors.dark);
    });

    test('фон страницы и акцент берутся из токенов', () {
      final dark = AppTheme.dark();

      expect(dark.scaffoldBackgroundColor, AppColors.dark.backgroundGrouped);
      expect(dark.colorScheme.primary, AppColors.dark.accent);
    });
  });

  group('AppColors', () {
    test('lerp на краях возвращает исходные палитры', () {
      expect(
        AppColors.light.lerp(AppColors.dark, 0).accent,
        AppColors.light.accent,
      );
      expect(
        AppColors.light.lerp(AppColors.dark, 1).accent,
        AppColors.dark.accent,
      );
    });

    test('lerp с чужим типом возвращает текущую палитру', () {
      expect(AppColors.light.lerp(null, 0.5), AppColors.light);
    });

    test('copyWith подменяет только указанное поле', () {
      final changed = AppColors.light.copyWith(accent: Colors.red);

      expect(changed.accent, Colors.red);
      expect(changed.positive, AppColors.light.positive);
    });
  });
}
