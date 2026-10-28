import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../gen/assets.gen.dart';

/// Figma "Power halo" (184) around the "Power ring" (159).
///
/// Figma motion: the halo breathes, scale 1 → [_pulse] → 1 every 2 s.
/// Connecting adds the transition effects: the ring ignites with a glow
/// bloom, sparks burst off it, the glyph flickers, and a soft ripple keeps
/// radiating while connected. Disconnecting plays the ignite in reverse.
class PowerButton extends StatelessWidget {
  const PowerButton({super.key, required this.connected, this.onTap});

  final bool connected;
  final VoidCallback? onTap;

  double get _pulse => connected ? 1.035 : 1.025;

  @override
  Widget build(BuildContext context) {
    final size = 184.r;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (connected) const Positioned.fill(child: _SoftRipple()),
            Positioned.fill(
              child:
                  AnimatedContainer(
                        duration: 450.ms,
                        curve: Curves.easeOut,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: connected
                              ? AppColors.successLight
                              : AppColors.primaryLight,
                        ),
                        child: _Ring(connected: connected),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scaleXY(
                        end: _pulse,
                        duration: 1.seconds,
                        curve: Curves.easeInOut,
                      ),
            ),
            if (connected) const Positioned.fill(child: _ElectricSparks()),
          ],
        ),
      ),
    );
  }
}

/// The 159 px ring. `v` runs 0 → 1 on connect (600 ms) and back on
/// disconnect: grey 2 px → green 6 px, with a green glow that flashes past
/// its resting strength around v = 0.6.
class _Ring extends StatelessWidget {
  const _Ring({required this.connected});

  final bool connected;

  /// Glow strength 0–1: rises to a flash at 0.6, settles to 0.45.
  static double _bloom(double v) =>
      v <= 0.6 ? v / 0.6 : 1 - (v - 0.6) / 0.4 * 0.55;

  @override
  Widget build(BuildContext context) {
    return const SizedBox()
        .animate(target: connected ? 1 : 0)
        .custom(
          duration: 600.ms,
          curve: Curves.easeOut,
          builder: (context, v, _) {
            final bloom = _bloom(v);
            final accent = Color.lerp(
              AppColors.iconIdle,
              AppColors.success,
              v,
            )!;

            return Container(
              width: 159.r,
              height: 159.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceMuted,
                border: Border.all(
                  color: Color.lerp(
                    AppColors.borderStrong,
                    AppColors.success,
                    v,
                  )!,
                  width: lerpDouble(2, 6, v)!.r,
                ),
                boxShadow: [
                  ...AppShadows.power,
                  if (bloom > 0)
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.55 * bloom),
                      blurRadius: (36 * bloom).r,
                      spreadRadius: (4 * bloom).r,
                    ),
                ],
              ),
              child: _PowerGlyph(connected: connected, color: accent),
            );
          },
        );
  }
}

/// The power glyph; flickers like the splash bolt once per connect.
class _PowerGlyph extends StatelessWidget {
  const _PowerGlyph({required this.connected, required this.color});

  final bool connected;
  final Color color;

  // Opacity and x-jitter keyframes, after splash `_Motion.boltOpacity`.
  static const _times = [0.0, 0.2, 0.4, 0.65, 1.0];
  static const _opacity = [1.0, 0.3, 1.0, 0.6, 1.0];
  static const _shiftX = [0.0, -1.5, 1.5, -1.0, 0.0];

  static double _sample(List<double> values, double t) {
    for (var i = 1; i < _times.length; i++) {
      if (t <= _times[i]) {
        final f = (t - _times[i - 1]) / (_times[i] - _times[i - 1]);
        return lerpDouble(values[i - 1], values[i], f)!;
      }
    }
    return values.last;
  }

  @override
  Widget build(BuildContext context) {
    final glyph = AppIcon(
      Assets.svg.power,
      size: 57,
      strokeWidth: 4,
      color: color,
    );
    if (!connected) return glyph;

    return glyph
        .animate(key: const ValueKey('power_flicker'))
        .custom(
          delay: 120.ms,
          duration: 500.ms,
          builder: (context, t, child) => Opacity(
            opacity: _sample(_opacity, t),
            child: Transform.translate(
              offset: Offset(_sample(_shiftX, t).r, 0),
              child: child,
            ),
          ),
        );
  }
}

/// A faint ring radiating from the halo every 2 s while connected.
class _SoftRipple extends StatelessWidget {
  const _SoftRipple();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.success, width: 1.5.r),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .scaleXY(
          begin: 1,
          end: 1.35,
          duration: 2.seconds,
          curve: Curves.easeOut,
        )
        .fade(begin: 0.35, end: 0, duration: 2.seconds, curve: Curves.easeOut);
  }
}

/// Jagged electric arcs bursting off the ring edge, once per connect.
class _ElectricSparks extends StatelessWidget {
  const _ElectricSparks();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: const SizedBox.expand().animate().custom(
        delay: 80.ms,
        duration: 650.ms,
        builder: (context, t, _) => CustomPaint(
          painter: _SparkPainter(progress: t, unit: 1.r),
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({required this.progress, required this.unit});

  /// 0 → 1 over the burst.
  final double progress;

  /// One design px in logical px.
  final double unit;

  static const _arcs = 8;
  static const _segments = 4;
  static const _innerRadius = 80.0;
  static const _reach = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    // Arcs shoot out over the first 40 %, then flicker away.
    final extend = Curves.easeOut.transform((progress / 0.4).clamp(0, 1));
    final flicker = (progress * 30).floor().isEven ? 1.0 : 0.55;
    final opacity = (1 - progress) * flicker;

    final glow = Paint()
      ..color = AppColors.success.withValues(alpha: 0.8 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * unit
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * unit);
    final core = Paint()
      ..color = AppColors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * unit
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final random = math.Random(7);

    for (var i = 0; i < _arcs; i++) {
      final angle = i * 2 * math.pi / _arcs + random.nextDouble() * 0.5;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final normal = Offset(-direction.dy, direction.dx);
      final reach = _reach * (0.7 + random.nextDouble() * 0.3) * extend;

      final path = Path();
      for (var s = 0; s <= _segments; s++) {
        final along = _innerRadius + reach * s / _segments;
        final jag = s == 0 || s == _segments
            ? 0.0
            : (random.nextDouble() * 2 - 1) * 4;
        final point = center + (direction * along + normal * jag) * unit;
        s == 0
            ? path.moveTo(point.dx, point.dy)
            : path.lineTo(point.dx, point.dy);
      }
      canvas
        ..drawPath(path, glow)
        ..drawPath(path, core);
    }
  }

  @override
  bool shouldRepaint(_SparkPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.unit != unit;
}
