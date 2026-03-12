import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/app_theme.dart';
import 'package:flutter_app_fila_certa/app/settings_controller.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';
import 'package:flutter_app_fila_certa/features/dashboard/dashboard_view.dart';
import 'package:flutter_app_fila_certa/views/home_view.dart';

class FilaCertaApp extends StatelessWidget {
  const FilaCertaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final theme = buildTheme(
          darkMode: controller.darkMode,
          highContrast: controller.highContrast,
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          initialRoute: HomeView.routeName,
          routes: {
            HomeView.routeName: (_) => const HomeView(),
            DashboardView.routeName: (_) => const DashboardView(),
          },
          // Injeta o SettingsScope para toda a árvore
          builder: (context, child) =>
              SettingsScope(controller: controller, child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
