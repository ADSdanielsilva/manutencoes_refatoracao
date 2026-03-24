part of '../../relatorio_30_dias_page.dart';

mixin _Relatorio30DiasPageActionsMixin
    on
        _Relatorio30DiasPageBaseMixin,
        _Relatorio30DiasPageHelpersMixin,
        _Relatorio30DiasPdfBuilderMixin {
  Future<void> _enviarEmail(
    BuildContext context,
    _RelatorioCompleto rel,
  ) async {
    final messenger = ScaffoldMessenger.maybeOf(context);

    final to = await _askRecipients(context);
    if (!context.mounted) return;
    if (to == null || to.isEmpty) return;

    await _gerarPdf(context, rel);
    if (!mounted || _lastPdfBytes == null) return;

    setState(() => _sending = true);

    try {
      final nomeCondo = widget.condominioNome;
      final subject = 'Relatório de Manutenções - $nomeCondo - $_dias dias';
      final filename =
          _lastFilename ?? 'Relatorio_Manutencoes_${_sanitize(nomeCondo)}.pdf';
      final pdfBase64 = base64Encode(_lastPdfBytes!);

      final text =
          'Segue em anexo o relatório de manutenções do condomínio $nomeCondo.';
      final html = """
<p>Segue em anexo o <b>relatório de manutenções</b> do condomínio <b>${_escapeHtml(nomeCondo)}</b>.</p>
<p>Período analisado: próximos <b>$_dias</b> dias.</p>
<p>Resumo:</p>
<ul>
  <li>Vencidas: <b>${rel.vencidas.length}</b></li>
  <li>A vencer: <b>${rel.aVencer.length}</b></li>
  <li>Concluídas: <b>${rel.concluidas.length}</b></li>
</ul>
<p>Enviado via IntelliCondo360.</p>
""";

      final callable =
          FirebaseFunctions.instanceFor(region: _relatorio30DiasRegion)
              .httpsCallable(
        'sendMaintenanceReportEmail',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 120)),
      );

      debugPrint(
        '[Relatorio] Chamando function sendMaintenanceReportEmail (callable)...',
      );

      final res = await callable.call(<String, dynamic>{
        'condominioId': widget.condominioId,
        'to': to,
        'subject': subject,
        'filename': filename,
        'text': text,
        'html': html,
        'pdfBase64': pdfBase64,
      });

      debugPrint('[Relatorio] Callable OK: ${res.data}');

      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text('E-mail enviado para: ${to.join(', ')}')),
      );
    } on FirebaseFunctionsException catch (e, st) {
      debugPrint(
        'FirebaseFunctionsException: code=${e.code} message=${e.message} details=${e.details}\n$st',
      );

      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text('Erro (${e.code}): ${e.message ?? ''}')),
      );
    } catch (e, st) {
      debugPrint('Erro ao enviar e-mail: $e\n$st');

      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text('Erro ao enviar e-mail: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<List<String>?> _askRecipients(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<List<String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Destinatários'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Informe os e-mails separados por vírgula.'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText:
                      'ex: sindico@condominio.com, financeiro@empresa.com',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final raw = controller.text.trim();
                final list = raw
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                if (list.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Informe ao menos 1 e-mail.')),
                  );
                  return;
                }

                final invalid = list.where((e) => !_looksLikeEmail(e)).toList();
                if (invalid.isNotEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('E-mails inválidos: ${invalid.join(', ')}'),
                    ),
                  );
                  return;
                }

                Navigator.of(ctx).pop(list);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareLastPdf() async {
    final bytes = _lastPdfBytes;
    if (bytes == null) return;

    final name = _lastFilename ?? 'relatorio.pdf';

    await Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: 'application/pdf', name: name)],
      subject: 'Relatório de Manutenções - ${widget.condominioNome}',
      text: 'Segue o relatório em anexo.',
    );
  }

  Future<void> enviarPorWhatsApp() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final bytes = _lastPdfBytes;

    if (bytes == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Gere o PDF antes de enviar.')),
      );
      return;
    }

    final name = _lastFilename ?? 'relatorio.pdf';

    await Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: 'application/pdf', name: name)],
      text: 'Relatório de manutenções: ${widget.condominioNome}',
    );
  }

  Future<void> _printLastPdf() async {
    final bytes = _lastPdfBytes;
    if (bytes == null) return;

    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
    );
  }
}
