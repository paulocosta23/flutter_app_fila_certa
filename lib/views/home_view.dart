import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/features/dashboard/dashboard_view.dart';
import 'cadastro_view.dart';
import 'senha_view.dart';
import 'package:flutter_app_fila_certa/services/auth_service.dart';

/// ===============================
/// TELA DE LOGIN (HOME VIEW)
/// ===============================
///
/// Responsável por:
/// - Login com e-mail e senha (validação básica)
/// - Login com Google
/// - Navegação para cadastro e recuperação de senha
/// - Redirecionamento para Dashboard após login
///
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  /// Nome da rota principal ("/")
  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  /// Controla o estado de carregamento (ex: login Google)
  bool _isLoading = false;

  /// Chave do formulário (usada para validação)
  final _formKey = GlobalKey<FormState>();

  /// Controllers para capturar os dados digitados
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  /// Controla se a senha está visível ou não
  bool obscure = true;

  /// Libera memória dos controllers ao destruir o widget
  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  /// ===============================
  /// LOGIN PADRÃO (EMAIL/SENHA)
  /// ===============================
  Future<void> acessar() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
        );

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            DashboardView.routeName,
          );
        }
      } on FirebaseAuthException catch (e) {
        String mensagem = 'Erro ao fazer login';

        if (e.code == 'user-not-found') {
          mensagem = 'Usuário não encontrado';
        } else if (e.code == 'wrong-password') {
          mensagem = 'Senha incorreta';
        } else if (e.code == 'invalid-email') {
          mensagem = 'E-mail inválido';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem))
        );
      }
    }
  }

  /// ===============================
  /// VALIDAÇÃO DE E-MAIL
  /// ===============================
  String? _validateEmail(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o e-mail';

    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(value!.trim())) return 'E-mail inválido';

    return null;
  }

  /// ===============================
  /// VALIDAÇÃO DE SENHA
  /// ===============================
  String? _validateSenha(String? value) {
    if ((value ?? '').isEmpty) return 'Informe a senha';
    if ((value ?? '').length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  /// ===============================
  /// LOGIN COM GOOGLE
  /// ===============================
  Future<void> _loginGoogle() async {
    setState(() => _isLoading = true);

    try {
      // Chama serviço de autenticação
      final user = await AuthService().signInWithGoogle();

      // Se login deu certo
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(
          context,
          DashboardView.routeName,
        );
      } else {
        // Usuário cancelou login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login cancelado')),
        );
      }
    } catch (e) {
      // Erro durante login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao entrar com Google: $e')),
      );
    }

    // Finaliza loading
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// ===============================
  /// BUILD DA INTERFACE
  /// ===============================
  @override
  Widget build(BuildContext context) {

    /// Largura da tela
    final width = MediaQuery.of(context).size.width;

    /// Campos ocupam 70% da tela
    final fieldWidth = width * 0.7;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// Fundo com gradiente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white10,
              Colors.lightBlue,
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(

              /// Permite rolagem em telas pequenas
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [

                    /// ===============================
                    /// LOGO
                    /// ===============================
                    Image.asset(
                      'assets/images/logo_semfundo.png',
                      height: 200,
                    ),

                    const SizedBox(height: 24),

                    /// ===============================
                    /// CAMPO E-MAIL
                    /// ===============================
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,

                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// ===============================
                    /// CAMPO SENHA
                    /// ===============================
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: senhaController,
                        obscureText: obscure,
                        validator: _validateSenha,

                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const UnderlineInputBorder(),

                          /// Botão mostrar/ocultar senha
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => obscure = !obscure),
                            icon: Icon(
                              obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ===============================
                    /// ESQUECI SENHA
                    /// ===============================
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          SenhaView.routeName,
                        );
                      },
                      child: const Text('Esqueci minha senha'),
                    ),

                    const SizedBox(height: 12),

                    /// ===============================
                    /// BOTÃO ACESSAR
                    /// ===============================
                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: acessar,
                        child: const Text('Acessar'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ===============================
                    /// ACESSO SEM CADASTRO
                    /// ===============================
                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            DashboardView.routeName,
                          );
                        },
                        child: const Text('Acessar sem cadastro'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ===============================
                    /// CADASTRO
                    /// ===============================
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          CadastroView.routeName,
                        );
                      },
                      child: const Text(
                        'Não tem conta? Cadastre-se',
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ===============================
                    /// LOGIN COM GOOGLE
                    /// ===============================
                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        /// Desabilita durante loading
                        onPressed:
                            _isLoading ? null : _loginGoogle,

                        /// Ícone muda para loading
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Image.asset(
                                'assets/images/google_logo.png',
                                height: 20,
                              ),

                        label: const Text(
                          'Continuar com Google',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}