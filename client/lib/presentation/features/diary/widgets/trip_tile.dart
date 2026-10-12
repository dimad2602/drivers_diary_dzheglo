import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/domain/models/trip.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/common/payment_method_ui.dart';
import 'package:driver_diary/shared/ui/app_list_row.dart';
import 'package:driver_diary/shared/utils/duration_formatter.dart';
import 'package:driver_diary/shared/utils/format_context.dart';
import 'package:flutter/material.dart';

/// Строка списка: время поездки, длительность и способ оплаты, справа — сумма и комиссия.
class TripTile extends StatelessWidget {
  const TripTile({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colors = context.colors;
    final text = context.textTheme;
    final method = trip.payment;

    return AppListRow(
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: method.softColor(colors),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox.square(
          dimension: 36,
          child: Icon(method.icon, size: 20, color: method.color(colors)),
        ),
      ),
      title:
          '${context.time(trip.start.wallClock)} – ${context.time(trip.end.wallClock)}',
      subtitle:
          '${formatDuration(l10n, trip.duration)} · ${method.label(l10n)}',
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.money(trip.amount), style: text.titleMedium),
          if (trip.commission > 0)
            Text(
              context.money(-trip.commission),
              style: text.bodySmall?.copyWith(color: colors.negative),
            ),
        ],
      ),
    );
  }
}
