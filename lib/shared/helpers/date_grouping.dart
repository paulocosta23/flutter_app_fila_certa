String groupLabel(DateTime now, DateTime dt) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(dt.year, dt.month, dt.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Ontem';
  if (diff < 7) return 'Nesta semana';
  return 'Anteriores';
}

String formatHour(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

Map<String, List<T>> groupByDate<T>(
  List<T> items,
  DateTime Function(T) getDate,
) {
  final now = DateTime.now();
  final sorted = [...items]..sort((a, b) => getDate(b).compareTo(getDate(a)));
  final Map<String, List<T>> grouped = {};
  for (final item in sorted) {
    final label = groupLabel(now, getDate(item));
    grouped.putIfAbsent(label, () => []).add(item);
  }
  return grouped;
}