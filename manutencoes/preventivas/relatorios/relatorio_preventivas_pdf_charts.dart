part of 'page/relatorio_preventivas_page.dart';

pw.Widget _buildPdfChartsRow(_RelatorioCompleto rel) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: _buildPdfChartCard(
          'Comparativo por Status',
          _buildPdfStatusBars(rel),
        ),
      ),
      pw.SizedBox(width: 12),
      pw.Expanded(
        child: _buildPdfChartCard(
          'Distribuição Geral',
          _buildPdfDistribuicaoBar(rel),
        ),
      ),
    ],
  );
}

pw.Widget _buildPdfChartCard(String title, pw.Widget child) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(14),
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
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#0F172A'),
          ),
        ),
        pw.SizedBox(height: 12),
        child,
      ],
    ),
  );
}

pw.Widget _buildPdfStatusBars(_RelatorioCompleto rel) {
  final valores = [
    ('Vencidas', rel.vencidas.length, PdfColor.fromHex('#EF4444')),
    ('A vencer', rel.aVencer.length, PdfColor.fromHex('#F59E0B')),
    ('Concluídas', rel.concluidas.length, PdfColor.fromHex('#22C55E')),
  ];

  final maxValue = valores
      .map((e) => e.$2)
      .fold<int>(1, (prev, curr) => curr > prev ? curr : prev);

  return pw.Column(
    children: valores
        .map(
          (item) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: _buildPdfHorizontalBar(
              label: item.$1,
              value: item.$2,
              maxValue: maxValue,
              color: item.$3,
            ),
          ),
        )
        .toList(),
  );
}

pw.Widget _buildPdfHorizontalBar({
  required String label,
  required int value,
  required int maxValue,
  required PdfColor color,
}) {
  final ratio = maxValue <= 0 ? 0.0 : value / maxValue;
  final widthFactor = ratio.clamp(0.0, 1.0);

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromHex('#334155'),
            ),
          ),
          pw.Text(
            '$value',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 5),
      pw.LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints!.maxWidth * widthFactor;

          return pw.Container(
            height: 12,
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#E5E7EB'),
              borderRadius: pw.BorderRadius.circular(999),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: barWidth,
                  decoration: pw.BoxDecoration(
                    color: color,
                    borderRadius: pw.BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

pw.Widget _buildPdfDistribuicaoBar(_RelatorioCompleto rel) {
  final total = rel.total <= 0 ? 1 : rel.total;
  final vencidas = rel.vencidas.length / total;
  final aVencer = rel.aVencer.length / total;
  final concluidas = rel.concluidas.length / total;

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Container(
        height: 18,
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(999),
          color: PdfColor.fromHex('#E5E7EB'),
        ),
        child: pw.Row(
          children: [
            if (rel.vencidas.isNotEmpty)
              pw.Expanded(
                flex: rel.vencidas.length,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EF4444'),
                    borderRadius: pw.BorderRadius.only(
                      topLeft: const pw.Radius.circular(999),
                      bottomLeft: const pw.Radius.circular(999),
                      topRight: pw.Radius.circular(
                        rel.aVencer.isEmpty && rel.concluidas.isEmpty ? 999 : 0,
                      ),
                      bottomRight: pw.Radius.circular(
                        rel.aVencer.isEmpty && rel.concluidas.isEmpty ? 999 : 0,
                      ),
                    ),
                  ),
                ),
              ),
            if (rel.aVencer.isNotEmpty)
              pw.Expanded(
                flex: rel.aVencer.length,
                child: pw.Container(
                  color: PdfColor.fromHex('#F59E0B'),
                ),
              ),
            if (rel.concluidas.isNotEmpty)
              pw.Expanded(
                flex: rel.concluidas.length,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#22C55E'),
                    borderRadius: pw.BorderRadius.only(
                      topRight: const pw.Radius.circular(999),
                      bottomRight: const pw.Radius.circular(999),
                      topLeft: pw.Radius.circular(
                        rel.vencidas.isEmpty && rel.aVencer.isEmpty ? 999 : 0,
                      ),
                      bottomLeft: pw.Radius.circular(
                        rel.vencidas.isEmpty && rel.aVencer.isEmpty ? 999 : 0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      pw.SizedBox(height: 12),
      _buildPdfLegendLine(
        color: PdfColor.fromHex('#EF4444'),
        label:
            'Vencidas: ${rel.vencidas.length} (${(vencidas * 100).toStringAsFixed(1)}%)',
      ),
      pw.SizedBox(height: 6),
      _buildPdfLegendLine(
        color: PdfColor.fromHex('#F59E0B'),
        label:
            'A vencer: ${rel.aVencer.length} (${(aVencer * 100).toStringAsFixed(1)}%)',
      ),
      pw.SizedBox(height: 6),
      _buildPdfLegendLine(
        color: PdfColor.fromHex('#22C55E'),
        label:
            'Concluídas: ${rel.concluidas.length} (${(concluidas * 100).toStringAsFixed(1)}%)',
      ),
    ],
  );
}

pw.Widget _buildPdfLegendLine({
  required PdfColor color,
  required String label,
}) {
  return pw.Row(
    children: [
      pw.Container(
        width: 10,
        height: 10,
        decoration: pw.BoxDecoration(
          color: color,
          borderRadius: pw.BorderRadius.circular(2),
        ),
      ),
      pw.SizedBox(width: 6),
      pw.Expanded(
        child: pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            color: PdfColor.fromHex('#334155'),
          ),
        ),
      ),
    ],
  );
}
