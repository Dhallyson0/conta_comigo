// ignore_for_file: invalid_use_of_protected_member

part of 'detalhes_despesa.dart';

extension __DetalhesDespesaStateView on _DetalhesDespesaState {
    // ============================================================
    // BUILD
    // ============================================================

    Widget _buildView(BuildContext context) {
      final nome =
          widget.despesa['nome']
                  ?.toString() ??
              'Despesa';

      final valor =
          (widget.despesa['valor'] as num?)
                  ?.toDouble() ??
              0;

      final categoria =
          widget.despesa['categoria']
                  ?.toString() ??
              '';

      final lancamento =
          _obterLancamento();

      final dataVencimento =
          lancamento?['data_vencimento'];

      // CALCULAR O VALOR QUE FALTA

      double totalPago = 0;

      for (final integrante in _integrantes) {
        if (integrante['pago'] == true) {
          totalPago +=
              (integrante['valor_devido'] as num?)
                      ?.toDouble() ??
                  0;
        }
      }

      final falta =
          (valor - totalPago)
              .clamp(0, valor)
              .toDouble();

      // USUÁRIO LOGADO

      final minhaDivisao =
          _obterMinhaDivisao();

      final minhaPago =
          minhaDivisao?['pago'] == true;

      final minhaDivisaoId =
          minhaDivisao?['id']?.toString();

      final minhaAtualizando =
          minhaDivisaoId != null &&
              _atualizando.contains(
                minhaDivisaoId,
              );

      return Scaffold(
        backgroundColor:
            AppColors.fundo,

        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              30,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      child: Container(
                        width: 58,
                        height: 42,

                        decoration:
                            BoxDecoration(
                          color:
                              AppColors.azulClaro,

                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),

                        child:
                            const Icon(
                          Icons.chevron_left,
                          color:
                              AppColors.verde,
                          size: 38,
                        ),
                      ),
                    ),

                    const Spacer(),

                    const Text(
                      'Detalhes',

                      style:
                          TextStyle(
                        color:
                            AppColors.azulEscuro,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    if (_souAdmin)
                      GestureDetector(
                        onTap: _excluindo
                            ? null
                            : _excluirDespesa,
                        child: Container(
                          width: 58,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: _excluindo
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.redAccent,
                                  ),
                                )
                              : const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                        ),
                      )
                    else
                      const SizedBox(width: 58),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // CARD DA DESPESA

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.branco,

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black
                                .withValues(
                          alpha: 0.06,
                        ),

                        blurRadius: 8,

                        offset:
                            const Offset(
                          0,
                          3,
                        ),
                      ),
                    ],
                  ),

                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,

                    children: [
                      // ÍCONE DA CATEGORIA

                      Container(
                        width: 76,
                        height: 60,

                        decoration:
                            const BoxDecoration(
                          color:
                              AppColors.azulClaro,

                          shape:
                              BoxShape.circle,
                        ),

                        child: Icon(
                          _iconeCategoria(
                            categoria,
                          ),

                          color:
                              AppColors.verde,

                          size: 38,
                        ),
                      ),

                      const SizedBox(
                        width: 20,
                      ),

                      // NOME / VALOR / VENCIMENTO

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              nome,

                              maxLines: 1,

                              overflow:
                                  TextOverflow.ellipsis,

                              style:
                                  const TextStyle(
                                color:
                                    AppColors
                                        .azulEscuro,

                                fontSize: 22,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 2,
                            ),

                            Text(
                              formatarValor(
                                valor,
                              ),

                              style:
                                  const TextStyle(
                                color:
                                    AppColors.verde,

                                fontSize: 17,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 2,
                            ),

                            Text(
                              'Vencimento: '
                              '${formatarData(dataVencimento)}',

                              style:
                                  const TextStyle(
                                color:
                                    AppColors
                                        .azulEscuro,

                                fontSize: 15,

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_souAdmin) ...[
                        const SizedBox(width: 8),

                        GestureDetector(
                          onTap: _editarDespesa,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.azulClaro,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.verde,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                // FALTA + CHECKBOX

                Row(
                  children: [
                    const Text(
                      'Falta:',

                      style:
                          TextStyle(
                        color:
                            AppColors.azulEscuro,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      formatarValor(
                        falta,
                      ),

                      style:
                          const TextStyle(
                        color:
                            AppColors.verde,

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    // CHECKBOX DO USUÁRIO LOGADO

                    if (minhaDivisao != null)
                      Row(
                        children: [
                          Text(
                            minhaPago
                                ? 'Pago'
                                : 'Pagar',

                            style:
                                TextStyle(
                              color: minhaPago
                                  ? AppColors
                                      .verde
                                  : AppColors
                                      .azulEscuro,

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          SizedBox(
                            width: 32,
                            height: 32,

                            child:
                                minhaAtualizando
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.all(
                                          5,
                                        ),

                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,

                                          color:
                                              AppColors
                                                  .verde,
                                        ),
                                      )
                                    : Checkbox(
                                        value:
                                            minhaPago,

                                        activeColor:
                                            AppColors
                                                .verde,

                                        side:
                                            const BorderSide(
                                          color:
                                              AppColors
                                                  .azulClaro,

                                          width: 2,
                                        ),

                                        onChanged:
                                            (novoValor) {
                                          if (novoValor ==
                                              null) {
                                            return;
                                          }

                                          _alterarPagamento(
                                            minhaDivisao,
                                            novoValor,
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // TÍTULO INTEGRANTES

                const Row(
                  children: [
                    Text(
                      'Integrantes do grupo',

                      style:
                          TextStyle(
                        color:
                            AppColors.azulEscuro,

                        fontSize: 21,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child:
                          Divider(
                        color:
                            AppColors
                                .azulClaro,

                        thickness: 2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 16,
                ),

                // CARREGANDO

                if (_carregando)
                  const Center(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        25,
                      ),

                      child:
                          CircularProgressIndicator(
                        color:
                            AppColors.verde,
                      ),
                    ),
                  )

                // ERRO

                else if (_erro != null)
                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.red
                              .withValues(
                        alpha: 0.08,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: Text(
                      'Não foi possível '
                      'carregar os integrantes.\n\n'
                      '$_erro',

                      style:
                          const TextStyle(
                        color:
                            Colors.redAccent,

                        fontSize: 13,
                      ),
                    ),
                  )

                // NENHUM INTEGRANTE

                else if (_integrantes.isEmpty)
                  const Center(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        20,
                      ),

                      child:
                          Text(
                        'Nenhum integrante encontrado.',

                        style:
                            TextStyle(
                          color:
                              AppColors
                                  .cinzaTexto,

                          fontSize: 15,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  )

                // LISTA DE INTEGRANTES

                else
                  ..._integrantes.map(
                    (integrante) {
                      final perfil =
                          integrante[
                              'profiles'];

                      String nome =
                          'Usuário';

                      if (perfil
                          is Map) {
                        nome =
                            perfil['nome']
                                    ?.toString() ??
                                'Usuário';
                      }

                      final valorDevido =
                          (integrante[
                                      'valor_devido']
                                  as num?)
                              ?.toDouble() ??
                              0;

                      final pago =
                          integrante[
                                  'pago'] ==
                              true;

                      return Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          bottom: 12,
                        ),

                        child:
                            _integranteCard(
                          nome:
                              nome,

                          valor:
                              valorDevido,

                          pago:
                              pago,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // CARD DOS INTEGRANTES

    // ============================================================
    // CARD DOS INTEGRANTES
    // ============================================================

    Widget _integranteCard({
      required String nome,
      required double valor,
      required bool pago,
    }) {
      return Container(
        width:
            double.infinity,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),

        decoration:
            BoxDecoration(
          color:
              AppColors.branco,

          borderRadius:
              BorderRadius.circular(
            22,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withValues(
                alpha: 0.04,
              ),

              blurRadius: 5,

              offset:
                  const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center,

          children: [
            // FOTO / ÍCONE

            Container(
              width: 54,
              height: 54,

              decoration:
                  const BoxDecoration(
                color:
                    AppColors.verde,

                shape:
                    BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons.person,

                color:
                    Colors.white,

                size: 32,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            // NOME + VALOR

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    nome,

                    // Permite nomes grandes
                    // aparecerem em até duas linhas.
                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .azulEscuro,

                      fontSize: 17,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    formatarValor(
                      valor,
                    ),

                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .cinzaTexto,

                      fontSize: 13,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            // STATUS

            Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 13,
                vertical: 6,
              ),

              decoration:
                  BoxDecoration(
                color: pago
                    ? const Color(
                        0xFFDDF3EE,
                      )
                    : const Color(
                        0xFFFCE3E3,
                      ),

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Text(
                pago
                    ? 'Pago'
                    : 'não pago',

                style:
                    TextStyle(
                  color: pago
                      ? AppColors.verde
                      : Colors.redAccent,

                  fontSize: 12,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ÍCONE DA CATEGORIA

    IconData _iconeCategoria(
      String categoria,
    ) {
      switch (
          categoria.toLowerCase()) {
        case 'água':
          return Icons.water_drop;

        case 'energia':
          return Icons.bolt;

        case 'alimentação':
          return Icons.restaurant;

        case 'internet':
          return Icons.wifi;

        case 'moradia':
          return Icons.home;

        case 'transporte':
          return Icons.directions_car;

        default:
          return Icons.receipt_long;
      }
    }
}
