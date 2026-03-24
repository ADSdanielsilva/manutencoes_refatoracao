import 'package:flutter/material.dart';

class ManutencaoCorretivaCustoChip extends StatelessWidget {
  final double custo;

  const ManutencaoCorretivaCustoChip({
    super.key,
    required this.custo,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('Custo: R\$ ${custo.toStringAsFixed(2)}'),
    );
  }
}
