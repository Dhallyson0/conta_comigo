// ignore_for_file: invalid_use_of_protected_member

part of 'detalhes_despesa.dart';

extension __DetalhesDespesaStateLogic on _DetalhesDespesaState {
    // ============================================================
    // CARREGAR INTEGRANTES
    // ============================================================

    Future<void> _carregarIntegrantes() async {
      try {
        final lancamentos =
            widget.despesa['lancamentos'];

        if (lancamentos is! List ||
            lancamentos.isEmpty) {
          if (!mounted) return;

          setState(() {
            _carregando = false;
          });

          return;
        }

        final lancamento =
            Map<String, dynamic>.from(
          lancamentos.first,
        );

        final lancamentoId =
            lancamento['id']?.toString();

        if (lancamentoId == null) {
          throw Exception(
            'Lançamento da despesa não encontrado.',
          );
        }

        final integrantes =
            await _despesaService
                .buscarIntegrantesDespesa(
          lancamentoId: lancamentoId,
        );

        if (!mounted) return;

        setState(() {
          _integrantes = integrantes;
          _carregando = false;
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _erro = e.toString();
          _carregando = false;
        });
      }
    }

    // ============================================================
    // EXCLUIR DESPESA
    // ============================================================

    Future<void> _excluirDespesa() async {
      if (!_souAdmin || _excluindo) {
        return;
      }

      final confirmar = await confirmarDialog(
        context,
        titulo: 'Excluir despesa?',
        mensagem: 'Essa ação não poderá ser desfeita.',
        textoConfirmar: 'Excluir',
      );

      if (confirmar != true) {
        return;
      }

      final despesaId = widget.despesa['id']?.toString();

      if (despesaId == null) {
        return;
      }

      setState(() {
        _excluindo = true;
      });

      try {
        await _despesaService.excluirDespesa(
          despesaId: despesaId,
        );

        if (!mounted) return;

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _excluindo = false;
        });

