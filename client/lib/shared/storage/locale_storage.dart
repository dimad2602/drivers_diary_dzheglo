import 'package:driver_diary/app/l10n/app_language.dart';
import 'package:driver_diary/shared/storage/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  const LocaleStorage(this._prefs);

  final SharedPreferences _prefs;

  AppLanguage load() =>
      AppLanguage.fromName(_prefs.getString(Constants.languageKey));

  Future<void> save(AppLanguage language) =>
      _prefs.setString(Constants.languageKey, language.name);
}
