import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/theme.dart';
import '../../widgets/background.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/text_input_dialog.dart';
import '../../services/auth_service.dart';
import '../../services/grupo_service.dart';
import '../../services/profile_service.dart';

import '../auth/login_screen.dart';

part 'perfil_logic.dart';
part 'perfil_view.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _profileService = ProfileService();
  final _grupoService = GrupoService();
  final _authService = AuthService();

  String _nome = 'Usuário';
  List<Map<String, dynamic>> _grupos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // CARREGAR PERFIL E GRUPOS

  @override
  Widget build(BuildContext context) => _buildView(context);
}
