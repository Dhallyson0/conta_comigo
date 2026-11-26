import '../core/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = supabase;

  // Usuário atualmente logado
  User? get usuarioAtual => _supabase.auth.currentUser;

  // Cadastrar usuário
  Future<AuthResponse> cadastrar({
    required String email,
    required String senha,
    required String nome,
  }) async {
    final resposta = await _supabase.auth.signUp(
      email: email,
      password: senha,
      data: {
        'nome': nome,
      },
    );

    return resposta;
  }

  // Fazer login
  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    final resposta = await _supabase.auth.signInWithPassword(
      email: email,
      password: senha,
    );

    return resposta;
  }

  // Fazer logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // Verificar se existe usuário logado
  bool get estaLogado => usuarioAtual != null;
}