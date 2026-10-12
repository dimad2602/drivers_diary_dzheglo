import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:flutter/material.dart';

const double kFieldHeight = 52;
const double kFieldRadius = 16;

/// Подпись над полем и текст ошибки/подсказки под ним — общая «рамка» полей формы.
class AppFieldFrame extends StatelessWidget {
  const AppFieldFrame({
    required this.label,
    required this.child,
    this.errorText,
    this.helperText,
    super.key,
  });

  final String label;
  final Widget child;

  /// Ошибка (красным) имеет приоритет над [helperText].
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;
    final note = errorText ?? helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: text.bodySmall?.copyWith(color: colors.labelSecondary),
          ),
        ),
        child,
        if (note != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Text(
              note,
              key: errorText != null ? const Key('field-error') : null,
              style: text.bodySmall?.copyWith(
                color: errorText != null
                    ? colors.negative
                    : colors.labelSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Заливка и кольцо вокруг поля: акцентное в фокусе, красное при ошибке.
BoxDecoration fieldDecoration(
  BuildContext context, {
  bool hasError = false,
  bool focused = false,
}) {
  final colors = context.colors;
  final ring = hasError ? colors.negative : (focused ? colors.accent : null);
  return BoxDecoration(
    color: colors.fillTertiary,
    borderRadius: BorderRadius.circular(kFieldRadius),
    border: ring == null ? null : Border.all(color: ring, width: 2),
  );
}
