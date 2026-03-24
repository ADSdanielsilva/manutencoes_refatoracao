import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/shared/models/sindico.dart';

import '../forms/page/manutencoes_form_page.dart';
import 'package:app_sindico/features/manutencoes/preventivas/provider/page/manutencoes_provider.dart';
import 'package:app_sindico/features/manutencoes/preventivas/relatorios/page/relatorio_preventivas_page.dart';
import '../../services/manutencoes_import_service.dart';
import 'widgets/manutencoes_page_body.dart';
import 'widgets/manutencoes_page_constants.dart';

class ManutencoesPage extends StatefulWidget {
  final Sindico sindico;
  final Condominio condominio;

  const ManutencoesPage({
    super.key,
    required this.sindico,
    required this.condominio,
  });

  @override
  State<ManutencoesPage> createState() => _ManutencoesPageState();
}

class _ManutencoesPageState extends State<ManutencoesPage> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<ManutencoesProvider>().watchCondominio(
            widget.condominio.id,
          );
    });
  }

  Future<void> _importarPlanilha() async {
    final confirmar = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Importar manutenções?'),
            content: Text(
              'Deseja importar as manutenções da planilha para o condomínio "${widget.condominio.nome}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.upload_file),
                label: const Text('Importar'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmar || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text('Importando manutenções da planilha...'),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final service = ManutencoesImportService();
      final resultado = await service.importarDoCondominio(
        condominio: widget.condominio,
      );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      await context.read<ManutencoesProvider>().refresh();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Importação concluída: ${resultado.importadas} importadas, ${resultado.ignoradas} ignoradas.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar planilha: $e')),
      );
    }
  }

  Future<void> _abrirRelatorio() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Relatorio30DiasPage(
          condominioId: widget.condominio.id,
          condominioNome: widget.condominio.nome,
        ),
      ),
    );
  }

  Future<void> _abrirNovaManutencao() async {
    final salvou = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManutencaoFormPage(
          condominio: widget.condominio,
          sindico: widget.sindico,
        ),
      ),
    );

    if (salvou == true && mounted) {
      final p = context.read<ManutencoesProvider>();
      if (!p.useRealtime) {
        await p.refresh();
      }
    }
  }

  void _voltar() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ManutencoesUiColors.pageBackground,
        body: SafeArea(
          child: ManutencoesContent(
            sindico: widget.sindico,
            condominio: widget.condominio,
            onNovaManutencao: _abrirNovaManutencao,
            onImportarPlanilha: _importarPlanilha,
            onAbrirRelatorio: _abrirRelatorio,
            onVoltar: _voltar,
            canPop: Navigator.of(context).canPop(),
          ),
        ),
      ),
    );
  }
}
