import 'package:flutter/material.dart';
import 'theme.dart';

class AppStyles {
  static const TextStyle textoInput = TextStyle(
    color: AppColors.cinzaTexto,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle textoBotao = TextStyle(
    color: AppColors.branco,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoAuth = TextStyle(
    color: AppColors.azulEscuro,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle textoLink = TextStyle(
    color: AppColors.verde,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle botaoPrincipal = ElevatedButton.styleFrom(
    backgroundColor: AppColors.azulEscuro,
    foregroundColor: AppColors.branco,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
}