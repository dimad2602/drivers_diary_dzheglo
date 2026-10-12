import 'package:driver_diary/domain/errors/trips_error.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/common/trips_error_ui.dart';
import 'package:driver_diary/shared/ui/app_status_view.dart';
import 'package:flutter/material.dart';

class DiaryError extends StatelessWidget {
  const DiaryError({required this.error, required this.onRetry, super.key});

  final TripsError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return AppStatusView(
      isError: true,
      icon: error.icon,
      title: error.title(l10n),
      message: error.message(l10n),
      actionLabel: l10n.actionRetry,
      onAction: onRetry,
    );
  }
}
