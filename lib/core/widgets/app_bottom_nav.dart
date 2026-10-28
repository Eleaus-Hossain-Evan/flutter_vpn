import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// Figma "Bottom navigation": Home, Servers, Features, Profile.
///
/// Sits above the system gesture area, which keeps the screen background.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static final _items = [
    (Assets.svg.house, 'Home'),
    (Assets.svg.globe, 'Servers'),
    (Assets.svg.settings, 'Features'),
    (Assets.svg.userRound, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 76.h,
          padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 7.h),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (index, (icon, label)) in _items.indexed)
                _NavItem(
                  key: ValueKey('bottom_nav_$index'),
                  icon: icon,
                  label: label,
                  selected: index == currentIndex,
                  onTap: () => onTap(index),
                ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.paddingOf(context).bottom),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final SvgGenImage icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    final style = selected
        ? AppTextStyles.captionBold
        : AppTextStyles.captionMedium;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(icon, size: 24, color: color),
            SizedBox(height: 7.h),
            Text(label, style: style.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
