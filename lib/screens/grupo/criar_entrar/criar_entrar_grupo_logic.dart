// ignore_for_file: invalid_use_of_protected_member

part of 'criar_entrar_grupo_screen.dart';

extension __CriarEntrarGrupoScreenStateLogic on _CriarEntrarGrupoScreenState {
    // ============================================================
    // CRIAR GRUPO
    // ============================================================

    Future<void> _criarGrupo() async {
      final nome = _nomeGrupoController.text.trim();

      if (nome.isEmpty) {
        mostrarMensagem(context, 
          'Digite um nome para o grupo.',
        );

        return;
      }

      if (_criandoGrupo) {
        return;
      }

      setState(() {
        _criandoGrupo = true;
      });

      try {
        final resposta = await _grupoService.criarGrupo(
          nome: nome,
        );

        if (!mounted) return;

        final grupo =
            Map<String, dynamic>.from(resposta);

        final grupoId =
            grupo['id']?.toString();

        final nomeGrupo =
            grupo['nome']?.toString() ?? nome;

        final codigoGrupo =
            grupo['codigo']?.toString() ?? '';

        if (grupoId == null ||
            codigoGrupo.isEmpty) {
          throw Exception(
            'O grupo foi criado, mas os dados retornados estão incompletos.',
          );
        }

        _nomeGrupoController.clear();

        _mostrarCodigoCriado(
          grupoId: grupoId,
          nomeGrupo: nomeGrupo,
          codigoGrupo: codigoGrupo,
        );
      } catch (e) {
        if (!mounted) return;

        mostrarMensagem(context, 
          'Não foi possível criar o grupo.',
        );
      } finally {
        if (mounted) {
          setState(() {
            _criandoGrupo = false;
          });
        }
      }
    }

    // ============================================================
    // ENTRAR NO GRUPO
    // ============================================================

    Future<void> _entrarGrupo() async {
      final codigo =
          _codigoGrupoController.text.trim();

      if (codigo.isEmpty) {
        mostrarMensagem(context, 
          'Digite o código do grupo.',
        );

        return;
      }

      if (codigo.length != 6) {
        mostrarMensagem(context, 
          'O código do grupo deve ter 6 dígitos.',
        );

        return;
      }

      if (_entrandoGrupo) {
        return;
      }

      setState(() {
        _entrandoGrupo = true;
      });

      try {
        final resposta = await _grupoService.entrarGrupo(
          codigo: codigo,
        );

        if (!mounted) return;

        final grupo =
            Map<String, dynamic>.from(resposta);

        final grupoId =
            grupo['id']?.toString();

        final nomeGrupo =
            grupo['nome']?.toString() ??
            'Grupo';

        final codigoGrupo =
            grupo['codigo']?.toString() ??
            codigo;

        if (grupoId == null) {
          throw Exception(
            'Não foi possível obter o grupo.',
          );
        }

        _codigoGrupoController.clear();

        _abrirGrupo(
          grupoId: grupoId,
          nomeGrupo: nomeGrupo,
          codigoGrupo: codigoGrupo,
        );
      } catch (e) {
        if (!mounted) return;

        mostrarMensagem(context, 
          _mensagemErroGrupo(e),
        );
      } finally {
        if (mounted) {
          setState(() {
            _entrandoGrupo = false;
          });
        }
      }
    }

    // ============================================================
    // ABRIR GRUPO
    // ============================================================

    void _abrirGrupo({
      required String grupoId,
      required String nomeGrupo,
      required String codigoGrupo,
    }) {
      mostrarMensagem(context, 
        'Grupo "$nomeGrupo" criado/entrado com sucesso.',
      );
    }

    // ============================================================
    // MOSTRAR CÓDIGO DO GRUPO CRIADO
    // ============================================================

    void _mostrarCodigoCriado({
      required String grupoId,
      required String nomeGrupo,
      required String codigoGrupo,
    }) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Grupo criado!',
              style: TextStyle(
                color: AppColors.azulEscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Compartilhe este código com os integrantes do grupo:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.cinzaTexto,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.azulClaro,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Text(
                    codigoGrupo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.azulEscuro,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  _abrirGrupo(
                    grupoId: grupoId,
                    nomeGrupo: nomeGrupo,
                    codigoGrupo: codigoGrupo,
                  );
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    color: AppColors.verde,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    String _mensagemErroGrupo(Object erro) {
      final texto = erro.toString().toLowerCase();

      if (texto.contains('grupo não encontrado')) {
        return 'Grupo não encontrado. Verifique o código.';
      }

      if (texto.contains('já está no grupo') ||
          texto.contains('ja esta no grupo')) {
        return 'Você já está nesse grupo.';
      }

      return 'Não foi possível entrar no grupo.';
    }

}
