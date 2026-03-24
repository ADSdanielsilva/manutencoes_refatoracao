part of '../../relatorio_30_dias_page.dart';

mixin _Relatorio30DiasPageHeaderMixin on _Relatorio30DiasPageBaseMixin {
  Widget _buildHeader(
    _RelatorioCompleto rel, {
    required bool isNarrow,
  }) {
    final total = rel.total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.condominioNome,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isNarrow ? double.infinity : null,
                child: DropdownButtonFormField<int>(
                  initialValue: _dias,
                  isDense: true,
                  decoration: const InputDecoration(
                    labelText: 'Período',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: const [7, 15, 30, 45, 60, 90]
                      .map(
                        (d) => DropdownMenuItem<int>(
                          value: d,
                          child: Text('$d dias'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _dias = v;
                      _lastPdfBytes = null;
                      _lastFilename = null;
                    });
                  },
                ),
              ),
              Chip(label: Text('Total: $total')),
              Chip(label: Text('Vencidas: ${rel.vencidas.length}')),
              Chip(label: Text('A vencer: ${rel.aVencer.length}')),
              Chip(label: Text('Concluídas: ${rel.concluidas.length}')),
            ],
          ),
        ],
      ),
    );
  }
}
