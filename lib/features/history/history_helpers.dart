import 'package:flutter/material.dart';
import 'history_models.dart';

IconData historyIcon(HistoryStatus s) {
  switch (s) {
    case HistoryStatus.done:
      return Icons.check_circle;
    case HistoryStatus.canceled:
      return Icons.cancel;
    case HistoryStatus.info:
      return Icons.info;
    case HistoryStatus.queued:
      return Icons.description;
  }
}

Color historyColor(BuildContext ctx, HistoryStatus s) {
  final cs = Theme.of(ctx).colorScheme;
  switch (s) {
    case HistoryStatus.done:
      return Colors.green;
    case HistoryStatus.canceled:
      return cs.error;
    case HistoryStatus.info:
      return cs.secondary;
    case HistoryStatus.queued:
      return cs.primary;
  }
}