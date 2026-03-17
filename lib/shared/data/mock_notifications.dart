import 'package:flutter_app_fila_certa/features/notifications/notification_models.dart';

List<NotificationItem> sampleNotifications() {
  final now = DateTime.now();
  return [
    NotificationItem(
      id: 'n1',
      title: 'Sua vez está chegando!',
      subtitle: 'Fila: UPA • 4 pessoas à frente',
      dateTime: now.subtract(const Duration(minutes: 10)),
      type: NotificationType.queue,
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Documento pendente',
      subtitle: 'Atualize seus dados no perfil.',
      dateTime: now.subtract(const Duration(hours: 3)),
      type: NotificationType.alert,
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Manutenção concluída',
      subtitle: 'Serviços normalizados.',
      dateTime: now.subtract(const Duration(days: 1, hours: 2)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Nova unidade adicionada',
      subtitle: 'Cartório Centro já disponível.',
      dateTime: now.subtract(const Duration(days: 2, hours: 5)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Desconto exclusivo',
      subtitle: 'Agende hoje e ganhe prioridade.',
      dateTime: now.subtract(const Duration(days: 6)),
      type: NotificationType.promo,
      isRead: true,
    ),
  ];
}