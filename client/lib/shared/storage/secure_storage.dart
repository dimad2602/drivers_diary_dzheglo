import 'package:driver_diary/shared/storage/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Обёртка над [FlutterSecureStorage] для секретов (сейчас — только API-ключ).
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Ошибка чтения (например, испорченное хранилище) не должна ронять приложение —
  /// считаем, что ключ не задан.
  Future<String?> readApiKey() async {
    try {
      return await _storage.read(key: Constants.apiKeyStorageKey);
    } catch (e) {
      debugPrint('SecureStorage: не удалось прочитать ключ: $e');
      return null;
    }
  }

  Future<void> saveApiKey(String value) =>
      _storage.write(key: Constants.apiKeyStorageKey, value: value);

  Future<void> deleteApiKey() =>
      _storage.delete(key: Constants.apiKeyStorageKey);
}
