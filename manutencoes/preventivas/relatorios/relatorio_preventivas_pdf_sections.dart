part of 'page/relatorio_preventivas_page.dart';

pw.Widget _buildPdfSection({
  required String title,
  required List<Manutencao> items,
  required String Function(Manutencao) tituloManutencao,
  required String Function(DateTime?) fmtDate,
  required String Function(Manutencao) periodicidadeManutencao,
  required dynamic Function(Manutencao) statusManutencao,
  required String Function(String) statusDisplay,
  required String Function(String) safeString,
  required dynamic Function(Manutencao, List<String>) readField,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      pw.SizedBox(height: 8),
      if (items.isEmpty)
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Text('Nenhum item.'),
        ),
      if (items.isNotEmpty)
        pw.Table(
          border: pw.TableBorder.all(
            width: 0.5,
            color: PdfColors.grey500,
          ),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(3),
            4: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              children: [
                _buildPdfTableHeader('Serviço'),
                _buildPdfTableHeader('Próxima'),
                _buildPdfTableHeader('Periodicidade'),
                _buildPdfTableHeader('Empresa/Contato'),
                _buildPdfTableHeader('Status'),
              ],
            ),
            ...items.map((m) {
              final empresaContato = [
                safeString(readField(m, ['empresa']).toString()),
                safeString(readField(m, ['contato']).toString()),
              ].where((x) => x.isNotEmpty).join(' / ');

              return pw.TableRow(
                children: [
                  _buildPdfTableCell(tituloManutencao(m)),
                  _buildPdfTableCell(fmtDate(m.proximaData)),
                  _buildPdfTableCell(periodicidadeManutencao(m)),
                  _buildPdfTableCell(empresaContato),
                  _buildPdfTableCell(
                    statusDisplay(statusManutencao(m)),
                  ),
                ],
              );
            }),
          ],
        ),
      pw.SizedBox(height: 16),
    ],
  );
}

pw.Widget _buildPdfTableHeader(String text) => pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );

pw.Widget _buildPdfTableCell(String text) => pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text.isEmpty ? '-' : text,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );

pw.Widget _buildPdfFooter() {
  return pw.Text(
    'IntelliCondo360 - App Síndico',
    style: pw.TextStyle(
      fontSize: 10,
      color: PdfColor.fromHex('#64748B'),
    ),
  );
}
