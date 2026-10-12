import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/ui/app_picker_field.dart';
import 'package:driver_diary/shared/utils/format_context.dart';
import 'package:flutter/material.dart';

/// День поездки. Будущие дни выбрать нельзя ([lastDate] — сегодня).
class TripDateField extends StatelessWidget {
  const TripDateField({
    required this.date,
    required this.lastDate,
    required this.onChanged,
    super.key,
  });

  final DateTime date;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppPickerField(
      label: S.of(context).fieldDate,
      value: context.fullDate(date),
      icon: Icons.calendar_today_outlined,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          firstDate: DateTime(2020),
          lastDate: lastDate,
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}
