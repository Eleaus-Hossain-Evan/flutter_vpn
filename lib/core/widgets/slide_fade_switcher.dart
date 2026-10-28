import 'package:flutter/widgets.dart';

/// `AnimatedSwitcher` whose children slide up by [offsetY] (fraction of their
/// height) while fading — the state-swap motion used across Home.
class SlideFadeSwitcher extends StatelessWidget {
  const SlideFadeSwitcher({
    super.key,
    required this.child,
    this.offsetY = 0.35,
    this.duration = const Duration(milliseconds: 300),
    this.alignment = Alignment.center,
    this.expand = false,
  });

  final Widget child;
  final double offsetY;
  final Duration duration;
  final AlignmentGeometry alignment;

  /// Stretch children to the switcher's constraints (e.g. a full-width button).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) => Stack(
        alignment: alignment,
        fit: expand ? StackFit.expand : StackFit.loose,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: Offset(0, offsetY),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
