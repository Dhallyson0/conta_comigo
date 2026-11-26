// ignore_for_file: invalid_use_of_protected_member

part of 'adicionar_despesa.dart';

extension __AdicionarDespesaStateView on _AdicionarDespesaState {
    // ============================================================
    // NOME DO MEMBRO
    // ============================================================

    String _nomeMembro(
      Map<String, dynamic> membro,
    ) {
      final perfil = membro['profiles'];

      if (perfil is Map) {
        return perfil['nome']?.toString() ??
            'Usuário';
      }

      return 'Usuário';
    }

    // ============================================================
    // LABEL
    // ============================================================

    Widget _label(String texto) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 18,
          bottom: 6,
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: AppColors.azulEscuro,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // ============================================================
    // CAMPO
    // ============================================================

    InputDecoration _campo() {
      return InputDecoration(
        filled: true,
        fillColor: Colors.transparent,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.azulClaro,
            width: 2,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.azulClaro,
            width: 2,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.verde,
            width: 2,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
      );
    }

    // ============================================================
    // CHECKBOX
    // ============================================================

    Widget _checkbox({
      required String texto,
      required bool valor,
      required ValueChanged<bool> onChanged,
    }) {
      return InkWell(
        onTap: _salvando
            ? null
            : () => onChanged(!valor),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: valor
                      ? AppColors.verde
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppColors.azulClaro,
                    width: 2,
                  ),
                ),
                child: valor
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  texto,
                  style: const TextStyle(
                    color:
                        AppColors.azulEscuro,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ============================================================
    // BUILD
    // ============================================================

    Widget _buildView(BuildContext context) {
      return Dialog(
        backgroundColor:
            Colors.transparent,

        insetPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),

        child: Container(
          constraints:
              const BoxConstraints(
            maxHeight: 720,
          ),

          decoration: BoxDecoration(
            color: AppColors.branco,
            borderRadius:
                BorderRadius.circular(30),
          ),

          child: Form(
            key: _formKey,

            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                26,
                22,
                26,
                24,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // FECHAR

                  Align(
                    alignment:
                        Alignment.topRight,

                    child: GestureDetector(
                      onTap: _salvando
                          ? null
                          : widget.onFechar,

                      child: const Icon(
                        Icons.close,
                        color:
                            AppColors.verde,
                        size: 34,
                      ),
                    ),
                  ),

                  // TÍTULO

                  Center(
                    child: Text(
                      widget.modoEdicao
                          ? 'Editar Despesa'
                          : 'Adicionar Despesa',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            AppColors.azulEscuro,
                        fontSize: 23,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Center(
                    child: Text(
                      widget.modoEdicao
                          ? 'Altere os dados da\n'
                            'conta do grupo'
                          : 'Registre uma nova\n'
                            'conta do grupo',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            AppColors.cinzaTexto,
                        fontSize: 15,
                        height: 1.1,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // NOME

                  _label('Nome:'),

                  TextFormField(
                    controller:
                        _nomeController,
                    enabled: !_salvando,
                    decoration:
                        _campo(),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Informe o nome.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  _label('Valor:'),

                  TextFormField(
                    controller:
                        _valorController,
                    enabled: !_salvando,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        _campo(),
                    validator: (value) {
                      final valor =
                          _obterValor();

                      if (valor == null ||
                          valor <= 0) {
                        return 'Informe um valor válido.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // CATEGORIA

                  _label('Categoria:'),

                  DropdownButtonFormField<String>(
                    initialValue:
                        _categoriaSelecionada,

                    decoration:
                        _campo(),

                    icon: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      color:
                          AppColors.verde,
                      size: 30,
                    ),

                    dropdownColor:
                        AppColors.branco,

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),

                    items: _categorias
                        .map(
                          (categoria) =>
                              DropdownMenuItem<
                                  String>(
                            value: categoria,
                            child:
                                Text(categoria),
                          ),
                        )
                        .toList(),

                    onChanged: _salvando
                        ? null
                        : (valor) {
                            setState(() {
                              _categoriaSelecionada =
                                  valor;
                            });
                          },

                    validator: (value) {
                      if (value == null) {
                        return 'Selecione uma categoria.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  _label(
                    'Data de vencimento:',
                  ),

                  TextFormField(
                    controller:
                        _dataController,
                    readOnly: true,
                    enabled: !_salvando,
                    onTap:
                        _selecionarData,
                    decoration:
                        _campo(),
                    validator: (value) {
                      if (_dataVencimento ==
                          null) {
                        return 'Selecione a data.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // RECORRENTE

                  _checkbox(
                    texto:
                        'Aparecer todo mês',
                    valor: _recorrente,
                    onChanged: (valor) {
                      setState(() {
                        _recorrente =
                            valor;
                      });
                    },
                  ),

                  // DIVISÃO PERSONALIZADA

                  _checkbox(
                    texto:
                        'Divisão personalizada',
                    valor:
                        _divisaoPersonalizada,
                    onChanged: (valor) {
                      setState(() {
                        _divisaoPersonalizada =
                            valor;
                      });
                    },
                  ),

                  if (_divisaoPersonalizada) ...[
                    const SizedBox(height: 12),

                    const Text(
                      'Valor de cada integrante:',
                      style: TextStyle(
                        color:
                            AppColors.azulEscuro,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...widget.membros.map(
                      (membro) {
                        final usuarioId =
                            membro[
                                    'usuario_id']
                                ?.toString();

                        if (usuarioId ==
                            null) {
                          return const SizedBox
                              .shrink();
                        }

                        return Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            bottom: 10,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  left: 18,
                                  bottom: 5,
                                ),
                                child: Text(
                                  _nomeMembro(
                                    membro,
                                  ),
                                  style:
                                      const TextStyle(
                                    color:
                                        AppColors
                                            .azulEscuro,
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller:
                                    _divisaoControllers[
                                        usuarioId],
                                enabled:
                                    !_salvando,
                                keyboardType:
                                    const TextInputType
                                        .numberWithOptions(
                                  decimal: true,
                                ),
                                decoration:
                                    _campo(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  // ERRO

                  if (_erro != null) ...[
                    const SizedBox(height: 12),

                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.red
                            .withValues(
                          alpha: 0.08,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Text(
                        _erro!,
                        style:
                            const TextStyle(
                          color:
                              Colors.redAccent,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // BOTÃO

                  SizedBox(
                    width:
                        double.infinity,
                    height: 48,

                    child:
                        ElevatedButton(
                      onPressed: _salvando
                          ? null
                          : _criar,

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            AppColors
                                .verde,
                        foregroundColor:
                            Colors.white,
                        elevation: 2,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),
                        ),
                      ),

                      child: _salvando
                          ? const SizedBox(
                              width: 21,
                              height: 21,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Colors.white,
                              ),
                            )
                          : Text(
                              widget.modoEdicao
                                  ? 'salvar alterações'
                                  : '+ criar conta',
                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
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
}
