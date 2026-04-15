import 'api_service.dart';

class NotificationService {
  // ─── Get notifications + unread count ────────────
  static Future<Map<String, dynamic>> getNotifications() async {
    return await ApiService.get('/notifications');
  }

  // ─── Mark one as read ──────────────────────────
  static Future<Map<String, dynamic>> markAsRead(String id) async {
    return await ApiService.put('/notifications/$id/read');
  }

  // ─── Mark all as read ──────────────────────────
  static Future<Map<String, dynamic>> markAllAsRead() async {
    return await ApiService.put('/notifications/read-all');
  }
}
