import 'package:flutter/material.dart';

import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/shared/models/sindico.dart';

import '../../corretivas/pages/manutencoes_corretivas_page.dart';
import '../../corretivas/relatorios/pages/relatorio_corretivas_page.dart';
import '../../manutencoes_page.dart';
import '../../relatorio_30_dias_page.dart';
import '../navigation/manutencoes_nav_item.dart';
import '../widgets/manutencoes_drawer.dart';
import '../widgets/manutencoes_sidebar.dart';
import 'manutencoes_breakpoints.dart';

class ManutencoesShellPage extends StatefulWidget {
  final Sindico sindico;
  final Condominio condominio;

  const ManutencoesShellPage({
    super.key,
    required this.sindico,
    required this.condominio,
  });

  @override
  State<ManutencoesShellPage> createState() => _ManutencoesShellPageState();
}

class _ManutencoesShellPageState extends State<ManutencoesShellPage> {
  ManutencoesNavItem _currentItem = ManutencoesNavItem.preventivas;

  void _handleNavigate(ManutencoesNavItem item) {
    setState(() => _currentItem = item);

    final isMobile = ManutencoesBreakpoints.isMobile(
      MediaQuery.of(context).size.width,
    );

    if (isMobile && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildContent() {
    switch (_currentItem) {
      case ManutencoesNavItem.preventivas:
        return ManutencoesPage(
          sindico: widget.sindico,
          condominio: widget.condominio,
        );

      case ManutencoesNavItem.corretivas:
        return const ManutencoesCorretivasPage();

      case ManutencoesNavItem.relatoriosPreventivos:
        return Relatorio30DiasPage(
          condominioId: widget.condominio.id,
          condominioNome: widget.condominio.nome,
        );

      case ManutencoesNavItem.relatoriosCorretivos:
        return const RelatorioCorretivasPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = ManutencoesBreakpoints.isDesktop(width);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            ManutencoesSidebar(
              currentItem: _currentItem,
              onNavigate: _handleNavigate,
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manutenções'),
      ),
      drawer: ManutencoesDrawer(
        currentItem: _currentItem,
        onNavigate: _handleNavigate,
      ),
      body: _buildContent(),
    );
  }
}
