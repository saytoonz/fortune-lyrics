import 'package:acr_cloud_sdk_example/core/providers.dart';
import 'package:acr_cloud_sdk_example/utils/pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulHookWidget {
  final SharedPreferences pref;
  SettingsPage(this.pref);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = useProvider(themeVVM.select((value) => value.isDarkMode));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text("Settings"),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Night Mode"),
            subtitle: Text("Display a dark background at night"),
            trailing: Switch.adaptive(
              value: isDarkMode,
              onChanged: (value) {
                context.read(themeVVM).toggleTheme(value);
                widget.pref.setBool(SETTINGS_THEME_MODE, value);
              },
            ),
            onLongPress: () {
              context.read(themeVVM).toggleTheme(null);
              widget.pref.remove(SETTINGS_THEME_MODE);
            },
          ),
        ],
      ),
    );
  }
}
