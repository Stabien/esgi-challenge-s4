import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static FlutterSecureStorage get instance => _storage;

  SecureStorage._();

  static Future<String?> getStorageItem(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> addStorageItem(String key, dynamic value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> deleteStorageItem(String key) async {
    await _storage.delete(key: key);
  }
}
