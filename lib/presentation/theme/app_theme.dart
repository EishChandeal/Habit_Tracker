import 'package:flutter/material.dart';

/// Design tokens extracted from DESIGN.md and PROJECT_BRIEF.md.
class AppColors {
  AppColors._();

  // Core canvas and surfaces
  static const Color background = Color(0xFF0F1115);
  static const Color surface = Color(0xFF1C1F26);

  // Action and state accents
  static const Color blue = Color(0xFF216CCF);
  static const Color orange = Color(0xFFFF7A45);
  static const Color mutedGrey = Color(0xFFA4AFBE);

  // Typography and control text
  static const Color primaryText = Color(0xFFE7E8EA);
  static const Color controlText = Color(0xFF0F1115);

  // Semantic aliases matching design documentation
  static const Color incomplete = mutedGrey;
  static const Color accentBlue = blue;
  static const Color accentOrange = orange;
}

/// Central application theme adhering to the dark palette specified in DESIGN.md.
class AppTheme {
  AppTheme._();

  static const String fontPrimary = 'Montserrat';

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.blue,
      onPrimary: AppColors.controlText,
      secondary: AppColors.orange,
      onSecondary: AppColors.controlText,
      surface: AppColors.surface,
      onSurface: AppColors.primaryText,
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
      outline: AppColors.mutedGrey,
    );

    final baseTextTheme = Typography.material2021(platform: TargetPlatform.android).white;
    final textTheme = baseTextTheme.apply(
      fontFamily: fontPrimary,
      bodyColor: AppColors.primaryText,
      displayColor: AppColors.primaryText,
    ).copyWith(
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontFamily: fontPrimary,
        color: AppColors.primaryText,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontFamily: fontPrimary,
        color: AppColors.primaryText,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontFamily: fontPrimary,
        color: AppColors.mutedGrey,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontFamily: fontPrimary,
        color: AppColors.primaryText,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: fontPrimary,
        color: AppColors.primaryText,
        fontWeight: FontWeight.bold,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontPrimary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.controlText,
          textStyle: const TextStyle(
            fontFamily: fontPrimary,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.controlText,
          textStyle: const TextStyle(
            fontFamily: fontPrimary,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryText,
          side: const BorderSide(color: AppColors.surface),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(
          color: AppColors.mutedGrey,
          fontFamily: fontPrimary,
        ),
        labelStyle: const TextStyle(
          color: AppColors.mutedGrey,
          fontFamily: fontPrimary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryText,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.surface,
        thickness: 1,
      ),
    );
  }
}
