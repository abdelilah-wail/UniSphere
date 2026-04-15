enum NotificationType { schedule, announcement, assignment, system }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType type;
    switch (json['type']) {
      case 'schedule':
        type = NotificationType.schedule;
        break;
      case 'announcement':
        type = NotificationType.announcement;
        break;
      case 'assignment':
        type = NotificationType.assignment;
        break;
      default:
        type = NotificationType.system;
    }

    return NotificationModel(
      id: json['_id'] ?? '',
      type: type,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }
}
