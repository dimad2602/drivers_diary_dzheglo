import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/ui/app_status_view.dart';
import 'package:flutter/material.dart';

class DiaryEmpty extends StatelessWidget {
  const DiaryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return AppStatusView(
      icon: Icons.local_taxi_outlined,
      title: l10n.diaryEmptyTitle,
      message: l10n.diaryEmptyMessage,
    );
  }
}
