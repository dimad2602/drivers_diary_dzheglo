import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/domain/models/payment_method.dart';
import 'package:driver_diary/presentation/common/payment_method_ui.dart';
import 'package:driver_diary/shared/ui/animations/animations.dart';
import 'package:flutter/material.dart';

/// Полоса «наличные / карта» пропорционально выручке. Без выручки — пустая дорожка.
/// При появлении полоса «вырастает» слева направо.
class PaymentSplitBar extends StatelessWidget {
  const PaymentSplitBar({
    required this.cashRevenue,
    required this.cardRevenue,
    super.key,
  });

  final int cashRevenue;
  final int cardRevenue;

  static const double height = 8;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasRevenue = cashRevenue + cardRevenue > 0;
    final reducedMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: hasRevenue
            ? TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: reducedMotion
                    ? Duration.zero
                    : AnimationConstants.durationSlow,
                curve: AnimationConstants.curve,
                builder: (context, grown, child) => FractionallySizedBox(
                  widthFactor: grown,
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
                child: Row(
                  children: [
                    if (cashRevenue > 0)
                      Expanded(
                        flex: cashRevenue,
                        child: ColoredBox(
                          key: const Key('split-cash'),
                          color: PaymentMethod.cash.color(colors),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    if (cashRevenue > 0 && cardRevenue > 0)
                      const SizedBox(width: 2),
                    if (cardRevenue > 0)
                      Expanded(
                        flex: cardRevenue,
                        child: ColoredBox(
                          key: const Key('split-card'),
                          color: PaymentMethod.card.color(colors),
                          child: const SizedBox.expand(),
                        ),
                      ),
                  ],
                ),
              )
            : ColoredBox(
                key: const Key('split-empty'),
                color: colors.fillPrimary,
                child: const SizedBox.expand(),
              ),
      ),
    );
  }
}
