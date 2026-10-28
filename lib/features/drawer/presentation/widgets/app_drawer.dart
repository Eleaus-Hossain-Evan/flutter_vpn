import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/menu_tile.dart';
import '../../../../gen/assets.gen.dart';

/// Drawer destinations, in Figma order.
enum DrawerItem {
  home('Home'),
  servers('Servers'),
  features('Features'),
  history('Connection History'),
  settings('Settings'),
  share('Share App'),
  help('Help & Support'),
  about('About');

  const DrawerItem(this.label);

  final String label;

  SvgGenImage get icon => switch (this) {
    home => Assets.svg.house,
    servers => Assets.svg.globe,
    features => Assets.svg.settings,
    history => Assets.svg.history,
    settings => Assets.svg.slidersHorizontal,
    share => Assets.svg.share2,
    help => Assets.svg.headset,
    about => Assets.svg.info,
  };
}

/// Figma "Navigation drawer" (7:1969): 320 px white panel over a scrim.
///
/// Figma has no motion here. The panel slides in (Material drawer) and its
/// content enters once per opening: the promotion fades in and the menu
/// items slide in one after another.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.selected, required this.onSelect});

  /// The highlighted destination, or null when the current screen has none.
  final DrawerItem? selected;
  final ValueChanged<DrawerItem> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 320.w,
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          18.w,
          MediaQuery.paddingOf(context).top,
          18.w,
          0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 55.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BrandLogo(),
                    GestureDetector(
                      key: const ValueKey('drawer_close'),
                      onTap: () => Navigator.of(context).pop(),
                      child: AppIcon(
                        Assets.svg.x,
                        size: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              const _UpgradeCard().animate().fadeIn(
                delay: 80.ms,
                duration: 350.ms,
                curve: Curves.easeOut,
              ),
              SizedBox(height: 22.h),
              for (final (i, item) in DrawerItem.values.indexed) ...[
                if (i > 0) SizedBox(height: 3.h),
                MenuTile(
                      key: ValueKey('drawer_${item.name}'),
                      icon: item.icon,
                      label: item.label,
                      selected: item == selected,
                      onTap: () => onSelect(item),
                    )
                    .animate()
                    .fadeIn(
                      delay: (120 + 35 * i).ms,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    )
                    .slideX(begin: -0.08, curve: Curves.easeOutCubic),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma "Upgrade promotion".
class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.h,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Row(
        children: [
          AppIcon(Assets.svg.crown, size: 29, color: AppColors.warning),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade to Pro',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.warningDark,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Faster servers, no ads and more locations',
                  style: AppTextStyles.captionRelaxed.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 11.w),
          AppIcon(Assets.svg.chevronRight, size: 17, color: AppColors.warning),
        ],
      ),
    );
  }
}
