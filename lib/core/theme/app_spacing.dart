import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Spacing tokens (design px, scaled with ScreenUtil at use site).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// Horizontal padding of every screen body.
  static const double screen = 20;

  /// Horizontal padding of the app / page headers.
  static const double header = 22;
}

/// Corner-radius tokens.
abstract final class AppRadius {
  static const double xs = 5;
  static const double sm = 9;
  static const double icon = 11;
  static const double md = 12;
  static const double lg = 18;
  static const double pill = 100;
}

/// Shadow tokens.
abstract final class AppShadows {
  /// Cards: #87B4D0 @ 5 %, y 4, blur 20.
  static List<BoxShadow> get card => [
    BoxShadow(
      color: AppColors.cardShadow,
      offset: Offset(0, 4.h),
      blurRadius: 20.r,
    ),
  ];

  /// Power ring: #087DFF @ 8 %, y 8, blur 24.
  static List<BoxShadow> get power => [
    BoxShadow(
      color: AppColors.powerShadow,
      offset: Offset(0, 8.h),
      blurRadius: 24.r,
    ),
  ];
}
