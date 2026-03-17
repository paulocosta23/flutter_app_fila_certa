import 'package:flutter/material.dart';

class SenhaView extends StatefulWidget {
  const SenhaView({super.key});
  static const routeName = '/senha';

  @override
  State<SenhaView> createState() => _SenhaViewState();
}

class _SenhaViewState extends State<SenhaView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o e-mail';
    final email = value!.trim();
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  void enviarRecuperacao() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: chamar API de recuperação de senha
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se existir, enviaremos instruções por e-mail.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Digite seu e-mail para receber o link de recuperação.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
SizedBox(
  height: 48,
  width: double.infinity,
  child: ElevatedButton(
    onPressed: enviarRecuperacao,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF03557A), // cor do botão
      foregroundColor: Colors.white,            // cor do texto/ícones
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: const Text(
      'Enviar',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
