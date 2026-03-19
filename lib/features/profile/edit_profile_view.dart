import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const EditProfileView({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop<Map<String, String>>(context, {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ('Editar perfil'),
        backgroundColor: const Color(0xFF03557A),
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.check), tooltip: 'Salvar', onPressed: _save),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe seu email';
                  final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
                  return ok ? null : 'Email inválido';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu telefone' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03557A),
                  foregroundColor: Colors.white,
                ),
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
