import 'package:flutter/material.dart';

import '../core/theme.dart';

class GrupoMenu extends StatelessWidget {
  final String nomeGrupo;
  final List<String> membros;
  final bool souAdmin;

  final VoidCallback onFechar;
  final VoidCallback onCriarDespesa;
  final VoidCallback onSairGrupo;

  const GrupoMenu({
    super.key,
    required this.nomeGrupo,
    required this.membros,
    required this.souAdmin,
    required this.onFechar,
    required this.onCriarDespesa,
    required this.onSairGrupo,
  });

  @override
  Widget build(BuildContext context) {
    final alturaStatusBar =
        MediaQuery.of(context).padding.top;

    final alturaNavegacao =
        MediaQuery.of(context).padding.bottom;

    return Material(
      color: AppColors.fundo,
      child: Stack(
        children: [
          // ======================================================
          // FUNDO DO TOPO
          // ======================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/topo_menu.png',
                width: double.infinity,
                height: 180,
                fit: BoxFit.fill,
              ),
            ),
          ),

          // ======================================================
          // LOGO CONTA COMIGO
          // ======================================================

          Positioned(
            top: alturaStatusBar + 28,
            left: 22,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/porco.png',
                  width: 58,
                  height: 58,
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 5),

                const Text(
                  'Conta\nComigo',
                  style: TextStyle(
                    color: AppColors.azulEscuro,
                    fontSize: 27,
                    height: 0.88,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // BOTÃO X
          // ======================================================

          Positioned(
            top: alturaStatusBar + 14,
            right: 18,
            child: GestureDetector(
              onTap: onFechar,
              child: const Icon(
                Icons.close,
                color: AppColors.branco,
                size: 34,
              ),
            ),
          ),

          // ======================================================
          // CONTEÚDO
          // ======================================================

          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              alturaStatusBar + 120,
              24,
              alturaNavegacao + 20,
            ),
            child: Column(
              children: [
                // ==================================================
                // CRIAR DESPESA
                // ==================================================

                if (souAdmin)
                  GestureDetector(
                    onTap: onCriarDespesa,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.verde,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '+ criar despesa',
                        style: TextStyle(
                          color: AppColors.branco,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                if (souAdmin)
                  const SizedBox(height: 25),

                // ==================================================
                // SEPARAÇÃO
                // ==================================================

                Container(
                  width: double.infinity,
                  height: 2,
                  color: AppColors.azulClaro,
                ),

                const SizedBox(height: 28),

                // ==================================================
                // INTEGRANTES
                // ==================================================

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Integrantes do grupo',
                    style: TextStyle(
                      color: AppColors.azulEscuro,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // LISTA DE INTEGRANTES
                // ==================================================

                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: membros.length,
                    itemBuilder: (context, index) {
                      final membro = membros[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.branco,
                            borderRadius:
                                BorderRadius.circular(25),
                            border: Border.all(
                              color:
                                  AppColors.azulClaro,
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
                                      AppColors.verde,
                                  shape:
                                      BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color:
                                      AppColors.branco,
                                  size: 30,
                                ),
                              ),

                              const SizedBox(
                                width: 14,
                              ),

                              Expanded(
                                child: Text(
                                  membro,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      const TextStyle(
                                    color:
                                        AppColors
                                            .azulEscuro,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ==================================================
                // ESPAÇO ANTES DO BOTÃO
                // ==================================================

                const SizedBox(height: 12),

                // ==================================================
                // SAIR DO GRUPO
                // ==================================================

                GestureDetector(
                  onTap: onSairGrupo,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.branco,
                      borderRadius:
                          BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.verde,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Sair do Grupo',
                      style: TextStyle(
                        color: AppColors.verde,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}