import '../core/supabase.dart';

class DespesaService {
  final _supabase = supabase;

  // ============================================================
  // CRIAR DESPESA
  // ============================================================

  Future<Map<String, dynamic>> criarDespesa({
    required String grupoId,
    required String nome,
    required double valor,
    required String categoria,
    bool recorrente = false,
    String? frequencia,
    int? diaVencimento,
    Map<String, double> divisoes = const {},
  }) async {
    final resposta = await _supabase.rpc(
      'criar_despesa_com_divisao',
      params: {
        'p_grupo_id': grupoId,
        'p_nome': nome,
        'p_valor': valor,
        'p_categoria': categoria,
        'p_recorrente': recorrente,
        'p_frequencia': frequencia,
        'p_dia_vencimento': diaVencimento,
        'p_divisoes': divisoes,
      },
    );

    return Map<String, dynamic>.from(
      resposta,
    );
  }

  // ============================================================
  // BUSCAR DESPESAS DO GRUPO
  // ============================================================

  Future<List<Map<String, dynamic>>> buscarDespesas({
    required String grupoId,
  }) async {
    final resposta = await _supabase
        .from('despesas')
        .select('''
          *,
          lancamentos(
            id,
            valor,
            data_vencimento,
            mes_referencia,
            pago,
            data_pagamento
          )
        ''')
        .eq(
          'grupo_id',
          grupoId,
        )
        .eq(
          'ativa',
          true,
        )
        .order(
          'created_at',
          ascending: false,
        );

    return List<Map<String, dynamic>>.from(
      resposta,
    );
  }

  // ============================================================
  // BUSCAR VALOR QUE O USUÁRIO DEVE
  // ============================================================
  //
  // Agora o cálculo considera:
  //
  // divisoes_lancamento.pago = false
  //
  // e não mais:
  //
  // lancamentos.pago = false
  //
  // Isso permite que cada integrante tenha seu
  // próprio estado de pagamento.
  // ============================================================

  Future<double> buscarValorDevido({
    required String grupoId,
  }) async {
    final usuarioId =
        _supabase.auth.currentUser?.id;

    if (usuarioId == null) {
      throw Exception(
        'Usuário não está autenticado.',
      );
    }

    final resposta = await _supabase.rpc(
      'buscar_valor_devido',
      params: {
        'p_grupo_id': grupoId,
      },
    );

    return (resposta as num).toDouble();
  }

  // ============================================================
  // BUSCAR INTEGRANTES DA DESPESA
  // ============================================================
  //
  // Cada integrante possui:
  //
  // id
  // usuario_id
  // valor_devido
  // pago
  // data_pagamento
  // profiles.nome
  //
  // ============================================================

  Future<List<Map<String, dynamic>>>
      buscarIntegrantesDespesa({
    required String lancamentoId,
  }) async {
    final resposta = await _supabase
        .from('divisoes_lancamento')
        .select('''
          id,
          usuario_id,
          valor_devido,
          pago,
          data_pagamento,
          profiles(
            nome
          )
        ''')
        .eq(
          'lancamento_id',
          lancamentoId,
        )
        .order(
          'created_at',
          ascending: true,
        );

    return List<Map<String, dynamic>>.from(
      resposta,
    );
  }

  // ============================================================
  // ATUALIZAR PAGAMENTO INDIVIDUAL
  // ============================================================
  //
  // IMPORTANTE:
  //
  // Não alteramos mais a tabela "lancamentos".
  //
  // Alteramos somente a divisão pertencente
  // ao usuário atualmente logado.
  //
  // Dessa forma:
  //
  // Usuário A pode pagar a própria dívida
  // sem marcar a dívida do Usuário B como paga.
  //
  // ============================================================

  Future<void> atualizarPagamentoIndividual({
    required String divisaoId,
    required bool pago,
  }) async {
    final usuarioId =
        _supabase.auth.currentUser?.id;

    if (usuarioId == null) {
      throw Exception(
        'Usuário não está autenticado.',
      );
    }

    await _supabase
        .from('divisoes_lancamento')
        .update({
          'pago': pago,
          'data_pagamento': pago
              ? DateTime.now()
                  .toIso8601String()
                  .split('T')
                  .first
              : null,
        })
        .eq(
          'id',
          divisaoId,
        )
        .eq(
          'usuario_id',
          usuarioId,
        );
  }

  // ============================================================
  // ATUALIZAR LANÇAMENTO
  // ============================================================

  Future<void> atualizarLancamento({
    required String lancamentoId,
    required double valor,
    required DateTime dataVencimento,
  }) async {
    await _supabase
        .from('lancamentos')
        .update({
          'valor': valor,
          'data_vencimento':
              dataVencimento.toIso8601String().split('T').first,
        })
        .eq('id', lancamentoId);
  }

  // ============================================================
  // ATUALIZAR DIVISÕES
  // ============================================================

  Future<void> atualizarDivisoes({
    required Map<String, double> valoresPorDivisao,
  }) async {
    await Future.wait(
      valoresPorDivisao.entries.map(
        (entry) => _supabase
            .from('divisoes_lancamento')
            .update({
              'valor_devido': entry.value,
            })
            .eq('id', entry.key),
      ),
    );
  }

  // ============================================================
  // EDITAR DESPESA
  // ============================================================

  Future<void> editarDespesa({
    required String despesaId,
    required String nome,
    required double valor,
    required String categoria,
    required bool recorrente,
    String? frequencia,
    int? diaVencimento,
  }) async {
    await _supabase
        .from('despesas')
        .update({
          'nome': nome,
          'valor': valor,
          'categoria': categoria,
          'recorrente': recorrente,
          'frequencia': frequencia,
          'dia_vencimento': diaVencimento,
        })
        .eq(
          'id',
          despesaId,
        );
  }

  // ============================================================
  // EXCLUIR DESPESA
  // ============================================================

  Future<void> excluirDespesa({
    required String despesaId,
  }) async {
    await _supabase
        .from('despesas')
        .delete()
        .eq(
          'id',
          despesaId,
        );
  }
}