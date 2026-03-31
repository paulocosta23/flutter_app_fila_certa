import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onOpenSettings;

  const HomeTab({super.key, required this.onOpenSettings});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  static const _bgUrl =
      'https://admin.cnnbrasil.com.br/wp-content/uploads/sites/12/2024/02/google-maps-e1707316052388.png?w=1200&h=900&crop=0';

  String? unidadeSelecionada;

  final List<String> unidades = [
    'UPA Guamá',
    'UPA Jurunas',
    'UPA Sacramenta',
    'UPA Icoaraci',
  ];

  final Map<String, Map<String, dynamic>> upaInfo = {
    'UPA Guamá': {'fila': 23, 'tempo': '35 min'},
    'UPA Jurunas': {'fila': 15, 'tempo': '20 min'},
    'UPA Sacramenta': {'fila': 30, 'tempo': '50 min'},
    'UPA Icoaraci': {'fila': 10, 'tempo': '15 min'},
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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
              child: Container(color: cs.surface.withOpacity(0.20)),
            ),

            // ===== BARRA DE PESQUISA =====
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
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
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ===== BOTÃO DE UNIDADES =====
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 55, left: 14),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF03557A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.local_hospital),
                      label: Text(
                        unidadeSelecionada ?? "Unidades de Saúde",
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ListView(
                              children: unidades.map((unidade) {
                                final isSelected = unidade == unidadeSelecionada;

                                return ListTile(
                                  title: Text(unidade),
                                  trailing: isSelected
                                      ? const Icon(Icons.check, color: Colors.green)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      unidadeSelecionada = unidade;
                                    });

                                    Navigator.pop(context);

                                    final info = upaInfo[unidade]!;
                                    final fila = info['fila'] as int;

                                    Color statusColor;
                                    String statusText;

                                    if (fila <= 10) {
                                      statusColor = Colors.green;
                                      statusText = "Baixa";
                                    } else if (fila <= 20) {
                                      statusColor = Colors.orange;
                                      statusText = "Média";
                                    } else {
                                      statusColor = Colors.red;
                                      statusText = "Alta";
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Text(
                                                    '$unidade - URGÊNCIA E EMERGÊNCIA',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 4),

                                                  const Text(
                                                    'Atualizado há 3 min',
                                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                                  ),

                                                  const SizedBox(height: 16),

                                                  // 🔥 NOVO ESTILO
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF03557A),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '👥 PESSOAS AGUARDANDO: $fila',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 16),

                                                  Row(
                                                    children: [
                                                      const Icon(Icons.access_time, size: 18),
                                                      const SizedBox(width: 6),
                                                      Text('Tempo de espera: ${info['tempo']}'),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 8),

                                                  Row(
                                                    children: [
                                                      const Icon(Icons.bar_chart, size: 18),
                                                      const SizedBox(width: 6),
                                                      Text('Lotação: $statusText'),
                                                      const SizedBox(width: 10),
                                                      _bolinha(Colors.green, destaque: statusText == "Baixa"),
                                                      _bolinha(Colors.orange, destaque: statusText == "Média"),
                                                      _bolinha(Colors.red, destaque: statusText == "Alta"),
                                                    ],
                                                  ),

                                                  const Divider(height: 24),

                                                  const Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.location_on, size: 18),
                                                      SizedBox(width: 6),
                                                      Expanded(
                                                        child: Text('Av. Dr. Freitas, 860, Belém - PA'),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 8),

                                                  const Row(
                                                    children: [
                                                      Icon(Icons.access_time_filled, size: 18),
                                                      SizedBox(width: 6),
                                                      Text('Funcionamento: 24h'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ===== BOTÃO CONFIG =====
            // SafeArea(
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 8, right: 8),
            //       child: DecoratedBox(
            //         decoration: BoxDecoration(
            //           color: const Color(0xFF03557A).withOpacity(0.90),
            //           shape: BoxShape.circle,
            //         ),
            //         child: IconButton(
            //           tooltip: 'Configurações',
            //           onPressed: () {
            //             widget.onOpenSettings();
            //           },
            //           icon: const Icon(Icons.settings, color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // 🔥 BOLINHA COM DESTAQUE
  Widget _bolinha(Color cor, {bool destaque = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      width: destaque ? 18 : 10,
      height: destaque ? 18 : 10,
      decoration: BoxDecoration(
        color: cor,
        shape: BoxShape.circle,
        boxShadow: destaque
            ? [
                BoxShadow(
                  color: cor.withOpacity(0.6),
                  blurRadius: 6,
                ),
              ]
            : [],
      ),
    );
  }
}