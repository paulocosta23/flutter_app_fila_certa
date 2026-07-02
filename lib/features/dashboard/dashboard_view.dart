import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/app_theme.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';

import 'package:flutter_app_fila_certa/features/home/mapa_view.dart';
import 'package:flutter_app_fila_certa/features/notifications/notificacao_tab.dart';
import 'package:flutter_app_fila_certa/features/profile/perfil_tab.dart';
import 'package:flutter_app_fila_certa/features/settings/settings_view.dart';
import 'package:flutter_app_fila_certa/features/unidades/unidades_tab.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  // ======================
  // FILTRO
  // ======================
  String _filtroLotacao = 'Todas';

  // ======================
  // ABA ATUAL
  // ======================
  int _currentIndex = 0;

  // ======================
  // CONFIGURAÇÕES
  // ======================
  Future<void> _openSettings() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsView(),
      ),
    );

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações atualizadas!'),
        ),
      );
    }
  }

  // ======================
  // NOTIFICAÇÕES
  // ======================
  Future<void> _openNotifications() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificacaoTab(),
      ),
    );
  }

  // ======================
  // BOTÃO FILTRO
  // ======================
  Widget _buildFiltro(String filtro) {

    final selecionado = _filtroLotacao == filtro;

    return SizedBox(

      width: 82,

      child: ChoiceChip(

        label: SizedBox(

          width: double.infinity,

          child: Text(

            filtro,

            textAlign: TextAlign.center,

            style: TextStyle(

              fontSize: 13,

              fontWeight: FontWeight.w600,

              color:
                  selecionado
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
        ),

        selected: selecionado,

        showCheckmark: false,

        selectedColor: const Color(0xFF03557A),

        backgroundColor: Colors.white,

        side: BorderSide(
          color:
              selecionado
                  ? Colors.blue
                  : Colors.grey.shade300,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),

        onSelected: (_) {

          setState(() {
            _filtroLotacao = filtro;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final settings = SettingsScope.of(context);

    final theme = buildTheme(
      darkMode: settings.darkMode,
      highContrast: settings.highContrast,
    );

    // ======================
    // PÁGINAS
    // ======================
    // final pages = <Widget>[

    //   // MAPA
    //   MapaView(
    //     filtro: _filtroLotacao,
    //   ),

    //   // UNIDADES
    //   Column(
    //     children: [
    //       const SizedBox(height: 170),

    //       Expanded(
    //         child: UnidadesTab(
    //           filtro: _filtroLotacao,
    //         ),
    //       ),
    //     ],
    //   ),

    //   // PERFIL
    //   const PerfilTab(),
    // ];

    return Theme(

      data: theme,

      child: Scaffold(

        backgroundColor: const Color(0xFF03557A),

        // ======================
        // BODY
        // ======================
        // ======================
// BODY
// ======================
body: MediaQuery(

  data: MediaQuery.of(context).copyWith(
    textScaleFactor: settings.textScale,
  ),

  child: Stack(

    children: [

      // ======================
      // TELAS
      // ======================
      Positioned.fill(

        child: IndexedStack(

          index: _currentIndex,

          children: [

            // MAPA
            MapaView(
              filtro: _filtroLotacao,
            ),

            // UNIDADES
            UnidadesTab(
              filtro: _filtroLotacao,

              onFiltroChanged: (novoFiltro) {
                setState(() {
                  _filtroLotacao = novoFiltro;
                });
              },
            ),

            // PERFIL
            const PerfilTab(),
          ],
        ),
      ),

      // ======================
      // TOPO FLUTUANTE
      // MAPA + UNIDADES
      // ======================
      if (_currentIndex == 0)

        SafeArea(

          child: Padding(

            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),

            child: Column(

              children: [

                // ======================
                // NOTIFICAÇÃO
                // ======================
                Align(

                  alignment: Alignment.topRight,

                  child: Stack(

                    children: [

                      Container(

                        width: 52,
                        height: 52,

                        decoration: BoxDecoration(

                          color: Colors.white.withOpacity(0.08),

                          borderRadius:
                              BorderRadius.circular(18),

                          boxShadow: [

                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.08),

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child: IconButton(

                          icon: const Icon(
                            Icons.notifications_none,
                            color: Color(0xFF03557A),
                            size: 30,
                          ),

                          onPressed:
                              _openNotifications,
                        ),
                      ),

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
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                //======================
                //FILTROS
                //======================
                Container(
                  width: 450,
                  height: 120,

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(

                    color:
                        Colors.white.withOpacity(0.05),

                    borderRadius:
                        BorderRadius.circular(24),

                    boxShadow: [

                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.08),

                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Padding(

                        padding: const EdgeInsets.only(
                          left: 4,
                          bottom: 10,
                        ),

                        child: Text(

                          _currentIndex == 0
                              ? 'Lotação'
                              : 'Filtrar unidades',

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF03557A),
                          ),
                        ),
                      ),

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,

                        children: [

                          _buildFiltro('Todas'),
                          _buildFiltro('Baixa'),
                          _buildFiltro('Média'),
                          _buildFiltro('Alta'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  ),
),

        // ======================
        // MENU INFERIOR
        // ======================
        bottomNavigationBar: BottomNavigationBar(

          type: BottomNavigationBarType.fixed,

          currentIndex: _currentIndex,

          onTap: (i) {

            // ======================
            // CONFIGURAÇÕES
            // ======================
            if (i == 3) {

              _openSettings();
              return;
            }

            setState(() {
              _currentIndex = i;
            });
          },

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital),
              label: 'Unidades',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}