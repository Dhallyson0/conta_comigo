import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/formatters.dart';
import '../../core/theme.dart';

part 'adicionar_despesa_logic.dart';
part 'adicionar_despesa_view.dart';

class AdicionarDespesa extends StatefulWidget {
  final List<Map<String, dynamic>> membros;

  final Map<String, dynamic>? despesaInicial;

  final Map<String, double> divisoesIniciais;

  final bool modoEdicao;

  final bool divisaoPersonalizadaInicial;

  final VoidCallback onFechar;

  final Future<void> Function({
    required String nome,
    required double valor,
    required String categoria,
    required bool recorrente,
    required bool divisaoPersonalizada,
    required Map<String, double> divisoes,
    required DateTime dataVencimento,
  }) onCriar;

  const AdicionarDespesa({
    super.key,
    required this.membros,
    required this.onFechar,
    required this.onCriar,
    this.despesaInicial,
    this.divisoesIniciais = const {},
    this.modoEdicao = false,
    this.divisaoPersonalizadaInicial = false,
  });

  @override
  State<AdicionarDespesa> createState() =>
      _AdicionarDespesaState();
}

class _AdicionarDespesaState
    extends State<AdicionarDespesa> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController =
      TextEditingController();

  final _valorController =
      TextEditingController();

  final _dataController =
      TextEditingController();

  String? _categoriaSelecionada;

  DateTime? _dataVencimento;

  bool _recorrente = false;

  bool _divisaoPersonalizada = false;

  bool _salvando = false;

  String? _erro;

  final List<String> _categorias = categoriasDespesas;

  final Map<String, TextEditingController>
      _divisaoControllers = {};

  @override
  void initState() {
    super.initState();

    for (final membro in widget.membros) {
      final usuarioId =
          membro['usuario_id']?.toString();

      if (usuarioId != null) {
        _divisaoControllers[usuarioId] =
            TextEditingController();
      }
    }

    if (widget.modoEdicao &&
        widget.despesaInicial != null) {
      final despesa = widget.despesaInicial!;

      _nomeController.text =
          despesa['nome']?.toString() ?? '';

      final valor =
          (despesa['valor'] as num?)?.toDouble();

      if (valor != null) {
        _valorController.text =
            formatarNumero(valor);
      }

      _categoriaSelecionada =
          despesa['categoria']?.toString();

      _recorrente = despesa['recorrente'] == true;
      _divisaoPersonalizada =
          widget.divisaoPersonalizadaInicial;

      final lancamentos = despesa['lancamentos'];

      if (lancamentos is List &&
          lancamentos.isNotEmpty) {
        final lancamento =
            Map<String, dynamic>.from(lancamentos.first);

        final data =
            lancamento['data_vencimento']?.toString();

        if (data != null && data.isNotEmpty) {
          final partes = data.split('-');

          if (partes.length == 3) {
            try {
              final dataConvertida = DateTime(
                int.parse(partes[0]),
                int.parse(partes[1]),
                int.parse(partes[2]),
              );

              _dataVencimento = dataConvertida;

              _dataController.text =
                  '${dataConvertida.day.toString().padLeft(2, '0')}/'
                  '${dataConvertida.month.toString().padLeft(2, '0')}/'
                  '${dataConvertida.year}';
            } catch (_) {}
          }
        }
      }

      for (final entry in widget.divisoesIniciais.entries) {
        final controller =
            _divisaoControllers[entry.key];

        if (controller != null) {
          controller.text =
              formatarNumero(entry.value);
        }
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    _dataController.dispose();

    for (final controller
        in _divisaoControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildView(context);
}
