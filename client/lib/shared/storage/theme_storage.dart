import 'package:driver_diary/shared/storage/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  const ThemeStorage(this._prefs);

  final SharedPreferences _prefs;

  ThemeMode load() {
    final name = _prefs.getString(Constants.themeModeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> save(ThemeMode mode) =>
      _prefs.setString(Constants.themeModeKey, mode.name);
}
