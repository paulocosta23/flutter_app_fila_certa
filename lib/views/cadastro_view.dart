import 'package:flutter/material.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});
  static const routeName = '/cadastro';

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final nascimentoController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool obscureSenha = true;
  bool obscureConfirmar = true;

  @override
  void dispose() {
    nomeController.dispose();
    nascimentoController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  String? _notEmpty(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  String? _validateEmail(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o e-mail';
    final email = value!.trim();
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  String? _validateSenha(String? value) {
    if ((value ?? '').isEmpty) return 'Informe a senha';
    if ((value ?? '').length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validateConfirmarSenha(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme a senha';
    if (value != senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  void criarConta() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implementar cadastro (API/Backend)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! 🎉'),
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator ?? _notEmpty,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(            
            key: _formKey,
            child: ListView(
              children: [
                buildField(
                  'Nome Completo',
                  nomeController,
                  textInputAction: TextInputAction.next,
                ),
                buildField(
                  'Data de Nascimento',
                  nascimentoController,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                ),
                buildField(
                  'CPF',
                  cpfController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                buildField(
                  'Telefone',
                  telefoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                buildField(
                  'E-mail',
                  emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                buildField(
                  'Senha',
                  senhaController,
                  obscure: obscureSenha,
                  validator: _validateSenha,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => obscureSenha = !obscureSenha),
                    icon: Icon(
                        obscureSenha ? Icons.visibility : Icons.visibility_off),
                    tooltip:
                        obscureSenha ? 'Mostrar senha' : 'Ocultar senha',
                  ),
                ),
                buildField(
                  'Confirmar Senha',
                  confirmarSenhaController,
                  obscure: obscureConfirmar,
                  validator: _validateConfirmarSenha,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                        () => obscureConfirmar = !obscureConfirmar),
                    icon: Icon(obscureConfirmar
                        ? Icons.visibility
                        : Icons.visibility_off),
                    tooltip: obscureConfirmar
                        ? 'Mostrar senha'
                        : 'Ocultar senha',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: criarConta,
                    child: const Text('Concluir'),
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