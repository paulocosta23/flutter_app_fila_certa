import 'package:flutter/material.dart';
// Importa a Dashboard com o caminho correto (nova estrutura por features)
import 'package:flutter_app_fila_certa/features/dashboard/dashboard_view.dart';
// Telas auxiliares (cadastro e recuperação de senha)
import 'cadastro_view.dart';
import 'senha_view.dart';

/// Tela inicial (login) do app.
/// - Possui validação de e-mail e senha.
/// - Navega para a Dashboard ao acessar com sucesso.
/// - Possui ações para recuperar senha e criar conta.
/// - Usa pushReplacement para substituir a tela no stack ao acessar.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  /// Nome da rota (usado no MaterialApp.routes)
  static const routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Chave do formulário para validar os campos
  final _formKey = GlobalKey<FormState>();

  /// Controllers para ler o texto digitado
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  /// Controle de visibilidade da senha
  bool obscure = true;

  @override
  void dispose() {
    // Importante: liberar os recursos dos controllers ao destruir o widget
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  /// Acionado ao clicar no botão "Acessar".
  /// Se o formulário for válido, segue para a Dashboard.
  /// (Aqui você poderá implementar autenticação real futuramente.)
  void acessar() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implementar login (API/Auth)
      // pushReplacementNamed remove a tela de login do stack,
      // evitando que o usuário volte para cá ao apertar "voltar".
      Navigator.pushReplacementNamed(
        context,
        DashboardView.routeName,
      );
    }
  }

  /// Validação simples de e-mail (formato básico)
  String? _validateEmail(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o e-mail';
    final email = value!.trim();
    // Regex simples: texto@texto.texto
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(email)) return 'E-mail inválido';
    return null;
    // Dica: se quiser forçar domínio ou regras específicas, ajuste a regex.
  }

  /// Validação da senha: obrigatória e com mínimo de 6 caracteres
  String? _validateSenha(String? value) {
    if ((value ?? '').isEmpty) return 'Informe a senha';
    if ((value ?? '').length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Largura da tela para calcular o tamanho dos campos
    final width = MediaQuery.of(context).size.width;
    final fieldWidth = width * 0.7; // 70% da largura da tela

    return Scaffold(
      // Container para aplicar gradiente de fundo
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradiente sutil do topo esquerdo para baixo à direita
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
          // Garante que a UI respeite as áreas seguras (notch, barras, etc.)
          child: Center(
            child: SingleChildScrollView(
              // Permite rolar o conteúdo em telas menores
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: _formKey, // associa o form à chave para validações
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo do app
                    Image.asset(
                      'assets/images/logo_semfundo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 24),

                    // ===== CAMPO: E-mail =====
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next, // "próximo" no teclado
                        style: const TextStyle(fontSize: 14),
                        validator: _validateEmail, // validação
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(fontSize: 13),
                          prefixIcon: Icon(Icons.email_outlined, size: 18),
                          // Deixa o campo mais compacto
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          // Usa underline para combinar com seu layout
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

                    // ===== CAMPO: Senha =====
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: senhaController,
                        obscureText: obscure, // esconde/mostra a senha
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
                          // Ícone para alternar a visibilidade da senha
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

                    // ===== Link: Esqueci minha senha =====
                    TextButton(
                      onPressed: () {
                        // Abre a tela de recuperação de senha
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

                    // ===== Botão: Acessar (com login) =====
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
                        onPressed: acessar, // chama a função que valida e navega
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

                    // ===== Botão: Acessar sem cadastro =====
                    // Usa pushReplacement para substituir a tela (como no login)
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

                    // ===== Link: Cadastro =====
                    TextButton(
                      onPressed: () {
                        // Abre a tela de cadastro
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
    // ÍCONE DO GOOGLE
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