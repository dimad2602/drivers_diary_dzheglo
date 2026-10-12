import 'package:driver_diary/shared/ui/animations/animation_constants.dart';
import 'package:driver_diary/shared/ui/animations/fade_slide_in.dart';
import 'package:flutter/widgets.dart';

/// Оборачивает каждый элемент в [FadeSlideIn] с нарастающей задержкой:
/// блоки появляются один за другим. Подходит для любых наборов блоков в колонке.
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    required this.children,
    this.staggerDelay = AnimationConstants.staggerDelay,
    this.itemDuration = AnimationConstants.duration,
    this.offset = AnimationConstants.slideOffset,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.min,
    this.spacing = 0,
    super.key,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final double offset;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  /// Промежуток между элементами.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (spacing > 0 && i > 0) SizedBox(height: spacing),
          FadeSlideIn(
            delay: staggerDelay * i,
            duration: itemDuration,
            offset: offset,
            child: children[i],
          ),
        ],
      ],
    );
  }
}
