import 'package:driver_diary/shared/ui/animations/animation_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Fade-переход между страницами вместо стандартного сдвига.
/// Используется в `pageBuilder` всех GoRoute.
Page<T> fadePage<T>({
  required Widget child,
  LocalKey? key,
  String? name,
  Object? arguments,
  String? restorationId,
}) {
  return CustomTransitionPage<T>(
    key: key,
    name: name,
    arguments: arguments,
    restorationId: restorationId,
    transitionDuration: AnimationConstants.duration,
    reverseTransitionDuration: AnimationConstants.durationFast,
    transitionsBuilder: (_, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: AnimationConstants.curve,
      ),
      child: child,
    ),
    child: child,
  );
}
