import 'package:flutter/material.dart';

enum KazuThemeType {
  midnightBloom,
  midnightOcean,
  crimsonInferno,
}

class AppPillarColors {
  // T-Pillars: 3 semantic shades (none / partial / complete)
  // T1: Self-Trust (Soft Honey / Warm Amber / Deep Golden Ochre)
  static const Color t1None = Color(0xFFFDE8BB);
  static const Color t1Partial = Color(0xFFE89A3C);
  static const Color t1Complete = Color(0xFFB56A15);

  // T2: Body, Health, and Strength (Warm Peach/Clay / Terracotta / Burnt Sienna)
  static const Color t2None = Color(0xFFFFD1BA);
  static const Color t2Partial = Color(0xFFE07A5F);
  static const Color t2Complete = Color(0xFFA63A22);

  // T3: Anxiety and Emotional Regulation (Seafoam Mint / Ocean Teal / Deep Eucalyptus)
  static const Color t3None = Color(0xFFC7EDE6);
  static const Color t3Partial = Color(0xFF45A29E);
  static const Color t3Complete = Color(0xFF1F6E68);

  // T4: Responsibility and Discipline (Soft Lavender-Grey / Deep Plum / Midnight Eggplant)
  static const Color t4None = Color(0xFFDED8E8);
  static const Color t4Partial = Color(0xFF7A4B82);
  static const Color t4Complete = Color(0xFF432349);

  // T5: Confidence and Self-Advocacy (Apricot Glow / Rust Orange / Fiery Copper)
  static const Color t5None = Color(0xFFFFDAC1);
  static const Color t5Partial = Color(0xFFE76F51);
  static const Color t5Complete = Color(0xFFBA4224);

  // T6: Faith, Purpose, and Values (Lilac Mist / Celestial Violet / Royal Violet)
  static const Color t6None = Color(0xFFEADBFA);
  static const Color t6Partial = Color(0xFF8F5FD9);
  static const Color t6Complete = Color(0xFF56269E);

  // C-Pillars (Origami star identities)
  static const Color c1Decision = Color(0xFF1E3A8A); // Navy Blue
  static const Color c2Jealousy = Color(0xFF236A3C); // Forest Green
  static const Color c3Past = Color(0xFF4A4E69); // Dark Grey/Slate
  static const Color c4Trust = Color(0xFFE5B80B); // Golden Yellow
  static const Color c5Insecurity = Color(0xFF9E9E9E); // Light Grey
  static const Color c6Independence = Color(0xFFE05780); // Pink
}

class AppThemes {
  // Midnight Bloom (Pink, Lavender, Plum)
  static ThemeData midnightBloomDark() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFD980F2),
      primaryContainer: const Color(0xFF59206A),
      secondary: const Color(0xFFBA68C8),
      secondaryContainer: const Color(0xFF381545),
      surface: const Color(0xFF161020),
      surfaceContainer: const Color(0xFF221932),
      background: const Color(0xFF0F0B17),
      textPrimary: const Color(0xFFF6EEFB),
      textSecondary: const Color(0xFFBBABC7),
      accent: const Color(0xFFFF85A1),
    );
  }

  static ThemeData midnightBloomLight() {
    return _buildTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF9333A8),
      primaryContainer: const Color(0xFFF3E5F5),
      secondary: const Color(0xFF7B1FA2),
      secondaryContainer: const Color(0xFFFCE4EC),
      surface: const Color(0xFFFFFFFF),
      surfaceContainer: const Color(0xFFF7F1FB),
      background: const Color(0xFFFAF7FD),
      textPrimary: const Color(0xFF241530),
      textSecondary: const Color(0xFF6B5878),
      accent: const Color(0xFFD81B60),
    );
  }

  // Midnight Ocean (Navy, Blue, Cyan)
  static ThemeData midnightOceanDark() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF64B5F6),
      primaryContainer: const Color(0xFF153B66),
      secondary: const Color(0xFF4DD0E1),
      secondaryContainer: const Color(0xFF0D323A),
      surface: const Color(0xFF0F1826),
      surfaceContainer: const Color(0xFF162338),
      background: const Color(0xFF0A101A),
      textPrimary: const Color(0xFFEAF2FB),
      textSecondary: const Color(0xFF9FB2CB),
      accent: const Color(0xFF00E5FF),
    );
  }

  static ThemeData midnightOceanLight() {
    return _buildTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF1976D2),
      primaryContainer: const Color(0xFFE3F2FD),
      secondary: const Color(0xFF0097A7),
      secondaryContainer: const Color(0xFFE0F7FA),
      surface: const Color(0xFFFFFFFF),
      surfaceContainer: const Color(0xFFF0F6FC),
      background: const Color(0xFFF5F9FD),
      textPrimary: const Color(0xFF0F1E36),
      textSecondary: const Color(0xFF4E637F),
      accent: const Color(0xFF0288D1),
    );
  }

  // Crimson Inferno (Burgundy, Crimson, Coral)
  static ThemeData crimsonInfernoDark() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFFF6B6B),
      primaryContainer: const Color(0xFF5A141A),
      secondary: const Color(0xFFFF8E72),
      secondaryContainer: const Color(0xFF421B14),
      surface: const Color(0xFF1F1113),
      surfaceContainer: const Color(0xFF2C181B),
      background: const Color(0xFF150A0B),
      textPrimary: const Color(0xFFFDECEE),
      textSecondary: const Color(0xFFC7A2A6),
      accent: const Color(0xFFFF5252),
    );
  }

  static ThemeData crimsonInfernoLight() {
    return _buildTheme(
      brightness: Brightness.light,
      primary: const Color(0xFFC62828),
      primaryContainer: const Color(0xFFFFEBEE),
      secondary: const Color(0xFFD84315),
      secondaryContainer: const Color(0xFFFBE9E7),
      surface: const Color(0xFFFFFFFF),
      surfaceContainer: const Color(0xFFFDF2F3),
      background: const Color(0xFFFFF7F7),
      textPrimary: const Color(0xFF2B0E11),
      textSecondary: const Color(0xFF75494C),
      accent: const Color(0xFFE53935),
    );
  }

  static ThemeData getTheme({
    required KazuThemeType themeType,
    required bool isDark,
  }) {
    switch (themeType) {
      case KazuThemeType.midnightBloom:
        return isDark ? midnightBloomDark() : midnightBloomLight();
      case KazuThemeType.midnightOcean:
        return isDark ? midnightOceanDark() : midnightOceanLight();
      case KazuThemeType.crimsonInferno:
        return isDark ? crimsonInfernoDark() : crimsonInfernoLight();
    }
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color primaryContainer,
    required Color secondary,
    required Color secondaryContainer,
    required Color surface,
    required Color surfaceContainer,
    required Color background,
    required Color textPrimary,
    required Color textSecondary,
    required Color accent,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: brightness == Brightness.dark ? const Color(0xFF1E0A28) : Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: textPrimary,
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: textPrimary,
      tertiary: accent,
      onTertiary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceContainer,
      onSurfaceVariant: textSecondary,
      outline: textSecondary.withAlpha(70),
      error: const Color(0xFFE57373),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      cardColor: surfaceContainer,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: textSecondary.withAlpha(35), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryContainer,
        elevation: 3,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
      ),
    );
  }
}

