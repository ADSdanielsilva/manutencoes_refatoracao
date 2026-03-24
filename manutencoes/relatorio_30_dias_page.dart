import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'package:app_sindico/features/manutencoes/manutencoes_model.dart';
import 'package:app_sindico/features/manutencoes/manutencoes_provider.dart';

part 'widgets/relatorios/relatorio_30_dias_page_body.dart';
part 'widgets/relatorios/relatorio_30_dias_page_header.dart';
part 'widgets/relatorios/relatorio_30_dias_page_actions.dart';
part 'widgets/relatorios/relatorio_30_dias_page_states.dart';
part 'widgets/relatorios/relatorio_30_dias_page_list.dart';
part 'widgets/relatorios/relatorio_30_dias_page_helpers.dart';
part 'widgets/relatorios/relatorio_30_dias_pdf_builder.dart';
part 'widgets/relatorios/relatorio_30_dias_pdf_header_summary.dart';
part 'widgets/relatorios/relatorio_30_dias_pdf_charts.dart';
part 'widgets/relatorios/relatorio_30_dias_pdf_sections.dart';

const String _relatorio30DiasRegion = 'southamerica-east1';
const double _relatorio30DiasMobileBreakpoint = 700;

class Relatorio30DiasPage extends StatefulWidget {
  final String condominioId;
  final String condominioNome;
  final int diasDefault;

  const Relatorio30DiasPage({
    super.key,
    required this.condominioId,
    required this.condominioNome,
    this.diasDefault = 30,
  });

  @override
  State<Relatorio30DiasPage> createState() => _Relatorio30DiasPageState();
}

mixin _Relatorio30DiasPageBaseMixin on State<Relatorio30DiasPage> {
  late int _dias;

  bool _loadingPdf = false;
  bool _sending = false;

  Uint8List? _lastPdfBytes;
  String? _lastFilename;

  @override
  void initState() {
    super.initState();
    _dias = widget.diasDefault;
  }
}

class _Relatorio30DiasPageState extends State<Relatorio30DiasPage>
    with
        _Relatorio30DiasPageBaseMixin,
        _Relatorio30DiasPageHelpersMixin,
        _Relatorio30DiasPageHeaderMixin,
        _Relatorio30DiasPageListMixin,
        _Relatorio30DiasPdfBuilderMixin,
        _Relatorio30DiasPageActionsMixin,
        _Relatorio30DiasPageBodyMixin {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ManutencoesProvider>();

    final relPendencias = prov.pendentesVencidasEAteNDias(
      widget.condominioId,
      dias: _dias,
      incluirEmAndamento: true,
    );

    final rel = _buildRelatorioCompleto(prov, relPendencias);

    final isNarrow =
        MediaQuery.of(context).size.width < _relatorio30DiasMobileBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório ($_dias dias)'),
        actions: [
          IconButton(
            tooltip: 'Compartilhar PDF',
            onPressed: _lastPdfBytes == null ? null : _shareLastPdf,
            icon: const Icon(Icons.share),
          ),
          IconButton(
            tooltip: 'Imprimir / Visualizar',
            onPressed: _lastPdfBytes == null ? null : _printLastPdf,
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: _buildPageBody(rel, isNarrow: isNarrow),
      bottomNavigationBar: _buildBottomActions(rel),
    );
  }
}
