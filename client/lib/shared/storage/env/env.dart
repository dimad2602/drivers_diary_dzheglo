import 'package:envied/envied.dart';

part 'env.g.dart';

/// Значения из `.env` (шаблон — `.env.example`). Генерируется командой
/// `dart run build_runner build --delete-conflicting-outputs`.
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}