        mostrarMensagem(
          context,
          'Não foi possível excluir a despesa.\n$e',
        );
      }
    }

    // ============================================================
    // VERIFICAR DIVISÃO IGUAL
    // ============================================================

    bool _divisaoEhIgual(double valor) {
      if (_integrantes.isEmpty) {
        return true;
      }

      final valorBase = valor / _integrantes.length;

      for (final integrante in _integrantes) {
        final valorDevido =
            (integrante['valor_devido'] as num?)?.toDouble() ?? 0;

        if ((valorDevido - valorBase).abs() > 0.011) {
          return false;
        }
      }

      return true;
    }

    // ============================================================
    // EDITAR DESPESA
    // ============================================================

    Future<void> _editarDespesa() async {
      if (!_souAdmin || _excluindo) {
        return;
      }

      final membros = _integrantes.map((integrante) {
        return <String, dynamic>{
          'usuario_id': integrante['usuario_id'],
          'profiles': integrante['profiles'],
        };
      }).toList();

      final divisoes = <String, double>{};

      for (final integrante in _integrantes) {
        final usuarioId = integrante['usuario_id']?.toString();
        final valorDevido =
            (integrante['valor_devido'] as num?)?.toDouble();

        if (usuarioId != null && valorDevido != null) {
          divisoes[usuarioId] = valorDevido;
        }
      }

      final valorAtual =
          (widget.despesa['valor'] as num?)?.toDouble() ?? 0;

      final divisaoPersonalizada =
          !_divisaoEhIgual(valorAtual);

      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AdicionarDespesa(
            membros: membros,
            despesaInicial: widget.despesa,
            divisoesIniciais: divisoes,
            modoEdicao: true,
            divisaoPersonalizadaInicial: divisaoPersonalizada,
            onFechar: () {
              Navigator.pop(dialogContext);
            },
            onCriar: ({
              required String nome,
              required double valor,
              required String categoria,
              required bool recorrente,
              required bool divisaoPersonalizada,
              required Map<String, double> divisoes,
              required DateTime dataVencimento,
            }) async {
              await _salvarEdicao(
                nome: nome,
                valor: valor,
                categoria: categoria,
                recorrente: recorrente,
                divisaoPersonalizada: divisaoPersonalizada,
                divisoes: divisoes,
                dataVencimento: dataVencimento,
              );

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext);
            },
          );
        },
      );
    }

    // ============================================================
    // SALVAR EDIÇÃO
    // ============================================================

    Future<void> _salvarEdicao({
      required String nome,
      required double valor,
      required String categoria,
      required bool recorrente,
      required bool divisaoPersonalizada,
      required Map<String, double> divisoes,
      required DateTime dataVencimento,
    }) async {
      final despesaId = widget.despesa['id']?.toString();
      final lancamento = _obterLancamento();
      final lancamentoId = lancamento?['id']?.toString();

      if (despesaId == null || lancamentoId == null) {
        throw Exception('Dados da despesa não encontrados.');
      }

      await _despesaService.editarDespesa(
        despesaId: despesaId,
        nome: nome,
        valor: valor,
        categoria: categoria,
        recorrente: recorrente,
        frequencia: recorrente
            ? (widget.despesa['frequencia']?.toString() ?? 'mensal')
            : null,
        diaVencimento: dataVencimento.day,
      );

      await _despesaService.atualizarLancamento(
        lancamentoId: lancamentoId,
        valor: valor,
        dataVencimento: dataVencimento,
      );

      final valoresPorDivisao = <String, double>{};

      if (divisaoPersonalizada) {
        for (final integrante in _integrantes) {
          final divisaoId = integrante['id']?.toString();
          final usuarioId = integrante['usuario_id']?.toString();

          if (divisaoId == null || usuarioId == null) {
            continue;
          }

          final valorDivisao = divisoes[usuarioId];

          if (valorDivisao != null) {
            valoresPorDivisao[divisaoId] = valorDivisao;
          }
        }
      } else if (_integrantes.isNotEmpty) {
        final quantidade = _integrantes.length;
        final valorBase =
            (valor * 100 / quantidade).floorToDouble() / 100;
        var restante =
            ((valor * 100) - (valorBase * 100 * quantidade)).round();

        for (var i = 0; i < _integrantes.length; i++) {
          final integrante = _integrantes[i];
          final divisaoId = integrante['id']?.toString();

          if (divisaoId == null) {
            continue;
          }

          var valorDivisao = valorBase;

          if (i == 0 && restante > 0) {
            valorDivisao += restante / 100;
            restante = 0;
          }

          valoresPorDivisao[divisaoId] = valorDivisao;
        }
      }

      if (valoresPorDivisao.isNotEmpty) {
        await _despesaService.atualizarDivisoes(
          valoresPorDivisao: valoresPorDivisao,
        );
      }

      widget.despesa['nome'] = nome;
      widget.despesa['valor'] = valor;
      widget.despesa['categoria'] = categoria;
      widget.despesa['recorrente'] = recorrente;

      final lancamentos = widget.despesa['lancamentos'];

      if (lancamentos is List && lancamentos.isNotEmpty) {
        final primeiro =
            Map<String, dynamic>.from(lancamentos.first);

        primeiro['valor'] = valor;
        primeiro['data_vencimento'] =
            dataVencimento.toIso8601String().split('T').first;

        lancamentos[0] = primeiro;
      }

      await _carregarIntegrantes();

      if (mounted) {
        setState(() {});
      }
    }

    // ============================================================
    // ALTERAR PAGAMENTO INDIVIDUAL
    // ============================================================

    Future<void> _alterarPagamento(
      Map<String, dynamic> integrante,
      bool novoValor,
    ) async {
      final usuarioLogado =
          supabase.auth.currentUser?.id;

      final usuarioId =
          integrante['usuario_id']?.toString();

      // Só permite alterar a própria divisão.
      if (usuarioLogado == null ||
          usuarioId == null ||
          usuarioLogado != usuarioId) {
        return;
      }

      final divisaoId =
          integrante['id']?.toString();

      if (divisaoId == null) {
        return;
      }

      if (_atualizando.contains(divisaoId)) {
        return;
      }

      final valorAnterior =
          integrante['pago'] == true;

      // Atualização visual imediata.
      setState(() {
        integrante['pago'] = novoValor;
        _atualizando.add(divisaoId);
      });

      try {
        await _despesaService
            .atualizarPagamentoIndividual(
          divisaoId: divisaoId,
          pago: novoValor,
        );

        if (!mounted) return;

        setState(() {
          _atualizando.remove(divisaoId);
        });
      } catch (e) {
        if (!mounted) return;

        // Se der erro, volta ao estado anterior.
        setState(() {
          integrante['pago'] = valorAnterior;
          _atualizando.remove(divisaoId);
        });

        mostrarMensagem(
          context,
          'Não foi possível atualizar o pagamento.\n$e',
        );
      }
    }

    // ============================================================
    // OBTER LANÇAMENTO
    // ============================================================

    Map<String, dynamic>? _obterLancamento() {
      final lancamentos =
          widget.despesa['lancamentos'];

      if (lancamentos is List &&
          lancamentos.isNotEmpty) {
        return Map<String, dynamic>.from(
          lancamentos.first,
        );
      }

      return null;
    }

    // ============================================================
    // OBTER DIVISÃO DO USUÁRIO LOGADO
    // ============================================================

    Map<String, dynamic>? _obterMinhaDivisao() {
      final usuarioLogado =
          supabase.auth.currentUser?.id;

      if (usuarioLogado == null) {
        return null;
      }

      for (final integrante in _integrantes) {
        final usuarioId =
            integrante['usuario_id']?.toString();

        if (usuarioId == usuarioLogado) {
          return integrante;
        }
      }

      return null;
    }

}
