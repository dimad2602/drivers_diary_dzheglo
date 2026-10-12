import 'package:driver_diary/shared/ui/animations/animation_constants.dart';
import 'package:flutter/widgets.dart';

/// Состояние анимации появления. Задержка входит в общую длительность
/// (анимация просто стоит в начале), поэтому таймеры не нужны: нет «висящих»
/// таймеров в тестах и ничего не срабатывает после dispose.
mixin _EntranceAnimation<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  void _initEntrance({
    required Duration duration,
    required Duration delay,
    required Curve curve,
  }) {
    final total = delay + duration;
    _controller = AnimationController(vsync: this, duration: total);
    final start = total == Duration.zero
        ? 0.0
        : delay.inMicroseconds / total.inMicroseconds;
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1, curve: curve),
    );
    _controller.forward();
  }

  /// «Убрать анимации» в настройках системы: показываем сразу, без движения.
  void _respectReducedMotion() {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _controller.value = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _respectReducedMotion();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Плавное появление: fade + мягкий сдвиг снизу вверх.
/// Запускается автоматически при монтировании виджета.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.duration = AnimationConstants.duration,
    this.curve = AnimationConstants.curve,
    this.offset = AnimationConstants.slideOffset,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  /// Начальный вертикальный сдвиг в пикселях (положительный — снизу).
  final double offset;

  /// Пауза перед стартом.
  final Duration delay;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin, _EntranceAnimation {
  @override
  void initState() {
    super.initState();
    _initEntrance(
      duration: widget.duration,
      delay: widget.delay,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, widget.offset * (1 - _progress.value)),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Только fade, без сдвига. Для элементов, которые не должны двигаться.
class FadeIn extends StatefulWidget {
  const FadeIn({
    required this.child,
    this.duration = AnimationConstants.duration,
    this.curve = AnimationConstants.curve,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration delay;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn>
    with SingleTickerProviderStateMixin, _EntranceAnimation {
  @override
  void initState() {
    super.initState();
    _initEntrance(
      duration: widget.duration,
      delay: widget.delay,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _progress, child: widget.child);
  }
}
