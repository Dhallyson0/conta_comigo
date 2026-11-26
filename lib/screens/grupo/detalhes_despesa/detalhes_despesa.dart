import 'package:flutter/material.dart';
import '../../../core/formatters.dart';
import '../../../core/helpers.dart';
import '../../../core/supabase.dart';
import '../../../core/theme.dart';
import '../../../services/despesa_service.dart';
import '../../../widgets/adicionar_despesa/adicionar_despesa.dart';

part 'detalhes_despesa_logic.dart';
part 'detalhes_despesa_view.dart';

class DetalhesDespesa extends StatefulWidget {
  final Map<String, dynamic> despesa;
  final bool souAdmin;

  const DetalhesDespesa({
    super.key,
    required this.despesa,
    required this.souAdmin,
  });

  @override
  State<DetalhesDespesa> createState() =>
      _DetalhesDespesaState();
}

class _DetalhesDespesaState
    extends State<DetalhesDespesa> {
  final _despesaService = DespesaService();

  List<Map<String, dynamic>> _integrantes = [];

  bool _carregando = true;

  bool get _souAdmin => widget.souAdmin;

  bool _excluindo = false;

  String? _erro;

  final Set<String> _atualizando = {};

  @override
  void initState() {
    super.initState();

    _carregarIntegrantes();
  }

  @override
  Widget build(BuildContext context) => _buildView(context);
}
