import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:flutter/material.dart';

/// Переключатель на 2–4 варианта: серая дорожка и «ползунок» под выбранным.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Значение → подпись, порядок сохраняется.
  final Map<T, String> segments;
  final T value;
  final ValueChanged<T> onChanged;

  static const double height = 44;
  static const double _padding = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;
    final entries = segments.entries.toList();
    final selected = entries.indexWhere((e) => e.key == value);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.fillPrimary,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Stack(
            children: [
              if (selected >= 0)
                AnimatedAlign(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(
                    entries.length == 1
                        ? 0
                        : -1 + 2 * selected / (entries.length - 1),
                    0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / entries.length,
                    heightFactor: 1,
                    child: DecoratedBox(
                      key: const Key('segment-thumb'),
                      decoration: BoxDecoration(
                        color: colors.segmentedThumb,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  for (final entry in entries)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: entry.key == value,
                        label: entry.value,
                        excludeSemantics: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(entry.key),
                          child: Center(
                            child: Text(
                              entry.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleSmall?.copyWith(
                                color: entry.key == value
                                    ? colors.labelPrimary
                                    : colors.labelSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
