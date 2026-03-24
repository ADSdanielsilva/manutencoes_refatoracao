import 'package:flutter/material.dart';

class ManutencoesCorretivasPageActions extends StatelessWidget {
  final VoidCallback? onNovaCorretiva;
  final VoidCallback? onFiltros;

  const ManutencoesCorretivasPageActions({
    super.key,
    this.onNovaCorretiva,
    this.onFiltros,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: onNovaCorretiva,
          icon: const Icon(Icons.add),
          label: const Text('Nova corretiva'),
        ),
        OutlinedButton.icon(
          onPressed: onFiltros,
          icon: const Icon(Icons.filter_list),
          label: const Text('Filtros'),
        ),
      ],
    );
  }
}
