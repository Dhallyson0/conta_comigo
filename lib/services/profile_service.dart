import '../core/supabase.dart';

class ProfileService {
  final _supabase = supabase;

  // Buscar o perfil do usuário atualmente logado
  Future<Map<String, dynamic>?> buscarMeuPerfil() async {
    final usuario = _supabase.auth.currentUser;

    if (usuario == null) {
      return null;
    }

    final resposta = await _supabase
        .from('profiles')
        .select('nome')
        .eq('id', usuario.id)
        .maybeSingle();

    return resposta;
  }

  // Atualizar nome do usuário
  Future<void> atualizarNome(String nome) async {
    final usuario = _supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não está logado.');
    }

    await _supabase
        .from('profiles')
        .update({'nome': nome})
        .eq('id', usuario.id);
  }
}