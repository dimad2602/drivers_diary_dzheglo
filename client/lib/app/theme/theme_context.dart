import 'package:driver_diary/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
