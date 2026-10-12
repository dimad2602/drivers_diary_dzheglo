import 'package:driver_diary/shared/ui/animations/animation_constants.dart';
import 'package:flutter/widgets.dart';

/// Плавно «досчитывает» целое число до [value]: при первом показе — от нуля,
/// при смене значения — от прежнего к новому. Само число рисует [builder],
/// поэтому форматирование (разряды, валюта) остаётся на стороне вызывающего кода.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    required this.value,
    required this.builder,
    this.duration = AnimationConstants.durationSlow,
    this.curve = AnimationConstants.curve,
    super.key,
  });

  final int value;
  final Widget Function(BuildContext context, int value) builder;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    // «Убрать анимации» в системе: сразу показываем итог.
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return builder(context, value);
    }
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, current, _) => builder(context, current),
    );
  }
}
