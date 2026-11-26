import 'package:flutter/material.dart';

import '../core/theme.dart';

class FiltroDespesas extends StatelessWidget {
  final String? categoriaSelecionada;
  final List<String> categorias;
  final ValueChanged<String?> onCategoriaSelecionada;

  const FiltroDespesas({
    super.key,
    required this.categoriaSelecionada,
    required this.categorias,
    required this.onCategoriaSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.fromLTRB(
          24,
          12,
          24,
          16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.branco,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.azulClaro,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filtrar despesas',
                style: TextStyle(
                  color: AppColors.azulEscuro,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  RadioListTile<String?>(
                    value: null,
                    groupValue: categoriaSelecionada,
                    activeColor: AppColors.verde,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Todas',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    onChanged: (valor) {
                      onCategoriaSelecionada(null);
                      Navigator.pop(context);
                    },
                  ),

                  ...categorias.map(
                    (categoria) {
                      return RadioListTile<String>(
                        value: categoria,
                        groupValue: categoriaSelecionada,
                        activeColor: AppColors.verde,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          categoria,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        onChanged: (valor) {
                          onCategoriaSelecionada(valor);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}