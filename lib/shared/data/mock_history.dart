import 'package:flutter_app_fila_certa/features/history/history_models.dart';

List<HistoryItem> sampleHistory() {
  final now = DateTime.now();
  return [
    HistoryItem(
      id: 'h1',
      title: 'Atendimento concluído',
      subtitle: 'UPA • Guichê 03',
      dateTime: now.subtract(const Duration(hours: 1)),
      status: HistoryStatus.done,
    ),
    HistoryItem(
      id: 'h2',
      title: 'Cancelou entrada na fila',
      subtitle: 'Unidade Saúde - Umarizal',
      dateTime: now.subtract(const Duration(days: 1, hours: 2)),
      status: HistoryStatus.canceled,
    ),
    HistoryItem(
      id: 'h3',
      title: 'Dados do perfil atualizados',
      subtitle: 'E-mail e telefone',
      dateTime: now.subtract(const Duration(days: 2, hours: 3)),
      status: HistoryStatus.info,
    ),
    HistoryItem(
      id: 'h4',
      title: 'Entrou na fila',
      subtitle: 'Cartório Belém • senha C-142',
      dateTime: now.subtract(const Duration(days: 3, hours: 5)),
      status: HistoryStatus.queued,
    ),
  ];
}