import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../gen/assets.gen.dart';

/// Figma "Feature card": icon tile, title + description, control row.
class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.tint,
    required this.title,
    required this.description,
    required this.control,
    this.compactTitle = false,
  });

  final SvgGenImage icon;
  final Color tint;
  final String title;
  final String description;
  final Widget control;

  /// 12 px title instead of 14 (Figma's "DNS Leak Protection").
  final bool compactTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 179.h,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 38.r,
              height: 38.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(AppRadius.icon.r),
              ),
              child: AppIcon(icon, size: 23, color: AppColors.white),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            title,
            style: compactTitle
                ? AppTextStyles.labelSmall
                : AppTextStyles.labelLarge,
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            description,
            style: AppTextStyles.captionRelaxed.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(height: 26.h, child: control),
        ],
      ),
    );
  }
}

/// Figma "Enabled switch" / "Disabled switch": 45 × 26 track, 20 px thumb.
class FeatureSwitch extends StatelessWidget {
  const FeatureSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: 220.ms,
          curve: Curves.easeOutCubic,
          width: 45.r,
          height: 26.r,
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: value ? AppColors.primary : AppColors.textSecondary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AnimatedAlign(
            duration: 220.ms,
            curve: Curves.easeOutBack,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Control row with an optional current [value] and a chevron.
class FeatureChevron extends StatelessWidget {
  const FeatureChevron({super.key, this.value});

  final String? value;

  @override
  Widget build(BuildContext context) {
    final value = this.value;

    return Row(
      children: [
        Expanded(
          child: value == null
              ? const SizedBox.shrink()
              : Text(
                  value,
                  style: AppTextStyles.tiny.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
        ),
        SizedBox(width: AppSpacing.xxs.w),
        AppIcon(
          Assets.svg.chevronRight,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
