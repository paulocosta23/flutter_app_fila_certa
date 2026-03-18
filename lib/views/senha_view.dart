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
      appBar: AppBar(
        backgroundColor: const Color(0xFF03557A),
        foregroundColor: Colors.white,
        
        
        title: const Text('Recuperar Senha')),
        
      body: SafeArea(
      
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              
              children: [
                const SizedBox(height: 20),
                const Text(
                 
                  'Digite seu e-mail para receber o link de recuperação.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 25),
              TextFormField(
  controller: emailController,
  validator: _validateEmail,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'E-mail',

    // Borda "fallback" (caso nenhuma outra se aplique)
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF03557A), // cor base
        width: 1.2,
      ),
    ),

    // Borda quando habilitado (sem foco)
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF03557A), // sua cor desejada
        width: 1.2,
      ),
    ),

    // Borda quando focado
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary, // integra com o tema
        width: 1.8,
      ),
    ),

    // Borda quando há erro (sem foco)
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error, // vermelho do tema
        width: 1.2,
      ),
    ),

    // Borda quando há erro e está focado
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 1.8,
      ),
    ),
  ),
),
const SizedBox(height: 20,),
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
