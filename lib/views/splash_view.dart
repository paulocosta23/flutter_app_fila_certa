import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/views/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const routeName = '/splash';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // TODO: inicializações (prefs, serviços, checagem de sessão etc.)
    await Future.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;

    // Ex.: envia para a Home (login). Troque para DashboardView.routeName se quiser pular login quando já autenticado.
    Navigator.pushReplacementNamed(context, HomeView.routeName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fundo com gradiente (use ao menos 2 cores)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.surface,
                    cs.surfaceVariant.withOpacity(0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Conteúdo central (logo + loader) com fade
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo_semfundo.png',
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.6),
                    ),
                  ],
                ),
              ),
            ),

            // Mensagem no rodapé centralizada
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Carregando...',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
