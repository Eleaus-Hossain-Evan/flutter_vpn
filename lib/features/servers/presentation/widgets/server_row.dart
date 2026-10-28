import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/country_name.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/country_flag.dart';
import '../../../../gen/assets.gen.dart';
import 'signal_bars.dart';

/// Figma "Server row": flag, country + city, signal, latency, favourite star.
class ServerRow extends StatelessWidget {
  const ServerRow({
    super.key,
    required this.id,
    required this.isoCode,
    required this.city,
    required this.latencyMs,
    required this.bars,
    required this.selected,
    required this.favorite,
    required this.popStar,
    required this.showDivider,
    required this.onTap,
    required this.onToggleFavorite,
    this.entryDelay = Duration.zero,
  });

  final String id;
  final String isoCode;
  final String city;
  final int latencyMs;
  final int bars;
  final bool selected;
  final bool favorite;

  /// Pop the star in: true only for the row the user just favourited.
  final bool popStar;
  final bool showDivider;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final Duration entryDelay;

  @override
  Widget build(BuildContext context) {
    Widget star = AppIcon(
      favorite ? Assets.svg.starFilled : Assets.svg.star,
      size: 21,
      // Figma exports the 1.7 px inside stroke as a 3.4 px stroke masked by
      // the shape, so the file's stroke is twice the visible one.
      strokeWidth: 3.4,
      color: favorite ? AppColors.primary : AppColors.textSecondary,
    );
    if (favorite && popStar) {
      star = star
          .animate(key: const ValueKey('star_pop'))
          .scaleXY(begin: 0.6, duration: 450.ms, curve: Curves.elasticOut);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeOut,
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.white,
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            CountryFlag(isoCode, size: 34),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    countryName(context, isoCode),
                    style: AppTextStyles.label,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    city,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 11.w),
            SignalBars(bars: bars, entryDelay: entryDelay),
            SizedBox(width: 11.w),
            SizedBox(
              width: 38.w,
              child: Text(
                '$latencyMs ms',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: 11.w),
            GestureDetector(
              key: ValueKey('server_star_$id'),
              behavior: HitTestBehavior.opaque,
              onTap: onToggleFavorite,
              child: star,
            ),
          ],
        ),
      ),
    );
  }
}
