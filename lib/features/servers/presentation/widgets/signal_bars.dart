import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// Figma "Server signal": three 4 px bars, 6 / 11 / 16 tall, bottom-aligned.
///
/// [bars] lit bars: 3 is strong (green), fewer is weak (amber, the rest at
/// 25 %). On entry the bars grow up one after another from [entryDelay].
class SignalBars extends StatelessWidget {
  const SignalBars({
    super.key,
    required this.bars,
    this.entryDelay = Duration.zero,
  });

  final int bars;
  final Duration entryDelay;

  static const _heights = [6.0, 11.0, 16.0];

  @override
  Widget build(BuildContext context) {
    final color = bars >= 3 ? AppColors.success : AppColors.warning;

    return SizedBox(
      height: 19.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (i, height) in _heights.indexed) ...[
            if (i > 0) SizedBox(width: 2.w),
            Container(
              width: 4.w,
              height: height.h,
              decoration: BoxDecoration(
                color: i < bars ? color : color.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(1.r),
              ),
            ).animate().scaleY(
              begin: 0,
              alignment: Alignment.bottomCenter,
              delay: entryDelay + (60 * i).ms,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            ),
          ],
        ],
      ),
    );
  }
}
