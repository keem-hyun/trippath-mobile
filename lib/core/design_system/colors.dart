import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF81C784);
  
  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray900 = Color(0xFF212121);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray50 = Color(0xFFFAFAFA);
  
  // Semantic Colors
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);
  
  // Background Colors
  static const Color background = white;
  static const Color backgroundDark = gray900;
  static const Color surface = white;
  static const Color surfaceDark = gray800;
  
  // Text Colors
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray400;
  static const Color textPrimaryDark = white;
  static const Color textSecondaryDark = gray300;
  static const Color textTertiaryDark = gray500;
  
  // Trip Status Colors
  static const Color tripScheduled = primary;
  static const Color tripInProgress = secondary;
  static const Color tripCompleted = gray500;
  
  // Overlay Colors
  static Color overlayDark = black.withOpacity(0.7);
  static Color overlayLight = white.withOpacity(0.7);
  static Color scrim = black.withOpacity(0.32);
}