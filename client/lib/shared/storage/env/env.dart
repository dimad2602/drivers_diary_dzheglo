import 'package:envied/envied.dart';

part 'env.g.dart';

/// Значения из `.env` (шаблон — `.env.example`). Генерируется командой
/// `dart run build_runner build --delete-conflicting-outputs`.
// randomSeed фиксирует обфускацию, чтобы env.g.dart не менялся при каждой генерации.
@Envied(path: '.env', randomSeed: 2026)
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _Env.baseUrl;
}
