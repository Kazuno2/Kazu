import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  KazuThemeType _currentTheme = KazuThemeType.midnightBloom;
  ThemeMode _themeMode = ThemeMode.dark;

  KazuThemeType get currentTheme => _currentTheme;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void setThemeType(KazuThemeType theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void toggleThemeMode() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  String get themeName {
    switch (_currentTheme) {
      case KazuThemeType.midnightBloom:
        return 'Midnight Bloom';
      case KazuThemeType.midnightOcean:
        return 'Midnight Ocean';
      case KazuThemeType.crimsonInferno:
        return 'Crimson Inferno';
    }
  }
}

