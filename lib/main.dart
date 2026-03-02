import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/cadastro_view.dart';
import 'views/senha_view.dart';
import 'views/dashboard_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6DD4)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: HomeView.routeName,
      routes: {
        HomeView.routeName: (_) => const HomeView(),
        CadastroView.routeName: (_) => const CadastroView(),
        SenhaView.routeName: (_) => const SenhaView(),
        DashboardView.routeName: (_) => const DashboardView(),

      },
    );
  }
}