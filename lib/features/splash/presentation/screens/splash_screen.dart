import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/presentation/screens/home_screen.dart';

/// Figma: "Splash screen" (7:1219).
///
/// Plays the 4 s Figma Motion timeline once: shield pop, two impact ripples,
/// bolt flicker with glow, centre-out ribbon reveal and the loading bar.
class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  static const route = '/';

  static const _timeline = Duration(seconds: 4);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: _timeline);
    useEffect(() {
      controller.forward().then((_) {
        if (context.mounted) context.go(HomeScreen.route);
      });
      return null;
    }, const []);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SizedBox.expand(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) =>
                _SplashContent(seconds: controller.value * 4),
          ),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({required this.seconds});

  /// Position on the Figma timeline, 0–4 s.
  final double seconds;

  // Design-frame coordinates (status bar included, 390 × 844).
  static const _ribbonTop = 271.0;
  static const _ribbonHeight = 350.0;
  static const _brandTop = 289.0;
  static const _loadingTop = 692.0;
  static const _shieldWidth = 98.0;
  static const _shieldHeight = 110.74;
  static const _rippleSize = 112.0;

  @override
  Widget build(BuildContext context) {
    final t = seconds;
    final brandTop = _brandTop.h;
    final rippleTop = brandTop + _shieldHeight.r / 2 - _rippleSize.r / 2;

    return Stack(
      children: [
        Positioned(
          top: _ribbonTop.h,
          left: 0,
          right: 0,
          height: _ribbonHeight.h,
          child: ClipRect(
            clipper: _CenterRevealClipper(_Motion.ribbonReveal.at(t) / 390),
            child: Opacity(
              opacity: _Motion.ribbonOpacity.at(t),
              child: Assets.svg.backgroundRibbon.svg(fit: BoxFit.fill),
            ),
          ),
        ),
        for (final ripple in const [_Ripple.second, _Ripple.first])
          Positioned(
            top: rippleTop,
            left: 0,
            right: 0,
            child: Center(child: ripple.build(t)),
          ),
        Positioned(
          top: brandTop,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: _Motion.shieldOpacity.at(t),
                child: Transform.scale(
                  scale: _Motion.shieldScale.at(t),
                  child: _Shield(seconds: t),
                ),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              Opacity(
                opacity: _Motion.brandOpacity.at(t),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.brandLarge,
                        children: const [
                          TextSpan(text: 'Redbull'),
                          TextSpan(
                            text: 'VPN',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Fast. Secure. Unlimited.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: _loadingTop.h,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: _Motion.loadingOpacity.at(t),
              child: _LoadingBar(progress: _Motion.progress.at(t) / 184),
            ),
          ),
        ),
      ],
    );
  }
}

class _Shield extends StatelessWidget {
  const _Shield({required this.seconds});

  final double seconds;

