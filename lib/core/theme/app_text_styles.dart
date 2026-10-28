import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Inter text styles used in the Figma file, named by role.
///
/// Default colour is [AppColors.textPrimary]; recolour with `copyWith`.
abstract final class AppTextStyles {
  static const _family = 'Inter';

  /// Figma "Auto" line height: Inter's ascender + descender.
  static const _autoHeight = 1.21;

  // Height and letter spacing are set explicitly so Material 3's
  // DefaultTextStyle (height 1.43, tracking 0.25) never leaks in.
  static TextStyle _style(double size, FontWeight weight, {double? height}) =>
      TextStyle(
        fontFamily: _family,
        fontSize: size.sp,
        fontWeight: weight,
        height: height ?? _autoHeight,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  /// 31 / ExtraBold — splash brand name.
  static TextStyle get brandLarge => _style(31, FontWeight.w800);

  /// 19 / ExtraBold — header brand name.
  static TextStyle get brand => _style(19, FontWeight.w800);

  /// 23 / Bold — connection state.
  static TextStyle get headline => _style(23, FontWeight.w700);

  /// 20 / Bold — server details country.
  static TextStyle get headlineSmall => _style(20, FontWeight.w700);

  /// 19 / Bold — page titles.
  static TextStyle get pageTitle => _style(19, FontWeight.w700);

  /// 16 / Bold — subscription plan name.
  static TextStyle get titleLarge => _style(16, FontWeight.w700);

  /// 15 / Bold — card titles, section titles, metric values.
  static TextStyle get title => _style(15, FontWeight.w700);

  /// 15 / SemiBold — buttons.
  static TextStyle get button => _style(15, FontWeight.w600);

  /// 15 / Medium — menu rows.
  static TextStyle get menu => _style(15, FontWeight.w500);

  /// 14 / Bold — metric values, feature titles.
  static TextStyle get labelLarge => _style(14, FontWeight.w700);

  /// 13 / Bold — server row country.
  static TextStyle get label => _style(13, FontWeight.w700);

  /// 13 / SemiBold — city in the "Other servers" list.
  static TextStyle get labelSemiBold => _style(13, FontWeight.w600);

  /// 13 / Medium — tagline.
  static TextStyle get bodyMedium => _style(13, FontWeight.w500);

  /// 13 / Regular — city under country.
  static TextStyle get body => _style(13, FontWeight.w400);

  /// 12 / Bold — compact feature title.
  static TextStyle get labelSmall => _style(12, FontWeight.w700);

  /// 12 / Regular — descriptions, status text.
  static TextStyle get bodySmall => _style(12, FontWeight.w400);

  /// 11 / Bold — active nav label, PRO badge.
  static TextStyle get captionBold => _style(11, FontWeight.w700);

  /// 11 / SemiBold — tabs, chips.
  static TextStyle get captionSemiBold => _style(11, FontWeight.w600);

  /// 11 / Medium — nav labels.
  static TextStyle get captionMedium => _style(11, FontWeight.w500);

  /// 11 / Regular — metric labels.
  static TextStyle get caption => _style(11, FontWeight.w400);

  /// 11 / Regular, 150 % — feature descriptions.
  static TextStyle get captionRelaxed =>
      _style(11, FontWeight.w400, height: 1.5);

  /// 11 / Regular, 140 % — plan description.
  static TextStyle get captionLoose => _style(11, FontWeight.w400, height: 1.4);

  /// 10 / Regular — latency.
  static TextStyle get micro => _style(10, FontWeight.w400);

  /// 9 / SemiBold — protocol value.
  static TextStyle get tiny => _style(9, FontWeight.w600);
}
