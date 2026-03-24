import 'package:flutter/material.dart';

class ManutencoesCorretivasPageHeader extends StatelessWidget {
  const ManutencoesCorretivasPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manutenções Corretivas',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gerencie chamados avulsos, falhas, reparos, prioridade, status e custos.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
