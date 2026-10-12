# Клиент — Driver Diary (Flutter)

Описание проекта, архитектуры и API — в [корневом README](../README.md).

```bash
flutter pub get
flutter run -d windows            # или id эмулятора из `flutter devices`
```

Адрес backend задаётся в `.env` (шаблон — `.env.example`). Сгенерированный код лежит в репозитории, перегенерировать его нужно только после правок:

```bash
dart run build_runner build --delete-conflicting-outputs   # freezed, env.g.dart
dart run intl_utils:generate                               # строки локализации
dart run tool/generate_api.dart                            # API-клиент из swaggers/driver_diary.json
```

Тесты и покрытие:

```bash
flutter analyze
flutter test --coverage
dart run tool/coverage.dart [--min=90] [--all]
```
