import 'package:flutter/material.dart';
import 'notification_models.dart';

IconData notificationIcon(NotificationType t) {
  switch (t) {
    case NotificationType.system:
      return Icons.settings;
    case NotificationType.alert:
      return Icons.warning_amber_rounded;
    case NotificationType.queue:
      return Icons.notifications_active;
    case NotificationType.promo:
      return Icons.card_giftcard;
  }
}

Color notificationColor(BuildContext ctx, NotificationType t) {
  final cs = Theme.of(ctx).colorScheme;
  switch (t) {
    case NotificationType.system:
      return cs.secondary;
    case NotificationType.alert:
      return cs.error;
    case NotificationType.queue:
      return cs.primary;
    case NotificationType.promo:
      return Colors.purpleAccent;
  }
}