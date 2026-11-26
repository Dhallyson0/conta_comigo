// ignore_for_file: invalid_use_of_protected_member

part of 'perfil_screen.dart';

extension _PerfilView on _PerfilScreenState {
    // ============================================================
    // BUILD
    // ============================================================

    Widget _buildView(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.fundo,
        body: AppBackground(
          child: SafeArea(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.verde,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      30,
                      24,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 128,
                                height: 128,
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      AppColors.verdeClaro,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color:
                                      AppColors.branco,
                                  size: 76,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '@$_nome',
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  color:
                                      AppColors.azulEscuro,
                                  fontSize: 25,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 38),

                        const Text(
                          'Configurações:',
                          style: TextStyle(
                            color:
                                AppColors.azulEscuro,
                            fontSize: 23,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _opcaoConfiguracao(
                          icone:
                              Icons.edit_outlined,
                          titulo:
                              'Editar perfil',
                          onTap:
                              _editarPerfil,
                        ),

                        const SizedBox(height: 10),

                        _opcaoConfiguracao(
                          icone:
                              Icons.edit_outlined,
                          titulo:
                              'editar grupos',
                          onTap:
                              _abrirEditarGrupos,
                        ),

                        const SizedBox(height: 10),

                        _opcaoConfiguracao(
                          icone: Icons.logout,
                          titulo: 'Sair',
                          onTap: _sair,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        bottomNavigationBar:
            const SafeArea(
          top: false,
          child: BottomNavigation(
            indiceAtual: 2,
          ),
        ),
      );
    }
}

// ================================================================
// SHEET - EDITAR GRUPOS
// ================================================================

class _EditarGruposSheet extends StatelessWidget {
  final List<Map<String, dynamic>> grupos;
  final Future<void> Function(
    Map<String, dynamic> grupo,
  ) onEditar;
  final Future<void> Function(
    Map<String, dynamic> grupo,
  ) onExcluir;

  const _EditarGruposSheet({
    required this.grupos,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 600,
      ),
      decoration: const BoxDecoration(
        color: AppColors.fundo,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        30,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.azulClaro,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Editar grupos',
            style: TextStyle(
              color: AppColors.azulEscuro,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Somente administradores podem editar ou excluir um grupo.',
            style: TextStyle(
              color: AppColors.cinzaTexto,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: grupos.isEmpty
                ? const Center(
                    child: Text(
                      'Você ainda não participa de nenhum grupo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            AppColors.cinzaTexto,
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: grupos.length,
                    separatorBuilder:
                        (_, _) =>
                            const SizedBox(
                      height: 12,
                    ),
                    itemBuilder:
                        (context, index) {
                      final grupo =
                          grupos[index];

                      final souAdmin =
                          grupo['role'] ==
                              'admin';

                      return Container(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              AppColors.branco,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                          border: Border.all(
                            color:
                                AppColors
                                    .azulClaro,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    AppColors
                                        .azulClaro,
                                shape:
                                    BoxShape
                                        .circle,
                              ),
                              child: const Icon(
                                Icons
                                    .groups_outlined,
                                color:
                                    AppColors
                                        .verde,
                                size: 28,
                              ),
                            ),

                            const SizedBox(
                              width: 14,
                            ),

                            Expanded(
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    grupo['nome'] ??
                                        'Grupo',
                                    maxLines:
                                        2,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          AppColors
                                              .azulEscuro,
                                      fontSize:
                                          17,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 3,
                                  ),

                                  Text(
                                    souAdmin
                                        ? 'Administrador'
                                        : 'Membro',
                                    style:
                                        TextStyle(
                                      color: souAdmin
                                          ? AppColors
                                              .verde
                                          : AppColors
                                              .cinzaTexto,
                                      fontSize:
                                          13,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (souAdmin) ...[
                              IconButton(
                                onPressed: () {
                                  onEditar(
                                    grupo,
                                  );
                                },
                                icon:
                                    const Icon(
                                  Icons
                                      .edit_outlined,
                                  color:
                                      AppColors
                                          .verde,
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  onExcluir(
                                    grupo,
                                  );
                                },
                                icon:
                                    const Icon(
                                  Icons
                                      .delete_outline,
                                  color: Colors
                                      .redAccent,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
