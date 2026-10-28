import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icon.dart';

/// Figma "Connection metrics": download, upload, ping and connected time.
class ConnectionMetricsCard extends StatelessWidget {
  const ConnectionMetricsCard({super.key, required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(width: AppSpacing.sm.w);

    return Container(
      height: 128.h,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Metric(
                icon: Assets.svg.arrowDown,
                iconColor: AppColors.primary,
                background: AppColors.primaryLight,
                value: connected ? '32.8 Mbps' : '--',
                label: 'Download',
              ),
              gap,
              _Metric(
                icon: Assets.svg.arrowUp,
                iconColor: AppColors.success,
                background: AppColors.successLight,
                value: connected ? '12.4 Mbps' : '--',
                label: 'Upload',
              ),
            ],
          ),
          SizedBox(height: 19.h),
          Row(
            children: [
              _Metric(
                icon: Assets.svg.orbit,
                iconColor: AppColors.purple,
                background: AppColors.purpleLight,
                value: connected ? '28 ms' : '--',
                label: 'Ping',
              ),
              gap,
              _Metric(
                icon: Assets.svg.clock3,
                iconColor: AppColors.textSecondary,
                background: AppColors.surfaceMuted,
                value: connected ? '00:15:36' : '00:00:00',
                label: 'Connected time',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.value,
    required this.label,
  });

  final SvgGenImage icon;
  final Color iconColor;
  final Color background;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 33.r,
            height: 33.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: background,
            ),
            child: AppIcon(icon, size: 19, color: iconColor),
          ),
          SizedBox(width: 9.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.labelLarge),
              SizedBox(height: 3.h),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
