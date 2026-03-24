import 'package:flutter/material.dart';

import '../../model/manutencao_corretiva.dart';

class ManutencaoCorretivaPrioridadeChip extends StatelessWidget {
  final ManutencaoCorretivaPrioridade prioridade;

  const ManutencaoCorretivaPrioridadeChip({
    super.key,
    required this.prioridade,
  });

  String get _label {
    switch (prioridade) {
      case ManutencaoCorretivaPrioridade.baixa:
        return 'Prioridade: Baixa';
      case ManutencaoCorretivaPrioridade.media:
        return 'Prioridade: Média';
      case ManutencaoCorretivaPrioridade.alta:
        return 'Prioridade: Alta';
      case ManutencaoCorretivaPrioridade.critica:
        return 'Prioridade: Crítica';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_label),
    );
  }
}
