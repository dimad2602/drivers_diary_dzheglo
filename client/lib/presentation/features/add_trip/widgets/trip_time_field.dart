import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/shared/ui/app_text_field.dart';
import 'package:driver_diary/shared/utils/time_input.dart';
import 'package:flutter/material.dart';

/// Время начала или окончания поездки: вводится по маске `ЧЧ:ММ` (только цифры) или
/// выбирается на циферблате по значку справа. Свободный ввод в диалоге отключён.
class TripTimeField extends StatelessWidget {
  const TripTimeField({
    required this.controller,
    required this.label,
    required this.fallbackTime,
    required this.onChanged,
    this.errorText,
    this.helperText,
    super.key,
  });

  final TextEditingController controller;
  final String label;

  /// С какого времени открывается циферблат, пока в поле нет корректного времени.
  final TimeOfDay fallbackTime;
  final String? errorText;

  /// Нейтральная подсказка под полем (например, «На следующий день»).
  final String? helperText;
  final ValueChanged<String> onChanged;

  Future<void> _pickOnDial(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: parseClockTime(controller.text) ?? fallbackTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    final text = formatTimeText(picked);
    controller.text = text;
    onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return AppTextField(
      controller: controller,
      label: label,
      hint: l10n.hintTimeFormat,
      errorText: errorText,
      helperText: helperText,
      keyboardType: TextInputType.number,
      inputFormatters: const [TimeInputFormatter()],
      onChanged: onChanged,
      suffixIcon: IconButton(
        tooltip: l10n.actionPickTime,
        icon: const Icon(Icons.schedule_outlined, size: 20),
        onPressed: () => _pickOnDial(context),
      ),
    );
  }
}
