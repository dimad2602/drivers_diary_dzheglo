import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:flutter/material.dart';

const double kCardRadius = 16;

/// Скруглённая карточка без тени (как секция списка в fusion-ui): строки разделены линиями.
class AppCardSection extends StatelessWidget {
  const AppCardSection({
    required this.children,
    this.header,
    this.padding,
    super.key,
  });

  /// Подпись над карточкой.
  final String? header;

  /// Строки карточки. Между ними автоматически рисуются разделители.
  final List<Widget> children;

  /// Внутренние отступы карточки (по умолчанию нет — строки сами задают отступы).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rows = <Widget>[
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0)
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 16,
            color: colors.separator,
          ),
        children[i],
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              header!,
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.labelSecondary,
              ),
            ),
          ),
        ClipRSuperellipse(
          borderRadius: BorderRadius.circular(kCardRadius),
          child: ColoredBox(
            color: colors.backgroundCard,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Column(children: rows),
            ),
          ),
        ),
      ],
    );
  }
}
