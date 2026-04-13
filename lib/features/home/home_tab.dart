import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =======================
// WIDGET PRINCIPAL (HOME)
// =======================
class HomeTab extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenNotifications;

  const HomeTab({
    super.key,
    required this.onOpenSettings,
    required this.onOpenNotifications,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

// =======================
// ESTADO DA HOME
// =======================
class _HomeTabState extends State<HomeTab> {
  static const _bgUrl =
      'https://admin.cnnbrasil.com.br/wp-content/uploads/sites/12/2024/02/google-maps-e1707316052388.png?w=1200&h=900&crop=0';

  String? unidadeSelecionada;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // =======================
            // IMAGEM DE FUNDO
            // =======================
            Positioned.fill(
              child: Image.network(
                _bgUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null
                        ? child
                        : Container(
                            color: cs.surfaceVariant.withOpacity(0.4),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
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
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // =======================
            // OVERLAY ESCURO
            // =======================
            Positioned.fill(
              child: Container(
                color: cs.surface.withOpacity(0.20),
              ),
            ),

            // =======================
            // BARRA DE PESQUISA
            // =======================
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Row(
                      children: [
                        // Campo de pesquisa
                        Expanded(
                          child: TextField(
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Pesquisar...",
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              prefixIcon:
                                  const Icon(Icons.search, size: 18),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  width: 1.8,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Botão de notificação
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF03557A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: widget.onOpenNotifications,
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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