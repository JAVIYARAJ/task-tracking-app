
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeNotifier extends ChangeNotifier {

  SharedPreferences? sharedPreferences;
  bool? _darkTheme;
  int? _taskColor;
  String? _appLanguageName;
  String _filterTagName = "createdAt";

  final String _themeKey = "dark";
  final String _taskColorKey="taskColor";
  final String _taskFilterTagKey="taskFilterTag";
  final String _appLanguageKey="appLanguage";

  ThemeNotifier() {
    _darkTheme = false;
    loadDataFromSharedPref();
  }

  int get taskColor=>_taskColor ?? 0XFFFFD180;
  setColor(int color){
    _taskColor=color;
    saveDataIntoSharedPref();
    notifyListeners();
  }


  bool? get darkTheme => _darkTheme;
  toggleTheme() {
    _darkTheme = !_darkTheme!;
    saveDataIntoSharedPref();
    notifyListeners();
  }


  String? get filterTagName => _filterTagName;
  setFilterTagName(String tag) {
    _filterTagName = tag;
    saveDataIntoSharedPref();
    notifyListeners();
  }

  String? get appLanguageName=>_appLanguageName;

  setLanguageName(String language){
    _appLanguageName=language;
    saveDataIntoSharedPref();
    notifyListeners();
  }

  initSharedPreference() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
  }

  loadDataFromSharedPref() async {
    await initSharedPreference();
    _darkTheme = sharedPreferences?.getBool(_themeKey) ?? true;
    _taskColor= sharedPreferences?.getInt(_taskColorKey);
    _filterTagName=sharedPreferences?.getString(_taskFilterTagKey) ?? "id";
    _appLanguageName=sharedPreferences?.getString(_appLanguageKey) ?? "en";
    notifyListeners();
  }

  saveDataIntoSharedPref() async {
    await initSharedPreference();
    sharedPreferences?.setBool(_themeKey, _darkTheme!);
    sharedPreferences?.setInt(_taskColorKey, _taskColor!);
    sharedPreferences?.setString(_taskFilterTagKey,_filterTagName);
    sharedPreferences?.setString(_appLanguageKey, _appLanguageName!);
  }

}
