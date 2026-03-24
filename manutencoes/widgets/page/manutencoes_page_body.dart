import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/shared/models/sindico.dart';

import 'package:app_sindico/features/manutencoes/manutencoes_provider.dart';
import 'manutencoes_page_constants.dart';
import 'manutencoes_page_header.dart';
import 'manutencoes_page_list.dart';
import 'manutencoes_page_summary.dart';
import 'manutencoes_page_tabs.dart';

class ManutencoesContent extends StatefulWidget {
  final Sindico sindico;
  final Condominio condominio;
  final VoidCallback onNovaManutencao;
  final VoidCallback onImportarPlanilha;
  final VoidCallback onAbrirRelatorio;
  final VoidCallback onVoltar;
  final bool canPop;

  const ManutencoesContent({
    super.key,
    required this.sindico,
    required this.condominio,
    required this.onNovaManutencao,
    required this.onImportarPlanilha,
    required this.onAbrirRelatorio,
    required this.onVoltar,
    required this.canPop,
  });

  @override
  State<ManutencoesContent> createState() => _ManutencoesContentState();
}

class _ManutencoesContentState extends State<ManutencoesContent> {
  TabController? _controller;
  int _tabIndex = 0;

  void _handleTabChanged() {
    if (!mounted || _controller == null) return;
    if (_tabIndex != _controller!.index) {
      setState(() {
        _tabIndex = _controller!.index;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = DefaultTabController.of(context);
    if (_controller == newController) return;

    _controller?.removeListener(_handleTabChanged);
    _controller = newController;
    _tabIndex = _controller?.index ?? 0;
    _controller?.addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabChanged);
    super.dispose();
  }

  ManutencaoTabMain get _currentTab {
    switch (_tabIndex) {
      case 0:
        return ManutencaoTabMain.diaria;
      case 1:
        return ManutencaoTabMain.periodica;
      case 2:
      default:
        return ManutencaoTabMain.todas;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManutencoesProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Erro ao carregar: ${provider.erro}'),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < ManutencoesBreakpoints.mobile;
        final isTablet = width >= ManutencoesBreakpoints.mobile &&
            width < ManutencoesBreakpoints.desktop;

        final horizontal = isMobile
            ? 12.0
            : isTablet
                ? 16.0
                : 28.0;

        final verticalTop = isMobile ? 12.0 : 18.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, verticalTop, horizontal, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderPainel(
                condominio: widget.condominio,
                onNovaManutencao: widget.onNovaManutencao,
                onImportarPlanilha: widget.onImportarPlanilha,
                onVoltar: widget.onVoltar,
                canPop: widget.canPop,
              ),
              const SizedBox(height: 18),
              ResumoCards(condominioId: widget.condominio.id),
              const SizedBox(height: 18),
              const TabsCard(),
              const SizedBox(height: 14),
              ManutencaoLista(
                key: ValueKey(_currentTab),
                tab: _currentTab,
                sindico: widget.sindico,
                condominio: widget.condominio,
              ),
            ],
          ),
        );
      },
    );
  }
}
