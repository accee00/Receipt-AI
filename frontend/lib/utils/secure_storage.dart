import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._internal();

  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }
}
