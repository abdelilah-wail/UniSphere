import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  // ─── Register ────────────────────────────────────
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? studentId,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };

    if (studentId != null && studentId.isNotEmpty) {
      body['studentId'] = studentId;
    }

    final response = await ApiService.post(
      '/auth/register',
      body: body,
      auth: false, // No token needed for registration
    );

    // Save the JWT token
    if (response.containsKey('token')) {
      await StorageService.saveToken(response['token']);
    }

    return response;
  }

  // ─── Login ───────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      auth: false, // No token needed for login
    );

    // Save the JWT token
    if (response.containsKey('token')) {
      await StorageService.saveToken(response['token']);
    }

    return response;
  }

  // ─── Logout ──────────────────────────────────────
  static Future<void> logout() async {
    await StorageService.deleteToken();
  }
}
