import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';

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
            if (connected)
              Assets.svg.flagUs.svg(width: 36.r, height: 36.r)
            else
              AppIcon(Assets.svg.globe, size: 35, color: AppColors.primary),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
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