  @override
  Widget build(BuildContext context) {
    final t = seconds;
    final glow = _Motion.boltGlow.at(t);
    final bolt = Assets.svg.lightningBolt;

    return SizedBox(
      width: _SplashContent._shieldWidth.r,
      height: _SplashContent._shieldHeight.r,
      child: Stack(
        children: [
          Positioned.fill(
            child: Assets.svg.shieldSilhouette.svg(fit: BoxFit.fill),
          ),
          Positioned(
            left: 30.38.r,
            top: 23.52.r,
            width: 39.2.r,
            height: 63.7.r,
            child: Opacity(
              opacity: _Motion.boltOpacity.at(t),
              child: Transform.translate(
                offset: Offset(
                  _Motion.boltShiftX.at(t).r,
                  _Motion.boltShiftY.at(t).r,
                ),
                child: Transform.scale(
                  scale: _Motion.boltScale.at(t),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (glow > 0)
                        Positioned.fill(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: glow.r / 2,
                              sigmaY: glow.r / 2,
                            ),
                            child: bolt.svg(
                              colorFilter: const ColorFilter.mode(
                                AppColors.boltGlow,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      Positioned.fill(child: bolt.svg()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.progress});

  /// Filled fraction, 0–1.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final width = 184.w;
    final radius = BorderRadius.circular(AppRadius.xs.r);

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.h,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.progressTrack,
              borderRadius: radius,
            ),
            child: Container(
              width: width * progress,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: radius,
              ),
            ),
          ),
          SizedBox(height: 13.h),
          Text(
            'Loading...',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

enum _Ripple {
  first(
    strokeWidth: 2,
    opacity: _Motion.ripple1Opacity,
    scale: _Motion.ripple1Scale,
  ),
  second(
    strokeWidth: 1.5,
    opacity: _Motion.ripple2Opacity,
    scale: _Motion.ripple2Scale,
  );

  const _Ripple({
    required this.strokeWidth,
    required this.opacity,
    required this.scale,
  });

  final double strokeWidth;
  final _Track opacity;
  final _Track scale;

  Widget build(double t) {
    final size = _SplashContent._rippleSize.r;
    return Opacity(
      opacity: opacity.at(t),
      child: Transform.scale(
        scale: scale.at(t),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.ripple,
              width: strokeWidth.r,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
        ),
      ),
    );
  }
}

/// Reveals [fraction] of the child's width, growing out from the centre.
class _CenterRevealClipper extends CustomClipper<Rect> {
  const _CenterRevealClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromCenter(
    center: size.center(Offset.zero),
    width: size.width * fraction,
    height: size.height,
  );

  @override
  bool shouldReclip(_CenterRevealClipper oldClipper) =>
      oldClipper.fraction != fraction;
}

/// One keyframe: timeline second, value, and the easing of the segment that
/// arrives at it (Figma Motion semantics).
typedef _Key = (double, double, Curve);

/// A Figma Motion keyframe track, sampled by timeline second.
class _Track {
  const _Track(this.keys);

  final List<_Key> keys;

  double at(double t) {
    if (t <= keys.first.$1) return keys.first.$2;
    for (var i = 1; i < keys.length; i++) {
      final (t1, v1, curve) = keys[i];
      if (t <= t1) {
        final (t0, v0, _) = keys[i - 1];
        return v0 + (v1 - v0) * curve.transform((t - t0) / (t1 - t0));
      }
    }
    return keys.last.$2;
  }
}

/// Keyframes copied from `get_motion_context` on 7:1219.
abstract final class _Motion {
  static const _out = Curves.easeOut; // Figma EASE_OUT (0, 0, .58, 1)
  static const _inOut = Curves.easeInOut; // Figma EASE_IN_AND_OUT
  static const _lin = Curves.linear;

  // Ribbon frame width (390 = fully open), centre-out.
  static const ribbonReveal = _Track([
    (0, 1, _out),
    (0.9, 1, _out),
    (1.85, 390, _out),
  ]);
  static const ribbonOpacity = _Track([
    (0, 0, _out),
    (0.9, 0, _out),
    (1.15, 1, _out),
  ]);

  static const ripple1Opacity = _Track([
    (0, 0, _out),
    (0.23, 0, _out),
    (0.255, 0.4, _lin),
    (0.85, 0, _out),
  ]);
  static const ripple1Scale = _Track([
    (0, 0.65, _out),
    (0.23, 0.65, _out),
    (0.85, 2.1, _out),
  ]);
  static const ripple2Opacity = _Track([
    (0, 0, _out),
    (0.36, 0, _out),
    (0.385, 0.23, _lin),
    (1.02, 0, _out),
  ]);
  static const ripple2Scale = _Track([
    (0, 0.65, _out),
    (0.36, 0.65, _out),
    (1.02, 1.9, _out),
  ]);

  static const shieldOpacity = _Track([(0, 0, _out), (0.06, 1, _out)]);
  static const shieldScale = _Track([
    (0, 0.12, _out),
    (0.12, 0.42, _out),
    (0.28, 1.14, _out),
    (0.38, 0.94, _out),
    (0.5, 1.055, _out),
    (0.66, 1, _out),
  ]);

  static const boltOpacity = _Track([
    (0, 0, _out),
    (0.9, 0, _out),
    (0.94, 1, _lin),
    (1, 0.3, _lin),
    (1.06, 1, _lin),
    (1.14, 0.6, _lin),
    (1.22, 1, _lin),
    (1.4, 1, _out),
  ]);
  static const boltShiftX = _Track([
    (0, 0, _out),
    (0.9, 0, _out),
    (0.94, -1.5, _lin),
    (1, 1.5, _lin),
    (1.06, -1, _lin),
    (1.14, 1, _lin),
    (1.22, 0, _out),
  ]);
  static const boltShiftY = _Track([
    (0, 0, _out),
    (0.9, 0, _out),
    (0.94, 0, _lin),
    (1, -1, _lin),
    (1.06, 1, _lin),
    (1.14, 0, _lin),
    (1.22, 0, _out),
  ]);
  static const boltScale = _Track([
    (0, 1, _out),
    (0.9, 1, _out),
    (0.96, 1.12, _out),
    (1.1, 0.98, _out),
    (1.28, 1, _out),
  ]);
  static const boltGlow = _Track([
    (0, 0, _out),
    (0.9, 0, _out),
    (0.96, 12, _out),
    (1.04, 3, _out),
    (1.1, 10, _out),
    (1.22, 5, _out),
    (1.55, 0, _out),
  ]);

  static const brandOpacity = _Track([
    (0, 0, _inOut),
    (0.2, 0, _inOut),
    (0.8, 1, _out),
  ]);
  static const loadingOpacity = _Track([
    (0, 0, _inOut),
    (0.55, 0, _inOut),
    (1, 1, _out),
  ]);

  // Progress fill width in design px (track is 184).
  static const progress = _Track([
    (0, 8, _inOut),
    (0.6, 8, _inOut),
    (1.5, 74, _inOut),
    (2.5, 132, _inOut),
    (3.4, 184, _out),
  ]);
}
