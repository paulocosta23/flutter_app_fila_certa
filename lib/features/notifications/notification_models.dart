enum NotificationType { system, alert, queue, promo }

class NotificationItem {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime dateTime;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dateTime,
    required this.type,
    this.isRead = false,
  });
}