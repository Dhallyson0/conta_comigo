import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/formatters.dart';
import '../../core/helpers.dart';
import '../../core/supabase.dart';
import '../../core/theme.dart';
import '../../services/despesa_service.dart';
import '../../services/grupo_service.dart';
import '../../widgets/adicionar_despesa/adicionar_despesa.dart';
import '../../widgets/app_card.dart';
import '../../widgets/background.dart';
import '../../widgets/filtro_despesas.dart';
import '../../widgets/grupo_menu.dart';

import 'detalhes_despesa/detalhes_despesa.dart';

part 'grupo_logic.dart';
part 'grupo_view.dart';

class GrupoScreen extends StatefulWidget {
  final String grupoId;
  final String nomeGrupo;
  final String codigoGrupo;

  const GrupoScreen({
    super.key,
    required this.grupoId,
    required this.nomeGrupo,
    required this.codigoGrupo,
  });

  @override
  State<GrupoScreen> createState() =>
      _GrupoScreenState();
}

class _GrupoScreenState
    extends State<GrupoScreen> {
  final _despesaService = DespesaService();
  final _grupoService = GrupoService();

  List<Map<String, dynamic>> _despesas = [];
  List<Map<String, dynamic>> _membros = [];

  double _valorDevido = 0;

  bool _carregando = true;

  String? _categoriaSelecionada;

  final List<String> _categorias = categoriasDespesas;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // CARREGAR DADOS

  @override
  Widget build(BuildContext context) => _buildView(context);
}
