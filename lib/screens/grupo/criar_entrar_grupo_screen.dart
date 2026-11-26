import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/theme.dart';
import '../../services/grupo_service.dart';
import '../../widgets/background.dart';
import '../../widgets/bottom_navigation.dart';

part 'criar_entrar_grupo_logic.dart';
part 'criar_entrar_grupo_view.dart';

class CriarEntrarGrupoScreen extends StatefulWidget {
  const CriarEntrarGrupoScreen({
    super.key,
  });

  @override
  State<CriarEntrarGrupoScreen> createState() =>
      _CriarEntrarGrupoScreenState();
}

class _CriarEntrarGrupoScreenState
    extends State<CriarEntrarGrupoScreen> {
  final _grupoService = GrupoService();

  final TextEditingController _nomeGrupoController =
      TextEditingController();

  final TextEditingController _codigoGrupoController =
      TextEditingController();

  bool _criandoGrupo = false;
  bool _entrandoGrupo = false;

  @override
  void dispose() {
    _nomeGrupoController.dispose();
    _codigoGrupoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildView(context);
}
