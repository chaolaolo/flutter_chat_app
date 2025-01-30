import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //init, light mode
  ThemeData _themeData = lightMode;

  //get theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == lightMode;

  // set theme
  set themData(ThemeData themeData) {
    _themeData = themeData;
    // update UI
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themData = lightMode;
    } else {
      themData = lightMode;
    }
  }
}
