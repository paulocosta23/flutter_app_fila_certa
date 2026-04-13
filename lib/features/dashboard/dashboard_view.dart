import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/app_theme.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';

import 'package:flutter_app_fila_certa/features/home/home_tab.dart';

import 'package:flutter_app_fila_certa/features/notifications/notificacao_tab.dart';
import 'package:flutter_app_fila_certa/features/profile/perfil_tab.dart';
import 'package:flutter_app_fila_certa/features/settings/settings_view.dart';
import 'package:flutter_app_fila_certa/features/unidades/unidades_tab.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  // ======================
  // ABRIR CONFIGURAÇÕES
  // ======================
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

  // ======================
  // ABRIR NOTIFICAÇÕES
  // ======================
  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificacaoTab()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);

    final theme = buildTheme(
      darkMode: settings.darkMode,
      highContrast: settings.highContrast,
    );

    // ======================
    // PÁGINAS (APENAS ABAS)
    // ======================
    final pages = <Widget>[
      HomeTab(
        onOpenSettings: _openSettings,
        onOpenNotifications: _openNotifications,
      ),
       const UnidadesTab(),
       const PerfilTab(),
    ];

    return Theme(
      data: theme,
      child: Scaffold(
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: settings.textScale,
          ),
          child: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
        ),

        // ======================
        // MENU INFERIOR
        // ======================
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,

          onTap: (i) {
            // Configurações (não é aba)
            if (i == 3) {
              _openSettings();
              return;
            }

            setState(() => _currentIndex = i);
          },

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital),
              label: 'Unidades',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}