import 'package:driver_diary/shared/storage/secure_storage.dart';

/// API-ключ приложения: сохранённый пользователем или ключ по умолчанию из `.env`.
class ApiKeyStore {
  const ApiKeyStore(this._secureStorage, {required this.defaultKey});

  final SecureStorage _secureStorage;
  final String defaultKey;

  Future<String> read() async {
    final saved = await _secureStorage.readApiKey();
    return (saved == null || saved.isEmpty) ? defaultKey : saved;
  }

  Future<void> save(String key) => _secureStorage.saveApiKey(key.trim());

  /// Возвращает ключ по умолчанию из `.env`.
  Future<void> reset() => _secureStorage.deleteApiKey();
}
