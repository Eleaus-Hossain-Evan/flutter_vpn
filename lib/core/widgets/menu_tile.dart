import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// Figma "Menu item": 54 px row, 23 px icon, 15 px label, optional chevron.
///
/// Shared by Profile and the navigation drawer. [selected] is the drawer's
/// current destination: light-blue fill, primary icon and bold label.
class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.chevron = false,
    this.onTap,
  });

  final SvgGenImage icon;
  final String label;
  final bool selected;
  final bool chevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeOut,
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
        ),
        child: Row(
          children: [
            AppIcon(
              icon,
              size: 23,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: selected
                    ? AppTextStyles.title.copyWith(color: AppColors.primary)
                    : AppTextStyles.menu,
              ),
            ),
            if (chevron) ...[
              SizedBox(width: 14.w),
              AppIcon(
                Assets.svg.chevronRight,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
