import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/app_theme.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';
import 'package:flutter_app_fila_certa/features/history/historico_tab.dart';
import 'package:flutter_app_fila_certa/features/home/home_tab.dart';
import 'package:flutter_app_fila_certa/features/notifications/notificacao_tab.dart';
import 'package:flutter_app_fila_certa/features/profile/perfil_tab.dart';
import 'package:flutter_app_fila_certa/features/settings/settings_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  static const routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsView()),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações atualizadas!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    final theme = buildTheme(
      darkMode: settings.darkMode,
      highContrast: settings.highContrast,
    );

    final pages = <Widget>[
      HomeTab(onOpenSettings: _openSettings),
      const PerfilTab(),
      const NotificacaoTab(),
      const HistoricoTab(),
    ];

    return Theme(
      data: theme,
      child: Scaffold(
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: settings.textScale),
          // IndexedStack mantém estado das abas
          child: IndexedStack(index: _currentIndex, children: pages),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          selectedFontSize: 12,
          unselectedFontSize: 13,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificação'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
          ],
        ),
      ),
    );
  }
}