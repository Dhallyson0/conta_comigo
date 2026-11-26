import 'package:flutter/material.dart';

class AppColors {
  static const azulEscuro = Color(0xFF0D3B73);
  static const verde = Color(0xFF009B8F);
  static const verdeClaro = Color(0xFF20C7A1);
  static const azulClaro = Color(0xFFBCE9E8);

  static const fundo = Color(0xFFF3F8FC);
  static const branco = Colors.white;
  static const cinzaTexto = Color(0xFF6683A3);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.fundo,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.azulEscuro,
        primary: AppColors.azulEscuro,
        secondary: AppColors.verde,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.branco,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.azulClaro,
            width: 2,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.azulClaro,
            width: 2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.verde,
            width: 2,
          ),
        ),
      ),
    );
  }
}