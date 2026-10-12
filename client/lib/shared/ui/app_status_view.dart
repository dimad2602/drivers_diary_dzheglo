import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/shared/ui/app_button.dart';
import 'package:flutter/material.dart';

/// Пустое состояние или ошибка: значок, заголовок, пояснение и необязательные кнопки.
class AppStatusView extends StatelessWidget {
  const AppStatusView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isError = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  /// Окрашивает значок как ошибку.
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isError ? colors.negativeSoft : colors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: isError ? colors.negative : colors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: text.titleLarge, textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(
              message!,
              style: text.bodyMedium?.copyWith(color: colors.labelSecondary),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            AppButton(label: actionLabel!, onPressed: onAction),
          ],
          if (secondaryActionLabel != null && onSecondaryAction != null) ...[
            const SizedBox(height: 8),
            AppButton(
              label: secondaryActionLabel!,
              onPressed: onSecondaryAction,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
