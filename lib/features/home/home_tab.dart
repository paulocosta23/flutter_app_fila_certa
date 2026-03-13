import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onOpenSettings;
  const HomeTab({super.key, required this.onOpenSettings});

  static const _bgUrl =
      'https://admin.cnnbrasil.com.br/wp-content/uploads/sites/12/2024/02/google-maps-e1707316052388.png?w=1200&h=900&crop=0';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // mude para .dark se o topo estiver claro
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ===== Imagem de fundo =====
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

            // ===== Overlay sutil =====
            Positioned.fill(
              child: Container(color: cs.surface.withOpacity(0.20)),
            ),

            // ===== Barra de busca (topo, centralizada, compacta) =====
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft, // alinhamento da aba de pesquisa .topLeft (a esqueda), .topCenter (centro), .topRigth (a direita)
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: TextField(
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Pesquisar...",
                        isDense: true,
                        filled: true,
                        fillColor: const Color.fromARGB(253, 255, 254, 254).withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

                        prefixIcon: const Icon(Icons.search, size: 18),
                        prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),

                        // ==== Bordas (todas dentro do InputDecoration) ====
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 8, 80, 139),
                            width: 1.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 3, 85, 122),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.8,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: 1.2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: 1.8,
                          ),
                        ),
                      ),
                      // Opcional: deixa o alvo de toque menor que 48px
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
            ),

            // ===== Outros conteúdos abaixo da busca (exemplo) =====
            // Você pode adicionar uma ListView aqui, com padding top alto
            // caso deseje conteúdo rolável.

            // ===== Botão de configurações (por último => acima de tudo) =====
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF03557A).withOpacity(0.90),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      tooltip: 'Configurações',
                      onPressed: () {
                        debugPrint('Abrir configurações');
                        onOpenSettings();
                      },
                      icon: const Icon(Icons.settings, color: Colors.white),
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