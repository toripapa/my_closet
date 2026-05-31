import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF000000);
  static const Color textAccent = Color(0xFF333333);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFCCCCCC);
  static const Color hover = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF000000);
  static const Color error = Color(0xFFE53935);

  // 메뉴 영역 다크 테마 색상
  static const Color menuBackground = Color(0xFF1A1A2E); // 다크 네이비 배경
  static const Color menuText = Color(0xFFE0E0E0); // 밝은 회색 텍스트
  static const Color menuSelected = Color(0xFF2D2D44); // 선택 항목 강조 배경
  static const Color menuHover = Color(0xFF252540); // 호버 배경
}

class AppSpacing {
  static const double s1 = 8.0;
  static const double s2 = 16.0;
  static const double s3 = 24.0;
  static const double s4 = 32.0;
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.textAccent,
    error: AppColors.error,
    surface: AppColors.background,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w300,
    ),
    titleLarge: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerColor: AppColors.divider,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textMain,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.textMain),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.zero,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textMain),
      borderRadius: BorderRadius.zero,
    ),
  ),
);
