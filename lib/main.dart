import 'package:flutter/material.dart';

// Suas telas (login + fluxos auxiliares)
import 'package:flutter_app_fila_certa/views/home_view.dart';
import 'package:flutter_app_fila_certa/views/cadastro_view.dart';
import 'package:flutter_app_fila_certa/views/senha_view.dart';

// Dashboard na estrutura por features
import 'package:flutter_app_fila_certa/features/dashboard/dashboard_view.dart';

// Settings (tema, alto contraste, escala de texto) — necessários para a Dashboard
import 'package:flutter_app_fila_certa/app/settings_controller.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';

// Splash (tela de carregamento)
import 'package:flutter_app_fila_certa/views/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
}

///
/// MyApp: aplicação usando MaterialApp e rotas nomeadas.
/// Injetamos o SettingsScope via `builder` para que a Dashboard (e outras telas)
/// consigam acessar configurações globais mesmo usando MyApp.
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Controlador de configurações globais (tema, contraste, textScale etc.)
    final settings = SettingsController();

    return MaterialApp(
      title: 'Minha App',
      debugShowCheckedModeBanner: false,

      // A Splash passa a ser a primeira tela (REMOVIDO o segundo initialRoute duplicado)
      initialRoute: SplashView.routeName,

      // Rotas nomeadas do app
      routes: {
        SplashView.routeName: (_) => const SplashView(),
        HomeView.routeName: (_) => const HomeView(),
        CadastroView.routeName: (_) => const CadastroView(),
        SenhaView.routeName: (_) => const SenhaView(),
        DashboardView.routeName: (_) => const DashboardView(),
      },

      // Injeta o SettingsScope para toda a árvore criada pelo MaterialApp.
      // Isso evita erros na Dashboard ao acessar SettingsScope.of(context).
      builder: (context, child) {
        return SettingsScope(
          controller: settings,
          child: child ?? const SizedBox.shrink(),
        );
      },

      // Tema base; modos escuro/alto contraste e textScale são aplicados nas telas via SettingsScope.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6DD4)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
        ),
      ),
    );
  }
}