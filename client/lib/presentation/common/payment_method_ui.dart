import 'package:driver_diary/app/theme/app_colors.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Как способ оплаты выглядит в интерфейсе.
extension PaymentMethodUi on PaymentMethod {
  String label(S l10n) => switch (this) {
    PaymentMethod.cash => l10n.paymentCash,
    PaymentMethod.card => l10n.paymentCard,
  };

  IconData get icon => switch (this) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.card => Icons.credit_card_outlined,
  };

  Color color(AppColors colors) => switch (this) {
    PaymentMethod.cash => colors.positive,
    PaymentMethod.card => colors.accent,
  };

  Color softColor(AppColors colors) => switch (this) {
    PaymentMethod.cash => colors.positiveSoft,
    PaymentMethod.card => colors.accentSoft,
  };
}
