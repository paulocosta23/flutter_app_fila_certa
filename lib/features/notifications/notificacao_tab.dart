import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';
import 'package:flutter_app_fila_certa/features/notifications/notification_helpers.dart';
import 'package:flutter_app_fila_certa/features/notifications/notification_models.dart';
import 'package:flutter_app_fila_certa/shared/data/mock_notifications.dart';
import 'package:flutter_app_fila_certa/shared/helpers/date_grouping.dart';
import 'package:flutter_app_fila_certa/shared/widgets/section_header.dart';

class NotificacaoTab extends StatefulWidget {
  const NotificacaoTab({super.key});

  @override
  State<NotificacaoTab> createState() => _NotificacaoTabState();
}

class _NotificacaoTabState extends State<NotificacaoTab> {
  late List<NotificationItem> _items;
  NotificationType? _filter;

  @override
  void initState() {
    super.initState();
    _items = sampleNotifications();
  }

  void _markAllRead() {
    setState(() {
      for (final n in _items) {
        n.isRead = true;
      }
    });
  }

  void _clearAll() => setState(() => _items.clear());

  String _labelType(NotificationType t) {
    switch (t) {
      case NotificationType.system:
        return 'Sistema';
      case NotificationType.alert:
        return 'Alertas';
      case NotificationType.queue:
        return 'Fila';
      case NotificationType.promo:
        return 'Promoções';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScale = SettingsScope.of(context).textScale;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notificações'),
          actions: [
            IconButton(
              tooltip: 'Marcar tudo como lido',
              onPressed: _items.isEmpty ? null : _markAllRead,
              icon: const Icon(Icons.done_all),
            ),
            IconButton(
              tooltip: 'Limpar todas',
              onPressed: _items.isEmpty ? null : _clearAll,
              icon: const Icon(Icons.delete_sweep),
            ),
          ],
        ),
        body: _buildCorporate(context),
      ),
    );
  }

  Widget _buildCorporate(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _filter == null ? _items : _items.where((n) => n.type == _filter).toList();
    final grouped = groupByDate<NotificationItem>(filtered, (n) => n.dateTime);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              const SizedBox(width: 6),
              ...NotificationType.values.map((t) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(_labelType(t)),
                      selected: _filter == t,
                      onSelected: (_) => setState(() => _filter = t),
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...grouped.entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(text: entry.key),
                const SizedBox(height: 8),
                ...entry.value.map((n) {
                  final subtleBg = !n.isRead ? cs.primary.withOpacity(0.06) : Colors.transparent;
                  return Container(
                    decoration: BoxDecoration(color: subtleBg, borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      dense: true,
                      leading: Icon(notificationIcon(n.type), color: notificationColor(context, n.type)),
                      title: Text(n.title),
                      subtitle: n.subtitle != null ? Text(n.subtitle!) : null,
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatHour(n.dateTime),
                            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(height: 4),
                          if (!n.isRead)
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle)),
                        ],
                      ),
                      onTap: () => setState(() => n.isRead = true),
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            )),
        if (grouped.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(child: Text('Sem notificações')),
          ),
      ],
    );
  }
}