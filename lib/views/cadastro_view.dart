import 'package:flutter/material.dart';

// Tela de cadastro (Stateful pois tem estado: senha visível, validação, etc)
class CadastroView extends StatefulWidget {
  const CadastroView({super.key});
  static const routeName = '/cadastro';

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {

  // Chave para controlar o formulário (validação)
  final _formKey = GlobalKey<FormState>();

  // Controllers dos campos
  final nomeController = TextEditingController();
  final nascimentoController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  // Controle de visibilidade das senhas
  bool obscureSenha = true;
  bool obscureConfirmar = true;

  // Libera memória ao sair da tela
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

  // Validação padrão (campo obrigatório)
  String? _notEmpty(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  // Validação de e-mail
  String? _validateEmail(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o e-mail';

    final email = value!.trim();

    // Regex simples para validar email
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (!regex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  // Validação de senha
  String? _validateSenha(String? value) {
    if ((value ?? '').isEmpty) return 'Informe a senha';
    if ((value ?? '').length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  // Validação de confirmação de senha
  String? _validateConfirmarSenha(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme a senha';
    if (value != senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  // Função ao clicar no botão
  void criarConta() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aqui futuramente entra API/backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso! 🎉'),
        ),
      );

      // Volta pra tela anterior
      Navigator.pop(context);
    }
  }

  // 🔥 Widget padrão para criar campos (reutilização)
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

        // 🔵 ESTILO DO CAMPO
        decoration: InputDecoration(
          labelText: label,

          // Borda padrão (quando não está focado)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: Color(0xFF03557A), // 🔵 MESMA COR DO BOTÃO
            ),
          ),

          // Borda quando o usuário clica no campo
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: Color(0xFF03557A),
              width: 2, // mais grossa quando focado
            ),
          ),

          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔵 APPBAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF03557A),
        foregroundColor: Colors.white,
        title: const Text('Cadastro'),
      ),

      // 🔽 CORPO DA TELA
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          // Formulário
          child: Form(
            key: _formKey,

            child: ListView(
              children: [

                const SizedBox(height: 20),

                // Campos
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

                // Campo senha
                buildField(
                  'Senha',
                  senhaController,
                  obscure: obscureSenha,
                  validator: _validateSenha,
                  textInputAction: TextInputAction.next,

                  // Botão de mostrar/ocultar senha
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => obscureSenha = !obscureSenha),
                    icon: Icon(
                      obscureSenha
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),

                // Confirmar senha
                buildField(
                  'Confirmar Senha',
                  confirmarSenhaController,
                  obscure: obscureConfirmar,
                  validator: _validateConfirmarSenha,
                  textInputAction: TextInputAction.done,

                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => obscureConfirmar = !obscureConfirmar),
                    icon: Icon(
                      obscureConfirmar
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔘 BOTÃO
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: criarConta,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03557A),
                      foregroundColor: Colors.white,

                      // Arredondamento
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      elevation: 3,
                    ),

                    child: const Text(
                      'Concluir',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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