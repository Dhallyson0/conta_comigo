import 'package:flutter/material.dart';

import '../core/theme.dart';

class TextInputDialog extends StatefulWidget {
  final String titulo;
  final String nomeAtual;
  final String labelText;
  final String hintText;

  const TextInputDialog({
    super.key,
    required this.titulo,
    required this.nomeAtual,
    required this.labelText,
    required this.hintText,
  });

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nomeAtual);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _salvar() {
    final valor = _controller.text.trim();

    if (valor.isEmpty) return;

    Navigator.of(context).pop(valor);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.titulo,
        style: const TextStyle(
          color: AppColors.azulEscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _salvar(),
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          filled: true,
          fillColor: AppColors.fundo,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _salvar,
          child: const Text(
            'Salvar',
            style: TextStyle(
              color: AppColors.verde,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
