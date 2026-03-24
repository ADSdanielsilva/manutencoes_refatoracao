part of 'page/relatorio_preventivas_page.dart';

pw.Widget _buildPdfHeader({
  required String nomeCondominio,
  required int dias,
  required DateTime geradoEm,
  required String Function(DateTime) fmtDateTime,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(16),
    decoration: pw.BoxDecoration(
      color: PdfColor.fromHex('#F8FAFC'),
      borderRadius: pw.BorderRadius.circular(14),
      border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0')),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Relatório de Manutenções',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#0F172A'),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Condomínio: $nomeCondominio',
          style: pw.TextStyle(
            fontSize: 11,
            color: PdfColor.fromHex('#334155'),
          ),
        ),
        pw.Text(
          'Janela: próximos $dias dias',
          style: pw.TextStyle(
            fontSize: 11,
            color: PdfColor.fromHex('#334155'),
          ),
        ),
        pw.Text(
          'Gerado em: ${fmtDateTime(geradoEm)}',
          style: pw.TextStyle(
            fontSize: 11,
            color: PdfColor.fromHex('#334155'),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildPdfResumoCards(_RelatorioCompleto rel) {
  return pw.Wrap(
    spacing: 10,
    runSpacing: 10,
    children: [
      _buildPdfMetricCard(
        title: 'Total Geral',
        value: '${rel.total}',
        subtitle: 'Itens consolidados',
        color: PdfColor.fromHex('#4F46E5'),
      ),
      _buildPdfMetricCard(
        title: 'Vencidas',
        value: '${rel.vencidas.length}',
        subtitle: 'Demandam atenção',
        color: PdfColor.fromHex('#EF4444'),
      ),
      _buildPdfMetricCard(
        title: 'A vencer',
        value: '${rel.aVencer.length}',
        subtitle: 'Dentro da janela',
        color: PdfColor.fromHex('#F59E0B'),
      ),
      _buildPdfMetricCard(
        title: 'Concluídas',
        value: '${rel.concluidas.length}',
        subtitle: 'Já finalizadas',
        color: PdfColor.fromHex('#22C55E'),
      ),
    ],
  );
}

pw.Widget _buildPdfMetricCard({
  required String title,
  required String value,
  required String subtitle,
  required PdfColor color,
}) {
  return pw.Container(
    width: 120,
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      borderRadius: pw.BorderRadius.circular(12),
      border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0')),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 9,
            color: PdfColor.fromHex('#64748B'),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          subtitle,
          style: pw.TextStyle(
            fontSize: 8,
            color: PdfColor.fromHex('#94A3B8'),
          ),
        ),
      ],
    ),
  );
}
