part of '../../relatorio_30_dias_page.dart';

mixin _Relatorio30DiasPageBodyMixin
    on
        _Relatorio30DiasPageBaseMixin,
        _Relatorio30DiasPageHeaderMixin,
        _Relatorio30DiasPageListMixin,
        _Relatorio30DiasPageActionsMixin,
        _Relatorio30DiasPdfBuilderMixin {
  Widget _buildPageBody(
    _RelatorioCompleto rel, {
    required bool isNarrow,
  }) {
    return Column(
      children: [
        _buildHeader(rel, isNarrow: isNarrow),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isNarrow ? 12 : 16,
              8,
              isNarrow ? 12 : 16,
              24,
            ),
            children: [
              _buildSectionTitle('Vencidas', rel.vencidas.length),
              const SizedBox(height: 8),
              if (rel.vencidas.isEmpty)
                const _EmptyCard(text: 'Nenhuma manutenção vencida.')
              else
                ...rel.vencidas
                    .map((m) => _itemTile(m, tipo: _TipoItem.vencida)),
              const SizedBox(height: 16),
              _buildSectionTitle(
                'A vencer (até $_dias dias)',
                rel.aVencer.length,
              ),
              const SizedBox(height: 8),
              if (rel.aVencer.isEmpty)
                const _EmptyCard(
                  text: 'Nenhuma manutenção a vencer no período.',
                )
              else
                ...rel.aVencer
                    .map((m) => _itemTile(m, tipo: _TipoItem.aVencer)),
              const SizedBox(height: 16),
              _buildSectionTitle('Concluídas', rel.concluidas.length),
              const SizedBox(height: 8),
              if (rel.concluidas.isEmpty)
                const _EmptyCard(text: 'Nenhuma manutenção concluída.')
              else
                ...rel.concluidas
                    .map((m) => _itemTile(m, tipo: _TipoItem.concluida)),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(_RelatorioCompleto rel) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow =
                constraints.maxWidth < _relatorio30DiasMobileBreakpoint;

            if (narrow) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _loadingPdf ? null : () => _gerarPdf(context, rel),
                      icon: _loadingPdf
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.picture_as_pdf),
                      label: Text(_loadingPdf ? 'Gerando...' : 'Gerar PDF'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _sending ? null : () => _enviarEmail(context, rel),
                      icon: _sending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.email),
                      label:
                          Text(_sending ? 'Enviando...' : 'Enviar por e-mail'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _lastPdfBytes == null ? null : enviarPorWhatsApp,
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _loadingPdf ? null : () => _gerarPdf(context, rel),
                    icon: _loadingPdf
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.picture_as_pdf),
                    label: Text(_loadingPdf ? 'Gerando...' : 'Gerar PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _sending ? null : () => _enviarEmail(context, rel),
                    icon: _sending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.email),
                    label: Text(_sending ? 'Enviando...' : 'Enviar por e-mail'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _lastPdfBytes == null ? null : enviarPorWhatsApp,
                    icon: const Icon(Icons.chat),
                    label: const Text('WhatsApp'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
