import 'api_service.dart';

class UserService {
  // ─── Get current user profile ─────────────────────
  static Future<Map<String, dynamic>> getProfile() async {
    return await ApiService.get('/users/profile');
  }

  // ─── Update profile (partial update supported) ────
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? avatar,
    int? yearLevel,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? privacy,
  }) async {
    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (avatar != null) body['avatar'] = avatar;
    if (yearLevel != null) body['yearLevel'] = yearLevel;
    if (preferences != null) body['preferences'] = preferences;
    if (privacy != null) body['privacy'] = privacy;

    return await ApiService.put('/users/profile', body: body);
  }

  // ─── Change password ──────────────────────────────
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await ApiService.put('/users/password', body: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }
}
