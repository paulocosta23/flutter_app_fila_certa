// TELA DASHBOARD SEM CADASTRO


import 'package:flutter/material.dart';
import 'dart:io'; // Permite trabalhar com arquivos (File)
import 'package:image_picker/image_picker.dart'; // pacote para abrir galeria/câmera

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  static const routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
  
  }

  class _DashboardViewState extends State<DashboardView> {
   // Controla qual aba está selecionada
    int _currentIndex = 0;

  // Lista de telas que serão exibidas

    final List<Widget> _pages = const [
      HomeTab(),
      PerfilTab(),
      NotificacaoTab(),
      HistoricoTab(),
    ];

    // BARRA DE MENU INFERIOR COM AS ICONS

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        // Exibe a tela baseada no índice selecionado
        body: _pages[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          currentIndex: _currentIndex,
          
          // Quando clicar em um item, muda o índice
          onTap: (index) {
            setState(() {
              _currentIndex = index;

            });
          },
          
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),

             BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificação',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historico',
            )

             
          ]
        ),
      );
    }
  }

// TELA ÍNICIO COM BARRA DE PESQUISA

  class HomeTab extends StatelessWidget {
    const HomeTab({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        // Barra superior
        appBar: AppBar(
          title: const Text("FILA CERTA"),
        ),

        body: Column(
          children: [

            // Campo de pesquisa

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Pesquisar...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),
            
            const Center(
              child: Text(
                'Bem-vindo ao Fila Certa 👋 ',
                style: TextStyle(fontSize: 22),
              )
            )
          ]
        ),
      );
    }
  }

 // TELA DE PERFIL
 // Agora é StatefulWidget porque precisamos atualizar a tela dinamicamente
class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {

  // Variável que vai armazenar a imagem escolhida
  File? _image;

  // Função assíncrona para abrir a galeria
  Future<void> _pickImage() async {

    // Cria uma instância do ImagePicker
    final ImagePicker picker = ImagePicker();

    // Abre a galeria do celular
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    // Se o usuário escolheu uma imagem
    if (pickedFile != null) {

      // Atualiza o estado da tela
      setState(() {

        // Converte o caminho da imagem em um arquivo
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.bottomCenter,
              children: [

                // Avatar que muda dinamicamente
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFE0E0E0),

                  // Se existir imagem, mostra ela
                  backgroundImage:
                      _image != null ? FileImage(_image!) : null,

                  // Se NÃO existir imagem, mostra o ícone
                  child: _image == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        )
                      : null,
                ),

                // Botão para alterar foto
                TextButton(
                  onPressed: _pickImage, // chama a função
                  child: const Text("Alterar foto"),
                ),
              ],
            ),
          const SizedBox(height: 30),

          // INFORMAÇÕES DO USUÁRIO

          const ListTile(
            leading: Icon(Icons.person),
            title: Text("Paulo Henrique"),
            subtitle: Text("Nome Completo"),
          ),

          const ListTile(
            leading: Icon(Icons.email),
            title: Text("paulosilvacosta23@gmail.com"),
            subtitle: Text("Email"),
          ),

          const ListTile(
            leading: Icon(Icons.phone),
            title: Text("(91) 984970815"),
            subtitle: Text("Telefone"),
          ),

          const SizedBox(height: 20,),

          // BOTÃO IDIOMAS

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language),
            label: const Text("Idiomas"),
          ),

          const SizedBox(height: 10,),

          // BOTÃO EDITAR PERFIL

          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit),
            label: const Text("Editar Perfil"),

          ),

          const SizedBox(height: 10,),

          // BOTÃO SAIR

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text ("Sair"),
          ),


        ],
      ),
    )
  );
}
 }
  
  class NotificacaoTab extends StatelessWidget {
    const NotificacaoTab({super.key});

    @override
    Widget build(BuildContext context) {
      return const Center(
        child: Text(
          'Tela de Notificação',
          style: TextStyle(fontSize: 22),
        ),
      );
    }
  }

  class HistoricoTab extends StatelessWidget {
    const HistoricoTab({super.key});

    @override
    Widget build(BuildContext context) {
      return const Center(
        child: Text(
          'Tela de Historico',
          style: TextStyle(fontSize: 22),
        ),
      );
    }
  }

