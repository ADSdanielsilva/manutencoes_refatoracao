import 'package:flutter/material.dart';

import '../../model/manutencao_corretiva.dart';

class ManutencaoCorretivaStatusChip extends StatelessWidget {
  final ManutencaoCorretivaStatus status;

  const ManutencaoCorretivaStatusChip({
    super.key,
    required this.status,
  });

  String get _label {
    switch (status) {
      case ManutencaoCorretivaStatus.aberta:
        return 'Status: Aberta';
      case ManutencaoCorretivaStatus.emAndamento:
        return 'Status: Em andamento';
      case ManutencaoCorretivaStatus.concluida:
        return 'Status: Concluída';
      case ManutencaoCorretivaStatus.cancelada:
        return 'Status: Cancelada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_label),
    );
  }
}
