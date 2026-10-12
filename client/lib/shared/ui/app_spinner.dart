import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:flutter/material.dart';

class AppSpinner extends StatelessWidget {
  const AppSpinner({this.size = 28, this.color, super.key});

  final double size;

  /// По умолчанию — акцентный цвет темы.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? context.colors.accent,
      ),
    );
  }
}
