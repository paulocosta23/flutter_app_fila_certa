import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/views/dashboard_view.dart';
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

  void acessar() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implementar login (API/Auth)
      Navigator.pushReplacementNamed(
        context,
        DashboardView.routeName,
      );
    }
  }

  String? _validateEmail(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o e-mail';
    final email = value!.trim();
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(email)) return 'E-mail inválido';
    return null;
    // Dica: se quiser forçar domínio ou regras específicas, ajuste aqui.
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
                      'assets/images/logo2.png',
                      height: 150,
                    ),
                    const SizedBox(height: 24),

                    // E-mail
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
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Senha
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
                          prefixIcon:
                              const Icon(Icons.lock_outline, size: 18),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.5),
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

                    // Esqueci minha senha
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
                          color: Colors.black
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botão Acessar
                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 69, 146, 255),
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

                    // Botão de acessar sem cadastro

                    SizedBox(
                      width: fieldWidth,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 69, 146, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            DashboardView.routeName
                          );
                        },
                        child: const Text(
                          'Acessar sem cadastro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Cadastro
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CadastroView.routeName);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1F6DD4),
                      ),
                      child:
                      const Text(
                        'Não tem conta? Cadastre-se',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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