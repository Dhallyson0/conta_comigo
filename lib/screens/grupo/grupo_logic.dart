// ignore_for_file: invalid_use_of_protected_member

part of 'grupo_screen.dart';

extension __GrupoScreenStateLogic on _GrupoScreenState {
    // ==============================================================
    // CARREGAR DADOS
    // ==============================================================

    Future<void> _carregarDados() async {
      try {
        final resultados = await Future.wait([
          _despesaService.buscarDespesas(
            grupoId: widget.grupoId,
          ),
          _grupoService.buscarMembrosGrupo(
            grupoId: widget.grupoId,
          ),
          _despesaService.buscarValorDevido(
            grupoId: widget.grupoId,
          ),
        ]);

        if (!mounted) return;

        setState(() {
          _despesas =
              resultados[0]
                  as List<Map<String, dynamic>>;

          _membros =
              resultados[1]
                  as List<Map<String, dynamic>>;

          _valorDevido =
              resultados[2] as double;

          _carregando = false;
        });
      } catch (e) {
        debugPrint(
          'ERRO AO CARREGAR GRUPO: $e',
        );

        if (!mounted) return;

        setState(() {
          _carregando = false;
        });

        mostrarMensagem(
          context,
          'Erro: $e',
        );
      }
    }

    // VERIFICAR ADMIN

    // ==============================================================
    // VERIFICAR ADMIN
    // ==============================================================

    bool get _souAdmin {
      final usuarioId = supabase.auth.currentUser?.id;

      if (usuarioId == null) {
        return false;
      }

      for (final membro in _membros) {
        if (membro['usuario_id'] == usuarioId) {
          return membro['role'] == 'admin';
        }
      }

      return false;
    }

    // TOTAL

    // ==============================================================
    // TOTAL
    // ==============================================================

    double get _total {
      return _despesas.fold(
        0,
        (total, despesa) {
          return total +
              ((despesa['valor'] as num?)
                      ?.toDouble() ??
                  0);
        },
      );
    }

    // DESPESAS FILTRADAS

    // ==============================================================
    // DESPESAS FILTRADAS
    // ==============================================================

    List<Map<String, dynamic>>
        get _despesasFiltradas {
      if (_categoriaSelecionada == null) {
        return _despesas;
      }

      return _despesas.where((despesa) {
        return despesa['categoria'] ==
            _categoriaSelecionada;
      }).toList();
    }

    // ABRIR FILTRO

    // ==============================================================
    // ABRIR FILTRO
    // ==============================================================

    void _abrirFiltro() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return FiltroDespesas(
            categoriaSelecionada:
                _categoriaSelecionada,
            categorias: _categorias,
            onCategoriaSelecionada:
                (categoria) {
              setState(() {
                _categoriaSelecionada =
                    categoria;
              });
            },
          );
        },
      );
    }

    // SAIR DO GRUPO

    // ==============================================================
    // SAIR DO GRUPO
    // ==============================================================

    Future<void> _sairDoGrupo() async {
      // Administrador não pode sair do próprio grupo.
      if (_souAdmin) {
        if (!mounted) return;

        mostrarMensagem(
          context,
          'Administradores não podem sair do grupo. '
          'Exclua o grupo pelo Perfil.',
        );

        return;
      }

      final confirmar = await confirmarDialog(
        context,
        titulo: 'Sair do grupo?',
        mensagem: 'Você realmente deseja sair do grupo "${widget.nomeGrupo}"?',
        textoConfirmar: 'Sair',
      );

      if (!mounted || confirmar != true) {
        return;
      }

      try {
        await _grupoService.sairDoGrupo(
          grupoId: widget.grupoId,
        );

        if (!mounted) return;

        // Retorna para a tela anterior.
        Navigator.of(context).pop(true);
      } catch (e) {
        if (!mounted) return;

        String mensagem = e.toString();

        if (mensagem.startsWith(
          'Exception: ',
        )) {
          mensagem = mensagem.replaceFirst(
            'Exception: ',
            '',
          );
        }

        mostrarMensagem(
          context,
          mensagem,
        );
      }
    }

    // ABRIR MENU

    // ==============================================================
    // ABRIR MENU
    // ==============================================================

    void _abrirMenu() {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Menu do grupo',
        barrierColor: Colors.black54,
        transitionDuration:
            const Duration(
          milliseconds: 250,
        ),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return Align(
            alignment:
                Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.82,
              heightFactor: 1,
              child: GrupoMenu(
                nomeGrupo:
                    widget.nomeGrupo,

                membros:
                    _membros.map((membro) {
                  final perfil =
                      membro['profiles'];

                  if (perfil == null) {
                    return 'Usuário';
                  }

                  return perfil['nome']
                          as String? ??
                      'Usuário';
                }).toList(),

                souAdmin: _souAdmin,

                onFechar: () {
                  Navigator.pop(context);
                },

                onCriarDespesa:
                    _abrirAdicionarDespesa,

                onSairGrupo:
                    _sairDoGrupo,
              ),
            ),
          );
        },
        transitionBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final slideAnimation =
              Tween<Offset>(
            begin:
                const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
          );

          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        },
      );
    }

    // ABRIR FORMULÁRIO

    // ==============================================================
    // ABRIR FORMULÁRIO
    // ==============================================================

    void _abrirAdicionarDespesa() {
      Navigator.pop(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (context) {
          return AdicionarDespesa(
            membros: _membros,

            onFechar: () {
              Navigator.pop(context);
            },

            onCriar: ({
              required String nome,
              required double valor,
              required String categoria,
              required bool recorrente,
              required bool divisaoPersonalizada,
              required Map<String, double>
                  divisoes,
              required DateTime dataVencimento,
            }) async {
              try {
                await _despesaService.criarDespesa(
                  grupoId: widget.grupoId,
                  nome: nome,
                  valor: valor,
                  categoria: categoria,
                  recorrente: recorrente,
                  frequencia:
                      recorrente
                          ? 'mensal'
                          : null,

                  // O banco trabalha com
                  // o dia do mês.
                  diaVencimento:
                      dataVencimento.day,

                  divisoes:
                      divisaoPersonalizada
                          ? divisoes
                          : {},
                );

                if (!context.mounted) return;

                Navigator.pop(context);

                await _carregarDados();

                if (!context.mounted) return;

                mostrarMensagem(
                  context,
                  'Despesa criada com sucesso!',
                );
              } catch (e) {
                rethrow;
              }
            },
          );
        },
      );
    }

}
