import 'package:fastlyrics/providers/theme_provider.dart';
import 'package:fastlyrics/utils/pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences pref;
  SettingsPage({Key key, this.pref}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

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
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
                widget.pref.setBool(SETTINGS_THEME_MODE, value);
              },
            ),
            onLongPress: () {
              themeProvider.toggleTheme(null);
              widget.pref.remove(SETTINGS_THEME_MODE);
            },
          ),
        ],
      ),
    );
  }
}
