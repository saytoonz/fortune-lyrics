import 'package:acr_cloud_sdk_example/core/providers.dart';
import 'package:acr_cloud_sdk_example/utils/log.dart';
import 'package:acr_cloud_sdk_example/utils/pref_keys.dart';
import 'package:acr_cloud_sdk_example/utils/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/theme.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  Log.init(kReleaseMode);
  runApp(ProviderScope(child: MyApp(pref: pref)));
}

class MyApp extends StatefulHookWidget {
  MyApp({this.pref});

  final SharedPreferences? pref;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    bool? savedMode = widget.pref?.getBool(SETTINGS_THEME_MODE);
    if (savedMode == null)
      context.read(themeVVM).setThemeMode = ThemeMode.system;
    else if (savedMode)
      context.read(themeVVM).setThemeMode = ThemeMode.dark;
    else
      context.read(themeVVM).setThemeMode = ThemeMode.light;

    overrideDeviceColors(context);
    return MaterialApp(
      title: 'SoundCheck',
      debugShowCheckedModeBanner: false,
      themeMode: useProvider(themeVVM.select((v) => v.themeMode)),
      darkTheme: MyThems.darkTheme,
      theme: MyThems.lightTheme,
      home: HomePage(widget.pref!),
    );
  }
}
