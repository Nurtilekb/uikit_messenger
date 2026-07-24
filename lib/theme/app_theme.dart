import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.light.primary,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.light.scaffoldBackground,
    dividerColor: AppColors.light.divider,
    extensions: [AppColors.light],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.light.primary),
        foregroundColor: WidgetStatePropertyAll(AppColors.light.textOnPrimary),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: AppColors.light.textPrimary, fontSize: 15),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.light.textSecondary,
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.dark.primary,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.dark.scaffoldBackground,
    dividerColor: AppColors.dark.divider,
    extensions: [AppColors.dark],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.dark.primary),
        foregroundColor: WidgetStatePropertyAll(AppColors.dark.textOnPrimary),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: AppColors.dark.textPrimary, fontSize: 15),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.dark.textSecondary,
      ),
    ),
  );
}
