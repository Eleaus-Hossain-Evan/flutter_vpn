import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/menu_tile.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../gen/assets.gen.dart';

/// Figma "Profile and settings" (7:1901).
///
/// Figma has no motion here; the three blocks enter once, staggered, like
/// the Features cards. The rows have no destinations yet.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const route = '/profile';

  static final _menu = [
    (Assets.svg.userRound, 'Account'),
    (Assets.svg.settings, 'Settings'),
    (Assets.svg.history, 'Connection History'),
    (Assets.svg.starRounded, 'Rate Us'),
    (Assets.svg.headset, 'Help & Support'),
    (Assets.svg.info, 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const PageHeader(title: 'Profile'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen.w,
                    18.h,
                    AppSpacing.screen.w,
                    AppSpacing.lg.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _entry(const _ProCard(), 0),
                      SizedBox(height: AppSpacing.xl.h),
                      _entry(
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.lg.r),
                          ),
                          child: Column(
                            children: [
                              for (final (i, (icon, label)) in _menu.indexed)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: i < _menu.length - 1
                                        ? const Border(
                                            bottom: BorderSide(
                                              color: AppColors.border,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: MenuTile(
                                    icon: icon,
                                    label: label,
                                    chevron: true,
                                    onTap: () {},
                                  ),
                                ),
                            ],
                          ),
                        ),
                        1,
                      ),
                      SizedBox(height: AppSpacing.xl.h),
                      _entry(const _LogOutButton(), 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// One-shot staggered entry: fade and rise.
  static Widget _entry(Widget child, int index) => child
      .animate()
      .fadeIn(
        delay: (100 + 90 * index).ms,
        duration: 400.ms,
        curve: Curves.easeOut,
      )
      .slideY(begin: 0.08, curve: Curves.easeOutCubic);
}

/// Figma "Pro subscription".
class _ProCard extends StatelessWidget {
  const _ProCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86.h,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.warning,
              borderRadius: BorderRadius.circular(AppRadius.md.r),
            ),
            child: AppIcon(Assets.svg.crown, size: 25, color: AppColors.white),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RedbullVPN Pro', style: AppTextStyles.titleLarge),
                SizedBox(height: 7.h),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Unlock all servers and premium features',
                    style: AppTextStyles.captionLoose.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          AppIcon(
            Assets.svg.chevronRight,
            size: 19,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// Figma "Log out action".
class _LogOutButton extends StatelessWidget {
  const _LogOutButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerLight,
      borderRadius: BorderRadius.circular(AppRadius.md.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const ValueKey('profile_log_out'),
        onTap: () {},
        child: SizedBox(
          height: 50.h,
          child: Center(
            child: Text(
              'Log Out',
              style: AppTextStyles.button.copyWith(color: AppColors.danger),
            ),
          ),
        ),
      ),
    );
  }
}
