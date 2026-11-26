import 'package:conta_comigo/screens/perfil/perfil_screen.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../screens/home/home_screen.dart';
import '../screens/grupo/criar_entrar/criar_entrar_grupo_screen.dart';

class BottomNavigation extends StatelessWidget {
  final int indiceAtual;

  const BottomNavigation({
    super.key,
    required this.indiceAtual,
  });

  void _navegar(BuildContext context, int indice) {
    // Se já estiver na tela selecionada, não faz nada.
    if (indice == indiceAtual) {
      return;
    }

    Widget tela;

    switch (indice) {
      case 0:
        tela = const HomeScreen();
        break;

      case 1:
        tela = const CriarEntrarGrupoScreen();
        break;

      case 2:
        tela = const PerfilScreen();
        break;

      default:
        tela = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => tela,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // BARRA AZUL
          Container(
            height: 70,
            margin: const EdgeInsets.fromLTRB(
              30,
              0,
              30,
              12,
            ),
            decoration: BoxDecoration(
              color: AppColors.azulEscuro,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // HOME
                _ItemNavegacao(
                  icone: Icons.home_outlined,
                  selecionado: indiceAtual == 0,
                  onTap: () => _navegar(context, 0),
                ),

                // ESPAÇO PARA O +
                const SizedBox(width: 90),

                // PERFIL
                _ItemNavegacao(
                  icone: Icons.person_outline,
                  selecionado: indiceAtual == 2,
                  onTap: () => _navegar(context, 2),
                ),
              ],
            ),
          ),

          // BOTÃO +
          Positioned(
            bottom: 18,
            child: GestureDetector(
              onTap: () => _navegar(context, 1),
              child: Container(
                width: 78,
                height: 78,
                decoration: const BoxDecoration(
                  color: AppColors.verdeClaro,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: indiceAtual == 1
                      ? AppColors.azulEscuro
                      : AppColors.branco,
                  size: 44,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemNavegacao extends StatelessWidget {
  final IconData icone;
  final bool selecionado;
  final VoidCallback onTap;

  const _ItemNavegacao({
    required this.icone,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 28,
      icon: Icon(
        icone,
        color: selecionado
            ? AppColors.verdeClaro
            : AppColors.branco,
        size: 36,
      ),
    );
  }
}