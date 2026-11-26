import 'package:flutter/material.dart';
import '../core/styles.dart';

class AuthButton extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final bool carregando;

  const AuthButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        style: AppStyles.botaoPrincipal,
        child: carregando
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                texto,
                style: AppStyles.textoBotao,
              ),
      ),
    );
  }
}