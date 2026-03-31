import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';
import 'package:flutter_app_fila_certa/views/home_view.dart';
import 'edit_profile_view.dart';
import 'package:flutter_app_fila_certa/features/history/historico_tab.dart';

class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  File? _image;

  // Dados mockados
  String _name = "Paulo Henrique";
  String _email = "paulosilvacosta23@gmail.com";
  String _phone = "(91) 984970815";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  /// ✅ MÉTODO QUE ESTAVA FALTANDO (CAUSA DO ERRO)
  void _goToHistorico() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoricoTab(),
      ),
    );
  }

  Future<void> _goToEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProfileView(name: _name, email: _email, phone: _phone),
      ),
    );
    if (result != null) {
      setState(() {
        _name = result['name'] ?? _name;
        _email = result['email'] ?? _email;
        _phone = result['phone'] ?? _phone;
      });
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeView.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final settings = SettingsScope.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF03557A),
        foregroundColor: Colors.white,
        title: const Text("Perfil"),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: settings.textScale),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: cs.surfaceVariant,
                    backgroundImage:
                        _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.person,
                            size: 60, color: Color(0xFF03557A))
                        : null,
                  ),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text("Alterar foto"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              _InfoCard(
                icon: Icons.person,
                title: _name,
                subtitle: "Nome completo",
              ),
              const SizedBox(height: 8),
              _InfoCard(
                icon: Icons.email,
                title: _email,
                subtitle: "Email",
              ),
              const SizedBox(height: 8),
              _InfoCard(
                icon: Icons.phone,
                title: _phone,
                subtitle: "Telefone",
              ),

              const SizedBox(height: 35),

              /// ✅ BOTÃO HISTÓRICO (AGORA FUNCIONA)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _goToHistorico,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color (0xFF03557A),
                      foregroundColor: Colors.white,
                      elevation: 0.5,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            BorderSide(color: cs.primary, width: 1.2),
                      ),
                    ),
                    icon: const Icon(Icons.history),
                    label: const Text(
                      "Histórico",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _goToEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03557A),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Editar Perfil",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.surface,
                      foregroundColor: Colors.red.shade700,
                      elevation: 0.5,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.red.shade300,
                          width: 1.2,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text("Sair"),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side:
            const BorderSide(color: Color(0xFF03557A), width: 1.5),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}