import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/domain/models/day_summary.dart';
import 'package:driver_diary/domain/models/payment_breakdown.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/common/payment_method_ui.dart';
import 'package:driver_diary/presentation/features/diary/widgets/payment_split_bar.dart';
import 'package:driver_diary/shared/ui/animations/animations.dart';
import 'package:driver_diary/shared/ui/app_card_section.dart';
import 'package:driver_diary/shared/utils/format_context.dart';
import 'package:flutter/material.dart';

/// Сводка за день: сколько «на руки», выручка, комиссия и разбивка по способу оплаты.
class SummaryCard extends StatelessWidget {
  const SummaryCard({required this.summary, super.key});

  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colors = context.colors;
    final text = context.textTheme;

    return AppCardSection(
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.diaryNetLabel,
              style: text.bodySmall?.copyWith(color: colors.labelSecondary),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: AnimatedCount(
                value: summary.net,
                builder: (context, value) => Text(
                  context.money(value),
                  key: const Key('summary-net'),
                  style: text.displayLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _MetricRow(
              label: l10n.diaryRevenue,
              value: context.money(summary.revenue),
            ),
            _MetricRow(
              label: l10n.diaryCommission,
              value: context.money(-summary.commission),
              valueColor: summary.commission > 0 ? colors.negative : null,
            ),
            _MetricRow(
              label: l10n.diaryTripsCount,
              value: '${summary.tripsCount}',
            ),
            const SizedBox(height: 20),
            Text(
              l10n.diaryByPayment,
              style: text.titleSmall?.copyWith(color: colors.labelSecondary),
            ),
            const SizedBox(height: 10),
            PaymentSplitBar(
              cashRevenue: summary.cash.revenue,
              cardRevenue: summary.card.revenue,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PaymentLegend(
                    method: PaymentMethod.cash,
                    breakdown: summary.cash,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PaymentLegend(
                    method: PaymentMethod.card,
                    breakdown: summary.card,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final text = context.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: text.bodyMedium?.copyWith(
              color: context.colors.labelSecondary,
            ),
          ),
          Text(value, style: text.titleSmall?.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

class _PaymentLegend extends StatelessWidget {
  const _PaymentLegend({required this.method, required this.breakdown});

  final PaymentMethod method;
  final PaymentBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: method.color(colors),
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: 8),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method.label(S.of(context)),
                style: text.bodySmall?.copyWith(color: colors.labelSecondary),
              ),
              Text(context.money(breakdown.revenue), style: text.titleSmall),
              Text(
                S.of(context).tripsCountLabel(breakdown.tripsCount),
                key: Key('legend-count-${method.name}'),
                style: text.bodySmall?.copyWith(color: colors.labelSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
