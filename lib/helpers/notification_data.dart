import '../models/notification_model.dart';

List<NotificationModel> getSampleNotifications() {
  final now = DateTime.now();
  return [
    NotificationModel(
      id: '1',
      type: NotificationType.schedule,
      title: 'Class Rescheduled',
      description: 'Digital Marketing moved to Room 3A - G4 at 2:00 PM today.',
      timestamp: now.subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      id: '2',
      type: NotificationType.announcement,
      title: 'Exam Schedule Released',
      description: 'Final exam schedule for S2024 is now available. Check the Result tab.',
      timestamp: now.subtract(const Duration(minutes: 32)),
    ),
    NotificationModel(
      id: '3',
      type: NotificationType.assignment,
      title: 'Assignment Due Tomorrow',
      description: 'Computer Science — Data Structures assignment deadline is tomorrow 11:59 PM.',
      timestamp: now.subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '4',
      type: NotificationType.system,
      title: 'App Update Available',
      description: 'Version 2.1.0 is available with new features and bug fixes.',
      timestamp: now.subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      type: NotificationType.announcement,
      title: 'Holiday Notice',
      description: 'Campus will be closed on Friday for Independence Day celebrations.',
      timestamp: now.subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      type: NotificationType.schedule,
      title: 'New Class Added',
      description: 'Physics Lab has been added to your Wednesday schedule at 3:00 PM.',
      timestamp: now.subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];
}
