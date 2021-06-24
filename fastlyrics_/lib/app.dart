import 'package:fastlyrics/home_page.dart';
import 'package:fastlyrics/providers/theme_provider.dart';
import 'package:fastlyrics/utils/pref_keys.dart';
import 'package:fastlyrics/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences pref;
  MyApp({Key key, this.pref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = context.watch<ThemeProvider>();
    bool savedMode = pref.getBool(SETTINGS_THEME_MODE);
    if (savedMode == null)
      themeProvider.setThemeMode = ThemeMode.system;
    else if (savedMode)
      themeProvider.setThemeMode = ThemeMode.dark;
    else
      themeProvider.setThemeMode = ThemeMode.light;

    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: themeProvider.themeMode,
      darkTheme: MyThems.darkTheme,
      theme: MyThems.lightTheme,
      home: HomePage(pref: pref),
    );
  }
}
