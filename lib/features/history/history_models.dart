enum HistoryStatus { done, canceled, info, queued }

class HistoryItem {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime dateTime;
  final HistoryStatus status;

  HistoryItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dateTime,
    required this.status,
  });
}