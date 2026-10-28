import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Round country flag (circle_flags) with the Figma 1 px inside border.
///
/// [isoCode] is an ISO 3166-1 alpha-2 code, any case; [size] is design px.
class CountryFlag extends StatelessWidget {
  const CountryFlag(this.isoCode, {super.key, required this.size});

  final String isoCode;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1.r),
      ),
      child: CircleFlag(isoCode, size: size.r),
    );
  }
}
