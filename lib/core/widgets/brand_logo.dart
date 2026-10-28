import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Figma "Brand" row: 27 px shield + "RedbullVPN" (19 / ExtraBold).
///
/// Used in the home header and the navigation drawer header.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 27.r,
          height: 30.51.r,
          child: Stack(
            children: [
              Positioned.fill(
                child: Assets.svg.shieldSilhouette.svg(fit: BoxFit.fill),
              ),
              Positioned(
                left: 8.37.r,
                top: 6.48.r,
                width: 10.8.r,
                height: 17.55.r,
                child: Assets.svg.lightningBolt.svg(),
              ),
            ],
          ),
        ),
        SizedBox(width: 7.w),
        Text.rich(
          TextSpan(
            style: AppTextStyles.brand,
            children: const [
              TextSpan(text: 'Redbull'),
              TextSpan(
                text: 'VPN',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
