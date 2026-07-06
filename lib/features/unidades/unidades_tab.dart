import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/features/unidades/unidades_data.dart';
import 'package:url_launcher/url_launcher.dart';

class UnidadesTab extends StatelessWidget {

  // =========================
  // FILTRO RECEBIDO DA DASHBOARD
  // =========================
  final String filtro;
  final Function(String) onFiltroChanged;

  const UnidadesTab({
    super.key,
    required this.filtro,
    required this.onFiltroChanged,
  });

  // =========================================================
  // ABRIR ROTA NO GOOGLE MAPS
  // =========================================================
  Future<void> abrirRota(
    double lat,
    double lng,
  ) async {

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

  // =========================================================
  // BOTÃO DE FILTRO
  // =========================================================
  // =========================================================
// BOTÃO DE FILTRO
// =========================================================
Widget _botaoFiltro(String texto) {

  final selecionado = filtro == texto;

  return GestureDetector(

    onTap: () {

      // ALTERA O FILTRO
      onFiltroChanged(texto);
    },

    child: Container(

      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),

      decoration: BoxDecoration(

        color:
            selecionado
                ? const Color(0xFF03557A)
                : Colors.white,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Text(

        texto,

        textAlign: TextAlign.center,

        style: TextStyle(

          fontWeight: FontWeight.w700,

          color:
              selecionado
                  ? Colors.white
                  : Colors.black87,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    // =========================================================
    // FILTRAR UNIDADES POR LOTAÇÃO
    // =========================================================
    final unidadesFiltradas =
        unidades.where((unidade) {

      final fila = unidade['fila'] as int;

      String status;

      // =========================
      // DEFINIR STATUS
      // =========================
      if (fila <= 20) {

        status = 'Baixa';

      } else if (fila <= 35) {

        status = 'Média';

      } else {

        status = 'Alta';
      }

      // =========================
      // MOSTRAR TODAS
      // =========================
      if (filtro == 'Todas') {
        return true;
      }

      // =========================
      // FILTRAR POR STATUS
      // =========================
      return status == filtro;

    }).toList();

    // =========================================================
    // TELA PRINCIPAL
    // =========================================================
    return Column(

      children: [

        // =====================================================
        // TOPO DA TELA
        // =====================================================
        Container(

          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            12,
          ),

          decoration: const BoxDecoration(

            color: Color(0xFF03557A),

            borderRadius: BorderRadius.only(

              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),

          child: SafeArea(

            bottom: false,

            child: Column(

              children: [

                // =============================================
                // TÍTULO + NOTIFICAÇÃO
                // =============================================
                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(

                      'Unidades',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),

                    // =========================================
                    // BOTÃO NOTIFICAÇÃO
                    // =========================================
                    Stack(

                      children: [

                        Container(

                          width: 48,
                          height: 48,

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(16),
                          ),

                          child: IconButton(

                            onPressed: () {},

                            icon: const Icon(
                              Icons.notifications_none,
                              color: Color(0xFF03557A),
                            ),
                          ),
                        ),

                        // =====================================
                        // BADGE
                        // =====================================
                        Positioned(

                          right: 6,
                          top: 6,

                          child: Container(

                            padding:
                                const EdgeInsets.all(4),

                            decoration:
                                const BoxDecoration(

                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),

                            child: const Text(

                              '3',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // =============================================
                // MENU DE FILTROS
                // =============================================
                Container(

                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(22),
                  ),

                  child: Row(

                    children: [

                      Expanded(
                        child:
                            _botaoFiltro('Todas'),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child:
                            _botaoFiltro('Baixa'),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child:
                            _botaoFiltro('Média'),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child:
                            _botaoFiltro('Alta'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // =====================================================
        // LISTA DE UNIDADES
        // =====================================================
        Expanded(

          child: ListView.builder(

            padding: const EdgeInsets.only(
              top: 12,
              bottom: 20,
            ),

            itemCount: unidadesFiltradas.length,

            itemBuilder: (context, index) {

              final unidade =
                  unidadesFiltradas[index];

              final fila =
                  unidade['fila'] as int;

              Color statusColor;
              String statusTexto;

              // =============================================
              // DEFINIR STATUS VISUAL
              // =============================================
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

              // =============================================
              // CARD DA UNIDADE
              // =============================================
              return Card(

                elevation: 2,

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: ListTile(

                  contentPadding:
                      const EdgeInsets.all(14),

                  // =========================================
                  // ÍCONE
                  // =========================================
                  leading: Container(

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(

                      color:
                          statusColor.withOpacity(0.12),

                      borderRadius:
                          BorderRadius.circular(14),
                    ),

                    child: Icon(
                      Icons.local_hospital,
                      color: statusColor,
                    ),
                  ),

                  // =========================================
                  // NOME
                  // =========================================
                  title: Text(

                    unidade['nome'],

                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),

                  // const SizedBox(height: 6),

                  // =========================================
                  // STATUS
                  // =========================================
                  subtitle: Padding(

                    padding:
                        const EdgeInsets.only(top: 8),

                    child: Row(

                      children: [

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

                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================================
                  // TEMPO
                  // =========================================
                  trailing: Container(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(

                      color:
                          const Color(0xFF03557A)
                              .withOpacity(0.08),

                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    child: Text(

                      unidade['tempo'],

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03557A),
                      ),
                    ),
                  ),

                  // =========================================
                  // ABRIR DIALOG
                  // =========================================
                  onTap: () {

                    // onFiltroChanged(texto);

                    showDialog(

                      context: context,

                      builder: (_) {

                        return AlertDialog(

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          title: Text(
                            unidade['nome'],
                          ),

                          content: Column(

                            mainAxisSize:
                                MainAxisSize.min,

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(
                                'Fila: ${unidade['fila']} pessoas',
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Tempo: ${unidade['tempo']}',
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Lotação: $statusTexto',
                              ),

                              const SizedBox(height: 12),

                              Text(
                                unidade['endereco'],
                              ),
                            ],
                          ),

                          actions: [

                            ElevatedButton.icon(

                              onPressed: () {

                                abrirRota(
                                  unidade['lat'],
                                  unidade['lng'],
                                );
                              },

                              icon: const Icon(
                                Icons.route,
                              ),

                              label:
                                  const Text('Ver rota'),
                            ),

                            TextButton(

                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child:
                                  const Text('Fechar'),
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
        ),
      ],
    );
  }
}