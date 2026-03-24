part of 'page/relatorio_preventivas_page.dart';

mixin _Relatorio30DiasPdfBuilderMixin
    on _Relatorio30DiasPageBaseMixin, _Relatorio30DiasPageHelpersMixin {
  Future<void> _gerarPdf(BuildContext context, _RelatorioCompleto rel) async {
    final messenger = ScaffoldMessenger.maybeOf(context);

    setState(() => _loadingPdf = true);

    try {
      final now = DateTime.now();
      final filename =
          'Relatorio_Manutencoes_${_sanitize(widget.condominioNome)}_${_fmtDateFile(now)}.pdf';

      final bytes = await _buildPdfBytes(
        nomeCondominio: widget.condominioNome,
        dias: _dias,
        rel: rel,
      );

      if (!mounted) return;

      setState(() {
        _lastPdfBytes = bytes;
        _lastFilename = filename;
      });

      messenger?.showSnackBar(
        const SnackBar(content: Text('PDF gerado com sucesso.')),
      );
    } catch (e, st) {
      debugPrint('Erro ao gerar PDF: $e\n$st');

      if (!mounted) return;

      messenger?.showSnackBar(
        SnackBar(content: Text('Erro ao gerar PDF: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingPdf = false);
      }
    }
  }

  Future<Uint8List> _buildPdfBytes({
    required String nomeCondominio,
    required int dias,
    required _RelatorioCompleto rel,
  }) async {
    final doc = pw.Document();
    final geradoEm = DateTime.now();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _buildPdfHeader(
            nomeCondominio: nomeCondominio,
            dias: dias,
            geradoEm: geradoEm,
            fmtDateTime: _fmtDateTime,
          ),
          pw.SizedBox(height: 14),
          _buildPdfResumoCards(rel),
          pw.SizedBox(height: 16),
          _buildPdfChartsRow(rel),
          pw.SizedBox(height: 18),
          _buildPdfSection(
            title: 'Vencidas (${rel.vencidas.length})',
            items: rel.vencidas,
            tituloManutencao: _tituloManutencao,
            fmtDate: _fmtDate,
            periodicidadeManutencao: _periodicidadeManutencao,
            statusManutencao: _statusManutencao,
            statusDisplay: _statusDisplay,
            safeString: (String value) => _safeString(value),
            readField: _readField,
          ),
          _buildPdfSection(
            title: 'A vencer (até $dias dias) (${rel.aVencer.length})',
            items: rel.aVencer,
            tituloManutencao: _tituloManutencao,
            fmtDate: _fmtDate,
            periodicidadeManutencao: _periodicidadeManutencao,
            statusManutencao: _statusManutencao,
            statusDisplay: _statusDisplay,
            safeString: (String value) => _safeString(value),
            readField: _readField,
          ),
          _buildPdfSection(
            title: 'Concluídas (${rel.concluidas.length})',
            items: rel.concluidas,
            tituloManutencao: _tituloManutencao,
            fmtDate: _fmtDate,
            periodicidadeManutencao: _periodicidadeManutencao,
            statusManutencao: _statusManutencao,
            statusDisplay: _statusDisplay,
            safeString: (String value) => _safeString(value),
            readField: _readField,
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 6),
          _buildPdfFooter(),
        ],
      ),
    );

    return doc.save();
  }
}
