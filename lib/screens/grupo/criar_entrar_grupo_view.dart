// ignore_for_file: invalid_use_of_protected_member

part of 'criar_entrar_grupo_screen.dart';

extension _CriarEntrarGrupoView on _CriarEntrarGrupoScreenState {
    Widget _buildView(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.fundo,

        body: AppBackground(
          child: SafeArea(
            child: SingleChildScrollView(
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
                  const Text(
                    'Entrar ou criar grupo:',
                    style: TextStyle(
                      color: AppColors.azulEscuro,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.branco,
                      borderRadius:
                          BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.azulClaro,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Criar grupo',
                          style: TextStyle(
                            color: AppColors.azulEscuro,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'organize suas contas em um grupo.',
                          style: TextStyle(
                            color: AppColors.cinzaTexto,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller:
                              _nomeGrupoController,
                          textInputAction:
                              TextInputAction.done,
                          decoration:
                              InputDecoration(
                            hintText:
                                'Nome do Grupo',
                            hintStyle:
                                const TextStyle(
                              color:
                                  AppColors.cinzaTexto,
                            ),
                            filled: true,
                            fillColor:
                                AppColors.fundo,
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              borderSide:
                                  BorderSide.none,
                            ),
                            prefixIcon:
                                const Icon(
                              Icons.group_outlined,
                              color:
                                  AppColors.verde,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                _criandoGrupo
                                    ? null
                                    : _criarGrupo,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.verde,
                              foregroundColor:
                                  AppColors.branco,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),
                            child: _criandoGrupo
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          AppColors.branco,
                                    ),
                                  )
                                : const Text(
                                    'criar grupo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.branco,
                      borderRadius:
                          BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.azulClaro,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Código do grupo',
                          style: TextStyle(
                            color: AppColors.azulEscuro,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'digite o código para entrar em um grupo.',
                          style: TextStyle(
                            color: AppColors.cinzaTexto,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller:
                              _codigoGrupoController,
                          keyboardType:
                              TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          decoration:
                              InputDecoration(
                            counterText: '',
                            hintText:
                                'Código do grupo',
                            hintStyle:
                                const TextStyle(
                              color:
                                  AppColors.cinzaTexto,
                            ),
                            filled: true,
                            fillColor:
                                AppColors.fundo,
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              borderSide:
                                  BorderSide.none,
                            ),
                            prefixIcon:
                                const Icon(
                              Icons.tag,
                              color:
                                  AppColors.verde,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                _entrandoGrupo
                                    ? null
                                    : _entrarGrupo,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.azulEscuro,
                              foregroundColor:
                                  AppColors.branco,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),
                            child: _entrandoGrupo
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          AppColors.branco,
                                    ),
                                  )
                                : const Text(
                                    'entrar no grupo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // NAVEGAÇÃO CENTRALIZADA
        bottomNavigationBar: const SafeArea(
          top: false,
          child: BottomNavigation(
            indiceAtual: 1,
          ),
        ),
      );
    }
}
