import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/shared/ui/app_field_frame.dart';
import 'package:flutter/material.dart';

/// Поле, которое не вводится руками, а открывает выбор (дата, время).
/// Выглядит как [AppTextField]; без [value] показывает [placeholder].
class AppPickerField extends StatelessWidget {
  const AppPickerField({
    required this.label,
    required this.onTap,
    this.value,
    this.placeholder,
    this.icon,
    this.errorText,
    this.helperText,
    super.key,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final IconData? icon;
  final String? errorText;
  final String? helperText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;
    final hasValue = value != null;

    return AppFieldFrame(
      label: label,
      errorText: errorText,
      helperText: helperText,
      child: Semantics(
        button: true,
        label: label,
        value: value ?? placeholder,
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: fieldDecoration(context, hasError: errorText != null),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(kFieldRadius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              highlightColor: colors.fillSecondary,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: kFieldHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: colors.labelSecondary),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          value ?? placeholder ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodyLarge?.copyWith(
                            color: hasValue
                                ? colors.labelPrimary
                                : colors.labelTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
