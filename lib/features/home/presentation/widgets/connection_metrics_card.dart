import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                connected: connected,
                countTo: 32.8,
                decimals: 1,
                suffix: ' Mbps',
                label: 'Download',
              ),
              gap,
              _Metric(
                icon: Assets.svg.arrowUp,
                iconColor: AppColors.success,
                background: AppColors.successLight,
                connected: connected,
                countTo: 12.4,
                decimals: 1,
                suffix: ' Mbps',
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
                connected: connected,
                countTo: 28,
                suffix: ' ms',
                label: 'Ping',
              ),
              gap,
              _Metric(
                icon: Assets.svg.clock3,
                iconColor: AppColors.textSecondary,
                background: AppColors.surfaceMuted,
                connected: connected,
                connectedText: '00:15:36',
                idle: '00:00:00',
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
    required this.connected,
    required this.label,
    this.countTo,
    this.decimals = 0,
    this.suffix = '',
    this.connectedText,
    this.idle = '--',
  });

  final SvgGenImage icon;
  final Color iconColor;
  final Color background;
  final bool connected;
  final String label;

  /// Connected value counted up from 0 on connect, shown with [decimals]
  /// and [suffix]. Use [connectedText] instead for non-numeric values.
  final double? countTo;
  final int decimals;
  final String suffix;
  final String? connectedText;

  /// Value shown while not connected.
  final String idle;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.labelLarge;
    final countTo = this.countTo;

    Widget badge = Container(
      width: 33.r,
      height: 33.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: background),
      child: AppIcon(icon, size: 19, color: iconColor),
    );
    // Pops once per connect: the Animate wrapper only exists while connected.
    if (connected) {
      badge = badge
          .animate(key: const ValueKey('metric_pop'))
          .scaleXY(begin: 0.7, duration: 500.ms, curve: Curves.elasticOut);
    }

    final Widget value = !connected
        ? Text(idle, style: style)
        : countTo == null
        ? Text(connectedText!, style: style)
        : TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: countTo),
            duration: 900.ms,
            curve: Curves.easeOutCubic,
            builder: (context, v, _) =>
                Text('${v.toStringAsFixed(decimals)}$suffix', style: style),
          );

    return Expanded(
      child: Row(
        children: [
          badge,
          SizedBox(width: 9.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: 250.ms,
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.centerLeft,
                  children: [...previous, ?current],
                ),
                child: KeyedSubtree(key: ValueKey(connected), child: value),
              ),
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
