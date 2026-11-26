import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/theme.dart';
import '../../services/grupo_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/background.dart';
import '../../widgets/bottom_navigation.dart';
import '../grupo/grupo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _grupoService = GrupoService();

  List<Map<String, dynamic>> _grupos = [];

  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarGrupos();
  }

  Future<void> _carregarGrupos() async {
    try {
      final grupos = await _grupoService.buscarMeusGrupos();

      if (!mounted) return;

      setState(() {
        _grupos = grupos;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
      });

      mostrarMensagem(
        context,
        'Não foi possível carregar seus grupos.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,

      body: _home(),

      bottomNavigationBar: const SafeArea(
        top: false,
        child: BottomNavigation(
          indiceAtual: 0,
        ),
      ),
    );
  }

  Widget _home() {
    return AppBackground(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _carregarGrupos,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              32,
              50,
              32,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cabecalho(),

                const SizedBox(height: 48),

                const Text(
                  'Meus Grupos:',
                  style: TextStyle(
                    color: AppColors.azulEscuro,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                if (_carregando)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: AppColors.verde,
                      ),
                    ),
                  )
                else if (_grupos.isEmpty)
                  _semGrupos()
                else
                  ..._grupos.map(
                    (item) {
                      final grupo =
                          item['grupos'] as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child: _grupoCard(grupo),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Row(
      children: [
        Image.asset(
          'assets/images/porco.png',
          width: 70,
        ),

        const SizedBox(width: 10),

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conta',
              style: TextStyle(
                color: AppColors.azulEscuro,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 0.9,
              ),
            ),
            Text(
              'Comigo',
              style: TextStyle(
                color: AppColors.verde,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 0.9,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _semGrupos() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Center(
        child: Text(
          'Você ainda não participa de nenhum grupo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.cinzaTexto,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _grupoCard(Map<String, dynamic> grupo) {
    return InkWell(
      onTap: () async {
        final resultado = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => GrupoScreen(
              grupoId: grupo['id'] as String,
              nomeGrupo: grupo['nome'] as String,
              codigoGrupo: grupo['codigo'] as String,
            ),
          ),
        );

        if (resultado == true && mounted) {
          await _carregarGrupos();
        }
      },
      borderRadius: BorderRadius.circular(35),
      child: AppCard(
        width: double.infinity,
        height: 76,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        borderRadius: BorderRadius.circular(35),
        borderColor: AppColors.azulClaro,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: AppColors.azulClaro,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups,
                color: AppColors.verde,
                size: 32,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                grupo['nome'] as String,
                style: const TextStyle(
                  color: AppColors.azulEscuro,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.verde,
              size: 42,
            ),
          ],
        ),
      ),
    );
  }
}