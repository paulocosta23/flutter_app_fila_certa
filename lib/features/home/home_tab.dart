import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onOpenSettings;
  const HomeTab({super.key, required this.onOpenSettings});

  static const _bgUrl =
      'https://admin.cnnbrasil.com.br/wp-content/uploads/sites/12/2024/02/google-maps-e1707316052388.png?w=1200&h=900&crop=0';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Configurações',
          icon: const Icon(Icons.settings),
          onPressed: onOpenSettings,
        ),
        title: const Text("FILA CERTA"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.network(
              _bgUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
                  progress == null
                      ? child
                      : Container(
                          color: cs.surfaceVariant.withOpacity(0.4),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
              errorBuilder: (_, __, ___) => Container(
                color: cs.surfaceVariant.withOpacity(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Não foi possível carregar a imagem de fundo',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: cs.surface.withOpacity(0.25)),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Pesquisar...",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              
            ],
          ),
        ],
      ),
    );
  }
}