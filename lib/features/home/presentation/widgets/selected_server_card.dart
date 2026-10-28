import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/slide_fade_switcher.dart';

/// Figma "Selected server": Smart Location (globe) when not connected,
/// the connected country (flag) otherwise.
class SelectedServerCard extends StatelessWidget {
  const SelectedServerCard({super.key, required this.connected, this.onTap});

  final bool connected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // Figma: globe 35 px, flag 36 px — keeps the title at x 83 / 84.
            SizedBox(
              width: (connected ? 36 : 35).r,
              height: 36.r,
              child: AnimatedSwitcher(
                duration: 350.ms,
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.6, end: 1.0).animate(animation),
                    child: child,
                  ),
                ),
                child: connected
                    ? Assets.svg.flagUs.svg(
                        key: const ValueKey('flag'),
                        width: 36.r,
                        height: 36.r,
                      )
                    : Align(
                        key: const ValueKey('globe'),
                        alignment: Alignment.centerLeft,
                        child: AppIcon(
                          Assets.svg.globe,
                          size: 35,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: SlideFadeSwitcher(
                alignment: Alignment.centerLeft,
                child: Column(
                  key: ValueKey(connected),
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connected ? 'United States' : 'Smart Location',
                      style: AppTextStyles.title,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      connected ? 'New York' : 'Fastest Server',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            AppIcon(
              Assets.svg.chevronRight,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
