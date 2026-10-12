import 'dart:ui';

/// Язык интерфейса. [system] следует языку устройства.
enum AppLanguage {
  system(null),
  ru(Locale('ru')),
  en(Locale('en'));

  const AppLanguage(this.locale);

  /// `null` для [system]: MaterialApp сам подберёт поддерживаемый язык устройства.
  final Locale? locale;

  static AppLanguage fromName(String? name) =>
      values.firstWhere((l) => l.name == name, orElse: () => system);
}
