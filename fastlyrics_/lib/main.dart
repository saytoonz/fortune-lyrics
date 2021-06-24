import 'package:fastlyrics/app.dart';
import 'package:fastlyrics/providers/home_vm.dart';
import 'package:fastlyrics/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ],
    child: MyApp(pref: pref),
  ));
}
