import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/styles.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/background.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/auth_text_field.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _authService = AuthService();

  bool _carregando = false;
  bool _mostrarSenha = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      mostrarMensagem(context, 'Preencha todos os campos.');
      return;
    }

    if (senha.length < 8) {
      mostrarMensagem(context, 
        'A senha deve ter pelo menos 8 caracteres.',
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final resposta = await _authService.cadastrar(
        email: email,
        senha: senha,
        nome: nome,
      );

      if (!mounted) return;

      if (resposta.session != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        mostrarMensagem(context, 
          'Conta criada! Faça login para continuar.',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      mostrarMensagem(context, 
        'Não foi possível criar a conta.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }


  void _irParaLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/porco.png',
                    width: 130,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conta',
                        style: TextStyle(
                          color: AppColors.azulEscuro,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                        ),
                      ),
                      const Text(
                        'Comigo',
                        style: TextStyle(
                          color: AppColors.verde,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Dividir despesas\nnunca foi tão fácil',
                        style: TextStyle(
                          color: AppColors.cinzaTexto,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 35),

              AuthTextField(
                controller: _nomeController,
                hintText: 'Nome de usuário',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 20),

              AuthTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              AuthTextField(
                controller: _senhaController,
                hintText: 'Senha',
                icon: Icons.lock_outline,
                obscureText: !_mostrarSenha,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _mostrarSenha = !_mostrarSenha;
                    });
                  },
                  icon: Icon(
                    _mostrarSenha
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.verde,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              AuthButton(
                texto: 'Criar conta',
                onPressed: _cadastrar,
                carregando: _carregando,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já tem uma conta? ',
                    style: AppStyles.textoAuth,
                  ),
                  TextButton(
                    onPressed: _irParaLogin,
                    child: const Text(
                      'Login',
                      style: AppStyles.textoLink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}