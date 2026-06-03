import 'package:flutter/material.dart';
// Importa a Dashboard com o caminho correto (nova estrutura por features)
import 'package:flutter_app_fila_certa/features/dashboard/dashboard_view.dart';
// Telas auxiliares (cadastro e recuperação de senha)
import 'cadastro_view.dart';
import 'senha_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  /// 🔥 FUNÇÃO COM TRY/CATCH (única alteração)
  void acessar() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // TODO: implementar login (API/Auth)

        Navigator.pushReplacementNamed(
          context,
          DashboardView.routeName,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao acessar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fieldWidth = width * 0.7;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_semfundo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontSize: 14),
                        validator: _validateEmail,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.email_outlined, size: 18),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: senhaController,
                        obscureText: obscure,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(fontSize: 14),
                        validator: _validateSenha,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.lock_outline, size: 18),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              obscure = !obscure;
                            }),
                            icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                              size: 18,
                            ),
                            tooltip: obscure ? 'Mostrar senha' : 'Ocultar senha',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SenhaView.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1F6DD4),
                      ),
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 85, 122),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: acessar,
                        child: const Text(
                          'Acessar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 85, 122),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            DashboardView.routeName,
                          );
                        },
                        child: const Text(
                          'Acessar sem cadastro',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CadastroView.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1F6DD4),
                      ),
                      child: const Text(
                        'Não tem conta? Cadastre-se',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // TODO: lógica de login com Google ou navegação
                        },
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          height: 20,
                          width: 20,
                        ),
                        label: const Text(
                          'Continuar com Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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