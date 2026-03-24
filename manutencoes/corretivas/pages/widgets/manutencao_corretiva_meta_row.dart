import 'package:flutter/material.dart';

import '../../model/manutencao_corretiva.dart';

class ManutencaoCorretivaMetaRow extends StatelessWidget {
  final ManutencaoCorretiva item;

  const ManutencaoCorretivaMetaRow({
    super.key,
    required this.item,
  });

  String _formatDate(DateTime? value) {
    if (value == null) return '-';

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        Text(
          'Abertura: ${_formatDate(item.dataAbertura)}',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          'Conclusão: ${_formatDate(item.dataConclusao)}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
