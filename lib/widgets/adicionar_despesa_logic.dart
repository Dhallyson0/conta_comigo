// ignore_for_file: invalid_use_of_protected_member

part of 'adicionar_despesa.dart';

extension __AdicionarDespesaStateLogic on _AdicionarDespesaState {
    // ============================================================
    // DATA DE VENCIMENTO
    // ============================================================

    Future<void> _selecionarData() async {
      final hoje = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final dataInicial = _dataVencimento ?? hoje;

      final data = await showDatePicker(
        context: context,
        initialDate: dataInicial,
        firstDate: dataInicial.isBefore(hoje)
            ? dataInicial
            : hoje,
        lastDate: DateTime(
          hoje.year + 10,
          12,
          31,
        ),
        helpText: 'Data de vencimento',
        cancelText: 'Cancelar',
        confirmText: 'Selecionar',
      );

      if (data == null) {
        return;
      }

      setState(() {
        _dataVencimento = data;

        _dataController.text =
            '${data.day.toString().padLeft(2, '0')}/'
            '${data.month.toString().padLeft(2, '0')}/'
            '${data.year}';

        _erro = null;
      });
    }

    // ============================================================
    // VALOR
    // ============================================================

    double? _obterValor() {
      final texto = _valorController.text
          .trim()
          .replaceAll('.', '')
          .replaceAll(',', '.');

      return double.tryParse(texto);
    }

    // ============================================================
    // DIVISÕES
    // ============================================================

    Map<String, double> _obterDivisoes() {
      final divisoes = <String, double>{};

      for (final entry
          in _divisaoControllers.entries) {
        final texto =
            entry.value.text.trim();

        if (texto.isEmpty) {
          continue;
        }

        final valor = double.tryParse(
          texto
              .replaceAll('.', '')
              .replaceAll(',', '.'),
        );

        if (valor != null) {
          divisoes[entry.key] = valor;
        }
      }

      return divisoes;
    }

    // ============================================================
    // VALIDAR DIVISÕES
    // ============================================================

    bool _validarDivisoes(
      double valor,
    ) {
      if (!_divisaoPersonalizada) {
        return true;
      }

      final divisoes = _obterDivisoes();

      if (divisoes.length !=
          widget.membros.length) {
        setState(() {
          _erro =
              'Informe o valor de todos os integrantes.';
        });

        return false;
      }

      final total =
          divisoes.values.fold<double>(
        0,
        (soma, valor) => soma + valor,
      );

      if ((total - valor).abs() > 0.01) {
        setState(() {
          _erro =
              'A soma das divisões precisa ser igual ao valor da despesa.';
        });

        return false;
      }

      return true;
    }

    // ============================================================
    // CRIAR
    // ============================================================

    Future<void> _criar() async {
      setState(() {
        _erro = null;
      });

      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (_dataVencimento == null) {
        setState(() {
          _erro =
              'Selecione a data de vencimento.';
        });

        return;
      }

      final valor = _obterValor();

      if (valor == null || valor <= 0) {
        setState(() {
          _erro =
              'Informe um valor válido.';
        });

        return;
      }

      if (!_validarDivisoes(valor)) {
        return;
      }

      setState(() {
        _salvando = true;
      });

      try {
        await widget.onCriar(
          nome: _nomeController.text.trim(),
          valor: valor,
          categoria:
              _categoriaSelecionada!,
          recorrente: _recorrente,
          divisaoPersonalizada:
              _divisaoPersonalizada,
          divisoes:
              _obterDivisoes(),
          dataVencimento:
              _dataVencimento!,
        );
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _erro = e.toString();
          _salvando = false;
        });

        return;
      }

      if (!mounted) return;

      setState(() {
        _salvando = false;
      });
    }

}
