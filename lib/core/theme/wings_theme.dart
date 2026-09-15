import 'package:flutter/material.dart';

import 'wings_colors.dart';

abstract final class WingsTheme {
  static const displayFamily = 'Sora';
  static const bodyFamily = 'Figtree';

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    colors: WingsColors.dark,
    scheme: const ColorScheme.dark(
      primary: Color(0xFFC8E38A),
      onPrimary: Color(0xFF1A2410),
      secondary: Color(0xFF9BB8C9),
      onSecondary: Color(0xFF102028),
      tertiary: Color(0xFFE0A66A),
      onTertiary: Color(0xFF2A1C0E),
      surface: Color(0xFF1C2420),
      onSurface: Color(0xFFF2F4F0),
      error: Color(0xFFE07A6A),
      onError: Color(0xFF2A0E0C),
      outline: Color(0xFF3D4A44),
      outlineVariant: Color(0xFF2A332E),
    ),
    scaffold: const Color(0xFF111513),
  );

  static ThemeData light() => _build(
    brightness: Brightness.light,
    colors: WingsColors.light,
    scheme: const ColorScheme.light(
      primary: Color(0xFF3F6B2A),
      onPrimary: Color(0xFFF4F8EA),
      secondary: Color(0xFF3A6A7C),
      onSecondary: Color(0xFFF0F7FA),
      tertiary: Color(0xFFA05C28),
      onTertiary: Color(0xFFFFF4EA),
      surface: Color(0xFFFFFBF3),
      onSurface: Color(0xFF141A16),
      error: Color(0xFFB24338),
      onError: Color(0xFFFFF6F5),
      outline: Color(0xFFC9C2B4),
      outlineVariant: Color(0xFFE7E0D4),
    ),
    scaffold: const Color(0xFFF4F1EA),
  );

  static ThemeData _build({
    required Brightness brightness,
    required WingsColors colors,
    required ColorScheme scheme,
    required Color scaffold,
  }) {
    final textTheme = _textTheme(scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: bodyFamily,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.card,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(fontFamily: displayFamily),
        ),
        height: 72,
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WingsRadii.md),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.outlineVariant,
        labelStyle: textTheme.labelMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WingsRadii.lg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: textTheme.titleMedium?.copyWith(fontFamily: displayFamily),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WingsRadii.sm),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: textTheme.titleMedium?.copyWith(fontFamily: displayFamily),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WingsRadii.sm),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.card,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WingsRadii.sm),
        ),
      ),
      extensions: [colors],
    );
  }

  static TextTheme _textTheme(Color onSurface) {
    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: displayFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: displayFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: displayFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: displayFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 16,
        height: 1.45,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 14,
        height: 1.45,
        color: onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: displayFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: onSurface,
      ),
    );
  }
}
