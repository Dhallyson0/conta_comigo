import 'package:flutter/material.dart';

void mostrarMensagem(BuildContext context, String mensagem) {
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
    ),
  );
}

Future<bool> confirmarDialog(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  String textoConfirmar = 'Confirmar',
  Color corConfirmar = Colors.redAccent,
  TextStyle? tituloStyle,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          titulo,
          style: tituloStyle,
        ),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              textoConfirmar,
              style: TextStyle(
                color: corConfirmar,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );

  return resultado == true;
}
