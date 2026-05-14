import 'package:flutter/material.dart';

class UnidadesTab extends StatelessWidget {
  const UnidadesTab({super.key});

  @override
  Widget build(BuildContext context) {

    final unidades = [
      'Pronto Socorro Dr. Humberto Maradei',
      'UPA Jurunas',
      'UPA Sacramenta',
      'UPA Icoaraci',
      'UPA Marambaia',
      'UPA Terra Firme',
      'UBS Portal da Amazônia',
      'UBS Pedreira',
      'UBS Canal do Galo 1',
    ];

    final Map<String, Map<String, dynamic>> upaInfo = {
      'Pronto Socorro Dr. Humberto Maradei': {
        'fila': 23,
        'tempo': '35 min',
        'endereço': 'Passagem São Miguel, 100,  Guamá, Belém - PA',
      },
      'UPA Jurunas': {
        'fila': 15,
        'tempo': '20 min',
        'endereço': 'Tv. Quintino Bocaiúva, Jurunas, Belém - PA',
      },
      'UPA Sacramenta': {
        'fila': 30,
        'tempo': '50 min',
        'endereço': 'Av. Dr. Freitas, 860 , Sacramenta, Belém - PA',
      },
      'UPA Icoaraci': {
        'fila': 10,
        'tempo': '15 min',
        'endereço': 'Rua Paraiso, Parque Guajará, Belém - PA',
      },
      'UPA Marambaia': {
        'fila': 15,
        'tempo': '19 min',
        'endereço': 'R. Maravalho belo, sn - Marambaia, Belém - PA',
      },
      'UPA Terra Firme': {
        'fila': 45,
        'tempo': '60 min',
        'endereço': 'Av. Perimetral, Universitário, Belém - PA',
      },
      'UBS Portal da Amazônia': {
        'fila': 10,
        'tempo': '12 min',
        'endereço': 'R. Osvaldo de Caldas Brito, 39, Jurunas, Belém - PA',
      },
      'UBS Pedreira': {
        'fila': 13,
        'tempo': '16 min',
        'endereço': 'Av. Pedro Miranda, 1346, Pedreira, Belém - PA',
      },
      'UBS Canal do Galo 1': {
        'fila': 17,
        'tempo': '22 min',
        'endereço': 'Tv. Antônio Baena, s/n - Pedreira, Belém - PA',
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unidades de Saúde'),
      ),

      body: ListView.builder(
        itemCount: unidades.length,
        itemBuilder: (context, index) {
          final unidade = unidades[index];

          return ListTile(
            leading: const Icon(Icons.local_hospital),
            title: Text(unidade),

            onTap: () {

              final info = upaInfo[unidade]!;
              final endereco = info['endereço'] as String;
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
                builder: (dialogContext) {
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

                            // 🔥 BOX PRINCIPAL
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

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(endereco),
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

                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Fechar'),
                              ),
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
        },
      ),
    );
  }

  // 🔥 BOLINHA
  static Widget _bolinha(Color cor, {bool destaque = false}) {
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