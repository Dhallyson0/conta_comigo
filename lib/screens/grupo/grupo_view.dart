// ignore_for_file: invalid_use_of_protected_member

part of 'grupo_screen.dart';

extension __GrupoScreenStateView on _GrupoScreenState {
    // ==============================================================
    // BUILD
    // ==============================================================

    Widget _buildView(BuildContext context) {
      final despesas = _despesasFiltradas;

      return Scaffold(
        backgroundColor: AppColors.fundo,
        body: AppBackground(
          child: SafeArea(
            child: RefreshIndicator(
              color: AppColors.verde,
              backgroundColor: AppColors.branco,
              onRefresh: _carregarDados,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      20,
                      24,
                      0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        _cabecalho(),
                        const SizedBox(height: 28),
                        _resumo(),
                        const SizedBox(height: 32),
                        _tituloDespesas(),
                        const SizedBox(height: 14),
                      ]),
                    ),
                  ),
                  if (_carregando)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.verde,
                        ),
                      ),
                    )
                  else if (despesas.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'Nenhuma despesa encontrada.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.cinzaTexto,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        30,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _despesaCard(despesas[index]),
                            );
                          },
                          childCount: despesas.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ==============================================================
    // CABEÇALHO
    // ==============================================================

    Widget _cabecalho() {
      return Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
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
                        BorderRadius
                            .circular(30),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color:
                        AppColors.verde,
                    size: 38,
                  ),
                ),
              ),

              GestureDetector(
                onTap: _abrirMenu,
                child: Container(
                  width: 58,
                  height: 42,
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.azulClaro,
                    borderRadius:
                        BorderRadius
                            .circular(30),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color:
                        AppColors.verde,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.groups,
                color:
                    AppColors.verde,
                size: 58,
              ),

              const SizedBox(
                width: 16,
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nomeGrupo,
                    style:
                        const TextStyle(
                      color:
                          AppColors.azulEscuro,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    'Código: ${widget.codigoGrupo}',
                    style:
                        const TextStyle(
                      color:
                          AppColors.cinzaTexto,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    // ==============================================================
    // RESUMO
    // ==============================================================

    Widget _resumo() {
      return Row(
        children: [
          Expanded(
            child: _cardResumo(
              titulo: 'Total',
              valor:
                  formatarValor(
                _total,
              ),
              corTitulo:
                  AppColors.verde,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: _cardResumo(
              titulo: 'Você deve',
              valor:
                  formatarValor(
                _valorDevido,
              ),
              corTitulo:
                  Colors.redAccent,
            ),
          ),
        ],
      );
    }

    Widget _cardResumo({
      required String titulo,
      required String valor,
      required Color corTitulo,
    }) {
      return Container(
        height: 105,
        padding:
            const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.branco,
          borderRadius:
              BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.06,
              ),
              blurRadius: 8,
              offset:
                  const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              titulo,
              style: TextStyle(
                color: corTitulo,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            FittedBox(
              fit:
                  BoxFit.scaleDown,
              alignment:
                  Alignment.centerLeft,
              child: Text(
                valor,
                style:
                    const TextStyle(
                  color:
                      AppColors.azulEscuro,
                  fontSize: 21,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ==============================================================
    // TÍTULO DESPESAS
    // ==============================================================

    Widget _tituloDespesas() {
      return Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          const Text(
            'Despesas:',
            style:
                TextStyle(
              color:
                  AppColors.azulEscuro,
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          GestureDetector(
            onTap: _abrirFiltro,
            child: Image.asset(
              'assets/images/filtro.png',
              width: 28,
              height: 28,
            ),
          ),
        ],
      );
    }

    // ==============================================================
    // CARD DESPESA
    // ==============================================================

    // ==============================================================
    // LISTA DESPESAS
    // ==============================================================
    Widget _despesaCard(
      Map<String, dynamic> despesa,
    ) {
      final nome =
          despesa['nome']
                  as String? ??
              '';

      final valor =
          (despesa['valor']
                      as num?)
                  ?.toDouble() ??
              0;

      final categoria =
          despesa['categoria']
                  as String? ??
              '';

      final dataVencimento =
          despesa[
              'dia_vencimento'];

      return InkWell(
        onTap: () async {
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetalhesDespesa(
                  despesa: despesa,
                  souAdmin: _souAdmin,
                );
              },
            ),
          );

          if (resultado == true && mounted) {
            await _carregarDados();
          }
        },
        borderRadius:
            BorderRadius.circular(
          30,
        ),
        child: AppCard(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 76,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          borderRadius: BorderRadius.circular(30),
          borderColor: AppColors.azulClaro,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.06,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Text(
                      nome,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            AppColors.azulEscuro,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      categoria,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            AppColors.cinzaTexto,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    if (dataVencimento !=
                        null) ...[
                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        'Vencimento: dia $dataVencimento',
                        style:
                            const TextStyle(
                          color:
                              AppColors.cinzaTexto,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Text(
                formatarValor(
                  valor,
                ),
                style:
                    const TextStyle(
                  color:
                      AppColors.azulEscuro,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                width: 4,
              ),

              const Icon(
                Icons.chevron_right,
                color:
                    AppColors.verde,
                size: 34,
              ),
            ],
          ),
        ),
      );
    }
}
