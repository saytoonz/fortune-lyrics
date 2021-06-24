import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  set setThemeMode(ThemeMode mode) => themeMode = mode;

  void toggleTheme(bool? isOn) {
    themeMode = isOn != null
        ? isOn
            ? ThemeMode.dark
            : ThemeMode.light
        : ThemeMode.system;
    notifyListeners();
  }
}
