import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const String fontFamily = 'Pretendard';
  
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  
  // Display Styles
  static TextStyle get displayL => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 52,
    fontWeight: semiBold,
    letterSpacing: -1.3, // 52 * -0.025 = -1.3
    height: 1.3, // 130%
    color: AppColors.textPrimary,
  );
  
  static TextStyle get displayM => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    fontWeight: semiBold,
    letterSpacing: -0.97, // 44 * -0.022 = -0.97
    height: 1.28,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get displayS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: semiBold,
    letterSpacing: -0.58, // 36 * -0.016 = -0.58
    height: 1.34,
    color: AppColors.textPrimary,
  );
  
  // Heading Styles
  static TextStyle get headingXXL => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: semiBold,
    letterSpacing: -0.8, // 40 * -0.02 = -0.8
    height: 1.3,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headingXL => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: semiBold,
    letterSpacing: -0.58, // 36 * -0.016 = -0.58
    height: 1.34,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headingL => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: semiBold,
    letterSpacing: -0.45, // 32 * -0.014 = -0.45
    height: 1.37,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headingM => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: semiBold,
    letterSpacing: -0.34, // 28 * -0.012 = -0.34
    height: 1.28,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headingS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    letterSpacing: -0.24, // 24 * -0.01 = -0.24
    height: 1.34,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get headingXS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    letterSpacing: -0.14, // 20 * -0.007 = -0.14
    height: 1.4,
    color: AppColors.textPrimary,
  );
  
  // Label Styles
  static TextStyle get labelL => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: medium,
    letterSpacing: -0.18, // 18 * -0.01 = -0.18
    height: 1.54,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get labelM => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: -0.16, // 16 * -0.01 = -0.16
    height: 1.5,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get labelS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0, // 14 * 0 = 0
    height: 1.42,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get labelXS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.12, // 12 * 0.01 = 0.12
    height: 1.34,
    color: AppColors.textPrimary,
  );
  
  // Paragraph Styles
  static TextStyle get paragraphL => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: regular,
    letterSpacing: -0.18, // 18 * -0.01 = -0.18
    height: 1.54,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get paragraphM => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: -0.16, // 16 * -0.01 = -0.16
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get paragraphMReading => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: -0.16, // 16 * -0.01 = -0.16
    height: 1.75,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get paragraphS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0, // 14 * 0 = 0
    height: 1.42,
    color: AppColors.textPrimary,
  );

  static TextStyle get paragraphSReading => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0, // 14 * 0 = 0
    height: 1.7,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get paragraphXS => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.12, // 12 * 0.01 = 0.12
    height: 1.34,
    color: AppColors.textPrimary,
  );
  
  static TextTheme createTextTheme() {
    return TextTheme(
      displayLarge: displayL,
      displayMedium: displayM,
      displaySmall: displayS,
      headlineLarge: headingXXL,
      headlineMedium: headingXL,
      headlineSmall: headingL,
      titleLarge: headingM,
      titleMedium: headingS,
      titleSmall: headingXS,
      bodyLarge: paragraphL,
      bodyMedium: paragraphM,
      bodySmall: paragraphS,
      labelLarge: labelL,
      labelMedium: labelM,
      labelSmall: labelS,
    );
  }
}