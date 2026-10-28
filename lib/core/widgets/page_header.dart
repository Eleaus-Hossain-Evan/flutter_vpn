import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Figma "Page header": 28 px leading slot, centred title, 28 px trailing slot.
///
/// Shared by Choose server, Server details, Features and Profile; an empty
/// slot keeps the title centred.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // Figma slots are 28 px frames that lay their icon out top-left.
    Widget slot(Widget? child) => SizedBox.square(
      dimension: 28.r,
      child: Align(alignment: Alignment.topLeft, child: child),
    );

    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.header.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          slot(leading),
          Text(title, style: AppTextStyles.pageTitle),
          slot(trailing),
        ],
      ),
    );
  }
}
