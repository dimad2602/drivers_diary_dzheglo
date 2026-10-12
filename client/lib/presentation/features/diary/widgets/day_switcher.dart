import 'package:driver_diary/app/theme/app_motion.dart';
import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/ui/app_card_section.dart';
import 'package:driver_diary/shared/utils/date_formatter.dart';
import 'package:driver_diary/shared/utils/format_context.dart';
import 'package:flutter/material.dart';

/// Переключатель дня: стрелки «вчера/завтра» и дата по центру (по нажатию — календарь).
class DaySwitcher extends StatelessWidget {
  const DaySwitcher({
    required this.date,
    required this.today,
    required this.onPrevious,
    required this.onNext,
    required this.onPickDate,
    super.key,
  });

  final DateTime date;
  final DateTime today;
  final VoidCallback onPrevious;

  /// `null`, если дальше листать нельзя (выбран сегодняшний день).
  final VoidCallback? onNext;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colors = context.colors;
    final text = context.textTheme;

    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(kCardRadius),
      child: ColoredBox(
        color: colors.backgroundCard,
        child: Row(
          children: [
            IconButton(
              tooltip: l10n.dayPrevious,
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              iconSize: 28,
            ),
            Expanded(
              child: Tooltip(
                message: l10n.dayPick,
                child: InkWell(
                  onTap: onPickDate,
                  highlightColor: colors.fillSecondary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedSwitcher(
                      duration: AppMotion.fast,
                      child: Column(
                        key: ValueKey(date),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_title(context, l10n), style: text.titleMedium),
                          Text(
                            context.fullDate(date),
                            style: text.bodySmall?.copyWith(
                              color: colors.labelSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.dayNext,
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context, S l10n) {
    if (isSameDay(date, today)) return l10n.dayToday;
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    if (isSameDay(date, yesterday)) return l10n.dayYesterday;
    return context.weekday(date);
  }
}
