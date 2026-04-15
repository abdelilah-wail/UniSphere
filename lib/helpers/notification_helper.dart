import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationHelper {
  static List<NotificationModel> notifications = [];
  static int unreadCount = 0;
  static bool _loaded = false;

  // ─── Fetch from API ───────────────────────────
  static Future<void> fetch() async {
    try {
      final data = await NotificationService.getNotifications();
      final list = data['notifications'] as List<dynamic>? ?? [];
      notifications = list.map((json) => NotificationModel.fromJson(json)).toList();
      unreadCount = data['unreadCount'] ?? 0;
      _loaded = true;
    } catch (e) {
      // Silently fail — notifications are non-critical
    }
  }

  // ─── Fetch only once (first screen that needs it) ───
  static Future<void> ensureLoaded() async {
    if (!_loaded) await fetch();
  }

  // ─── Mark one as read ─────────────────────────
  static Future<void> markAsRead(NotificationModel notif) async {
    if (notif.isRead) return;
    try {
      await NotificationService.markAsRead(notif.id);
      notif.isRead = true;
      unreadCount = unreadCount > 0 ? unreadCount - 1 : 0;
    } catch (e) {
      // Silently fail
    }
  }

  // ─── Mark all as read ─────────────────────────
  static Future<void> markAllAsRead() async {
    try {
      await NotificationService.markAllAsRead();
      for (var n in notifications) {
        n.isRead = true;
      }
      unreadCount = 0;
    } catch (e) {
      // Silently fail
    }
  }
}
