import '../core/supabase.dart';

class GrupoService {
  final _supabase = supabase;

  // ============================================================
  // CRIAR GRUPO
  // ============================================================

  Future<Map<String, dynamic>> criarGrupo({
    required String nome,
  }) async {
    final resposta = await _supabase.rpc(
      'criar_grupo',
      params: {
        'p_nome': nome,
      },
    );

    return Map<String, dynamic>.from(resposta);
  }

  // ============================================================
  // ENTRAR EM GRUPO
  // ============================================================

  Future<Map<String, dynamic>> entrarGrupo({
    required String codigo,
  }) async {
    final resposta = await _supabase.rpc(
      'entrar_grupo',
      params: {
        'p_codigo': codigo.trim(),
      },
    );

    return Map<String, dynamic>.from(resposta);
  }

  // ============================================================
  // BUSCAR MEUS GRUPOS
  // ============================================================

  Future<List<Map<String, dynamic>>> buscarMeusGrupos() async {
    final usuario = _supabase.auth.currentUser;

    if (usuario == null) {
      throw Exception('Usuário não está logado.');
    }

    final resposta = await _supabase
        .from('membros_grupo')
        .select('''
          role,
          grupos (
            id,
            nome,
            codigo,
            criado_por,
            created_at
          )
        ''')
        .eq('usuario_id', usuario.id);

    return List<Map<String, dynamic>>.from(resposta);
  }

  // ============================================================
  // BUSCAR MEMBROS DO GRUPO
  // ============================================================

  Future<List<Map<String, dynamic>>> buscarMembrosGrupo({
    required String grupoId,
  }) async {
    final resposta = await _supabase
        .from('membros_grupo')
        .select('''
          usuario_id,
          role,
          profiles (
            id,
            nome,
            email
          )
        ''')
        .eq('grupo_id', grupoId);

    return List<Map<String, dynamic>>.from(resposta);
  }

  // ============================================================
  // SAIR DO GRUPO
  // ============================================================

  Future<void> sairDoGrupo({
    required String grupoId,
  }) async {
    await _supabase.rpc(
      'sair_do_grupo',
      params: {
        'p_grupo_id': grupoId,
      },
    );
  }

  // ============================================================
  // EDITAR GRUPO
  // ============================================================

  Future<void> editarGrupo({
    required String grupoId,
    required String nome,
  }) async {
    await _supabase.rpc(
      'editar_grupo',
      params: {
        'p_grupo_id': grupoId,
        'p_nome': nome.trim(),
      },
    );
  }

  // ============================================================
  // EXCLUIR GRUPO
  // ============================================================

  Future<void> excluirGrupo({
    required String grupoId,
  }) async {
    await _supabase.rpc(
      'excluir_grupo',
      params: {
        'p_grupo_id': grupoId,
      },
    );
  }
}
