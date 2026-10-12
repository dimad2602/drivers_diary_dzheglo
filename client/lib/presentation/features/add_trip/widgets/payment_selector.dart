import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:driver_diary/presentation/common/payment_method_ui.dart';
import 'package:driver_diary/shared/ui/app_field_frame.dart';
import 'package:driver_diary/shared/ui/app_segmented_control.dart';
import 'package:flutter/material.dart';

/// Выбор способа оплаты: наличные или карта.
class PaymentSelector extends StatelessWidget {
  const PaymentSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return AppFieldFrame(
      label: l10n.fieldPayment,
      child: AppSegmentedControl<PaymentMethod>(
        segments: {
          for (final method in PaymentMethod.values) method: method.label(l10n),
        },
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
