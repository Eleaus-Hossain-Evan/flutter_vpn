import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.surfaceMuted,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.cyan,
      error: AppColors.danger,
      surface: AppColors.white,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    ),
    dividerColor: AppColors.border,
  );
}
