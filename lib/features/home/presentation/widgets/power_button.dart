import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';

/// Figma "Power halo" (184) around the "Power ring" (159).
///
/// The halo breathes: scale 1 → [_pulse] → 1 every 2 s, ease-in-out.
class PowerButton extends StatelessWidget {
  const PowerButton({super.key, required this.connected, this.onTap});

  final bool connected;
  final VoidCallback? onTap;

  double get _pulse => connected ? 1.035 : 1.025;

  @override
  Widget build(BuildContext context) {
    final accent = connected ? AppColors.success : AppColors.iconIdle;

    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                width: 184.r,
                height: 184.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: connected
                      ? AppColors.successLight
                      : AppColors.primaryLight,
                ),
                child: Container(
                  width: 159.r,
                  height: 159.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceMuted,
                    border: Border.all(
                      color: connected
                          ? AppColors.success
                          : AppColors.borderStrong,
                      width: (connected ? 6 : 2).r,
                    ),
                    boxShadow: AppShadows.power,
                  ),
                  child: AppIcon(
                    Assets.svg.power,
                    size: 57,
                    strokeWidth: 4,
                    color: accent,
                  ),
                ),
              )
              .animate(
                key: ValueKey(connected),
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scaleXY(
                end: _pulse,
                duration: 1.seconds,
                curve: Curves.easeInOut,
              ),
    );
  }
}
