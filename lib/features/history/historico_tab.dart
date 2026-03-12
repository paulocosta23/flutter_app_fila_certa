import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';
import 'package:flutter_app_fila_certa/features/history/history_helpers.dart';
import 'package:flutter_app_fila_certa/features/history/history_models.dart';
import 'package:flutter_app_fila_certa/shared/data/mock_history.dart';
import 'package:flutter_app_fila_certa/shared/helpers/date_grouping.dart';
import 'package:flutter_app_fila_certa/shared/widgets/section_header.dart';

class HistoricoTab extends StatelessWidget {
  const HistoricoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textScale = SettingsScope.of(context).textScale;
    final items = sampleHistory();
    final grouped = groupByDate<HistoryItem>(items, (h) => h.dateTime);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        appBar: AppBar(title: const Text('Histórico')),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            ...grouped.entries.map((entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(text: entry.key),
                    const SizedBox(height: 8),
                    ...entry.value.map((h) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Icon(historyIcon(h.status), color: historyColor(context, h.status)),
                            title: Text(h.title),
                            subtitle: Text([
                              if (h.subtitle != null) h.subtitle!,
                              formatHour(h.dateTime),
                            ].join('\n')),
                            isThreeLine: true,
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}