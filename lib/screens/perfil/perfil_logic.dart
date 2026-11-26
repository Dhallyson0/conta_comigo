// ignore_for_file: invalid_use_of_protected_member

part of 'perfil_screen.dart';

extension _PerfilLogic on _PerfilScreenState {
    // ============================================================
    // CARREGAR PERFIL E GRUPOS
    // ============================================================

    Future<void> _carregarDados() async {
      try {
        final resultados = await Future.wait([
          _profileService.buscarMeuPerfil(),
          _grupoService.buscarMeusGrupos(),
        ]);

        final perfil = resultados[0] as Map<String, dynamic>?;
        final respostaGrupos =
            resultados[1] as List<Map<String, dynamic>>;

        final grupos = <Map<String, dynamic>>[];

        for (final item in respostaGrupos) {
          final grupo = item['grupos'];

          if (grupo is Map) {
            grupos.add({
              'id': grupo['id']?.toString(),
              'nome': grupo['nome']?.toString() ?? 'Grupo',
              'codigo': grupo['codigo']?.toString() ?? '',
              'role': item['role']?.toString() ?? 'membro',
            });
          }
        }

        if (!mounted) return;

        setState(() {
          _nome = perfil?['nome']?.toString() ?? 'Usuário';
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
          'Não foi possível carregar o perfil.',
        );
      }
    }

    // ============================================================
    // EDITAR PERFIL
    // ============================================================

    Future<void> _editarPerfil() async {
      final novoNome = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return TextInputDialog(
            titulo: 'Editar perfil',
            nomeAtual: _nome,
            labelText: 'Nome',
            hintText: 'Digite seu nome',
          );
        },
      );

      if (!mounted || novoNome == null || novoNome.trim().isEmpty) {
        return;
      }

      final nome = novoNome.trim();

      try {
        await _profileService.atualizarNome(nome);

        if (!mounted) return;

        setState(() {
          _nome = nome;
        });

        mostrarMensagem(
          context,
          'Nome atualizado com sucesso.',
        );
      } catch (e) {
        if (!mounted) return;

        mostrarMensagem(
          context,
          'Não foi possível atualizar o nome.',
        );
      }
    }

    // ============================================================
    // EDITAR GRUPO
    // ============================================================

    Future<void> _editarGrupo(
      Map<String, dynamic> grupo,
    ) async {
      if (grupo['role'] != 'admin') {
        return;
      }

      final grupoId = grupo['id']?.toString();

      if (grupoId == null || grupoId.isEmpty) {
        return;
      }

      final nomeAtual = grupo['nome']?.toString() ?? '';

      final novoNome = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return TextInputDialog(
            titulo: 'Editar grupo',
            nomeAtual: nomeAtual,
            labelText: 'Nome do grupo',
            hintText: 'Digite o nome do grupo',
          );
        },
      );

      if (!mounted || novoNome == null || novoNome.trim().isEmpty) {
        return;
      }

      try {
        await _grupoService.editarGrupo(
          grupoId: grupoId,
          nome: novoNome,
        );

        if (!mounted) return;

        await _carregarDados();

        if (!mounted) return;

        mostrarMensagem(
          context,
          'Grupo atualizado com sucesso.',
        );
      } catch (e) {
        if (!mounted) return;

        mostrarMensagem(
          context,
          'Não foi possível editar o grupo.',
        );
      }
    }

    // ============================================================
    // EXCLUIR GRUPO
    // ============================================================

    Future<void> _excluirGrupo(
      Map<String, dynamic> grupo,
    ) async {
      if (grupo['role'] != 'admin') {
        return;
      }

      final grupoId = grupo['id']?.toString();

      if (grupoId == null || grupoId.isEmpty) {
        return;
      }

      final nomeGrupo =
          grupo['nome']?.toString() ?? 'Grupo';

      final confirmar = await confirmarDialog(
        context,
        titulo: 'Excluir grupo?',
        mensagem: 'O grupo "$nomeGrupo" e seus dados serão excluídos.',
        textoConfirmar: 'Excluir',
        tituloStyle: const TextStyle(
          color: AppColors.azulEscuro,
          fontWeight: FontWeight.bold,
        ),
      );

      if (!mounted || confirmar != true) {
        return;
      }

      try {
        await _grupoService.excluirGrupo(
          grupoId: grupoId,
        );

        if (!mounted) return;

        await _carregarDados();

        if (!mounted) return;

        mostrarMensagem(
          context,
          'Grupo excluído com sucesso.',
        );
      } catch (e) {
        if (!mounted) return;

        mostrarMensagem(
          context,
          'Não foi possível excluir o grupo.',
        );
      }
    }

    // ABRIR EDITAR GRUPOS

    // ============================================================
    // ABRIR EDITAR GRUPOS
    // ============================================================

    Future<void> _abrirEditarGrupos() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return _EditarGruposSheet(
            grupos: _grupos,
            onEditar: _editarGrupo,
            onExcluir: _excluirGrupo,
          );
        },
      );
    }

    // LOGOUT

    // ============================================================
    // LOGOUT
    // ============================================================
  Future<void> _sair() async {
      try {
        await _authService.logout();

        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;

        mostrarMensagem(
          context,
          'Não foi possível sair da conta.',
        );
      }
    }

    // OPÇÃO DE CONFIGURAÇÃO

    // ============================================================
    // OPÇÃO DE CONFIGURAÇÃO
    // ============================================================

    Widget _opcaoConfiguracao({
      required IconData icone,
      required String titulo,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 58,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          decoration: BoxDecoration(
            color: AppColors.branco,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.azulClaro,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.azulClaro,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icone,
                  color: AppColors.verde,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: AppColors.azulEscuro,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.verde,
                size: 30,
              ),
            ],
          ),
        ),
      );
    }

}
