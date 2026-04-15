import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // ─── Save token ──────────────────────────────
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // ─── Get token ───────────────────────────────
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // ─── Delete token (logout) ───────────────────
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ─── Check if logged in ─────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
