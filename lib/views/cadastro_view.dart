import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (!regex.hasMatch(value!.trim())) return 'E-mail inválido';
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

  // ===============================
  // CRIAR CONTA (FIREBASE)
  // ===============================
  Future<void> criarConta() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
        );

        // Atualiza nome do usuário
        await userCredential.user?.updateDisplayName(
          nomeController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta criada com sucesso! 👍'),
            ),
          );

          Navigator.pop(context);
        }

      } on FirebaseAuthException catch (e) {
        String mensagem = 'Erro ao criar conta';

        if (e.code == 'email-already-in-use') {
          mensagem = 'E-mail já está em uso';
        } else if (e.code == 'weak-password') {
          mensagem = 'Senha muito fraca';
        } else if (e.code == 'invalid-email') {
          mensagem = 'E-mail inválido';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem)),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  // ===============================
  // CAMPO PADRÃO
  // ===============================
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFF03557A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: Color(0xFF03557A),
              width: 2,
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF03557A),
        foregroundColor: Colors.white,
        title: const Text('Cadastro'),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Form(
            key: _formKey,

            child: ListView(
              children: [

                const SizedBox(height: 20),

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
                      obscureSenha
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),

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

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: criarConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03557A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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