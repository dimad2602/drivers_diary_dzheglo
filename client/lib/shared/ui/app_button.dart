import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/shared/ui/app_spinner.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, destructive }

/// Кнопка-«таблетка» высотой 52: акцентная, вторичная (серая заливка) или деструктивная.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expanded = false,
    super.key,
  });

  final String label;

  /// `null` отключает кнопку.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Показывает спиннер вместо подписи и блокирует нажатие.
  final bool isLoading;

  /// Растягивает кнопку на всю доступную ширину.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (variant) {
      AppButtonVariant.primary => (colors.accent, colors.onAccent),
      AppButtonVariant.secondary => (colors.fillTertiary, colors.labelPrimary),
      AppButtonVariant.destructive => (colors.negativeSoft, colors.negative),
    };
    final enabled = onPressed != null && !isLoading;

    final child = isLoading
        ? AppSpinner(size: 20, color: foreground)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: foreground,
                  ),
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: onPressed == null ? 0.4 : 1,
        child: Material(
          color: background,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            highlightColor: Colors.black.withValues(alpha: 0.12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 52,
                minWidth: expanded ? double.infinity : 0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(widthFactor: 1, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
