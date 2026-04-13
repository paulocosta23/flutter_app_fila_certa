import 'package:flutter/material.dart';

class UnidadesTab extends StatelessWidget {
  const UnidadesTab({super.key});

  @override
  Widget build(BuildContext context) {

    final unidades = [
      'UPA Guamá',
      'UPA Jurunas',
      'UPA Sacramenta',
      'UPA Icoaraci',
    ];

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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(unidade),
                    content: const Text('Aqui você pode mostrar os dados da fila.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}