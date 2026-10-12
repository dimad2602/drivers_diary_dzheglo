import 'dart:math';

import 'package:flutter/widgets.dart';

/// Максимальная ширина контента: на десктопе страница не растягивается на весь экран.
const double kMaxContentWidth = 576;

const double kPageGutter = 16;

/// Боковые поля страницы: минимум [kPageGutter], а на широких экранах контент
/// центрируется в колонке шириной [kMaxContentWidth].
EdgeInsets pagePadding(BuildContext context, {double vertical = 16}) {
  final width = MediaQuery.sizeOf(context).width;
  final side = max(kPageGutter, (width - kMaxContentWidth) / 2);
  return EdgeInsets.fromLTRB(side, vertical, side, vertical);
}
