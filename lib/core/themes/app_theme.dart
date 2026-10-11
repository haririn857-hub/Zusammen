import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get romanticDarkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.roseQuartz,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.roseQuartz,
        secondary: AppColors.champagneGold,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        headlineMedium: AppTypography.romanticHeadline(),
        bodyMedium: AppTypography.body(),
      ),
      useMaterial3: true,
    );
  }
}
