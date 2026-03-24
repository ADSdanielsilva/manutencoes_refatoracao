import 'package:flutter/material.dart';

class RelatorioCorretivasPageHeader extends StatelessWidget {
  const RelatorioCorretivasPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relatórios Corretivos',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Acompanhe chamados corretivos, custos, status, prioridades e histórico de execução.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
