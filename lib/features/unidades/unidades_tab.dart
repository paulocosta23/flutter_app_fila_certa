import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/features/unidades/unidades_data.dart';
import 'package:url_launcher/url_launcher.dart';

class UnidadesTab extends StatelessWidget {
  const UnidadesTab({super.key});

  // =========================
  // ABRIR ROTA
  // =========================
  Future<void> abrirRota(double lat, double lng) async {

    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Unidades de Saúde'),
      ),

      body: ListView.builder(

        itemCount: unidades.length,

        itemBuilder: (context, index) {

          final unidade = unidades[index];

          final fila = unidade['fila'] as int;

          Color statusColor;
          String statusTexto;

          // =========================
          // STATUS DA FILA
          // =========================
          if (fila <= 20) {

            statusColor = Colors.green;
            statusTexto = 'Baixa';

          } else if (fila <= 35) {

            statusColor = Colors.orange;
            statusTexto = 'Média';

          } else {

            statusColor = Colors.red;
            statusTexto = 'Alta';
          }

          return Card(

            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            child: ListTile(

              leading: Icon(
                Icons.local_hospital,
                color: statusColor,
              ),

              title: Text(
                unidade['nome'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Row(

                children: [

                  // =========================
                  // BOLINHA STATUS
                  // =========================
                  Container(
                    width: 12,
                    height: 12,

                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '$fila pessoas • Lotação $statusTexto',
                  ),
                ],
              ),

              trailing: Text(unidade['tempo']),

              // =========================
              // CLIQUE NA UNIDADE
              // =========================
              onTap: () {

                showDialog(

                  context: context,

                  builder: (_) {

                    return AlertDialog(

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      title: Text(
                        unidade['nome'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      content: Column(

                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // =========================
                          // FILA
                          // =========================
                          Row(
                            children: [

                              const Icon(
                                Icons.people,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                'Fila: ${unidade['fila']} pessoas',
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // =========================
                          // TEMPO
                          // =========================
                          Row(
                            children: [

                              const Icon(
                                Icons.access_time,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                'Tempo: ${unidade['tempo']}',
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // =========================
                          // LOTAÇÃO
                          // =========================
                          Row(
                            children: [

                              const Icon(
                                Icons.warning,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                'Lotação: $statusTexto',
                              ),

                              const SizedBox(width: 10),

                              Container(
                                width: 14,
                                height: 14,

                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // =========================
                          // ENDEREÇO
                          // =========================
                          Row(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Icon(
                                Icons.location_on,
                                size: 20,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  unidade['endereco'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      actions: [

  Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),

    child: Row(

      children: [

        // =========================
        // BOTÃO ROTA
        // =========================
        Expanded(
          child: ElevatedButton.icon(

            onPressed: () {

              abrirRota(
                unidade['lat'],
                unidade['lng'],
              );
            },

            icon: const Icon(Icons.route),

            label: const Text('Ver rota'),

            style: ElevatedButton.styleFrom(

              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // =========================
        // BOTÃO FECHAR
        // =========================
        Expanded(
          child: OutlinedButton(

            onPressed: () {
              Navigator.pop(context);
            },

            style: OutlinedButton.styleFrom(

              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            child: const Text('Fechar'),
          ),
        ),
      ],
    ),
  ),
],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}