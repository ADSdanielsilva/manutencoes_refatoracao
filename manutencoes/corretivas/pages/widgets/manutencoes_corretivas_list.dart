import 'package:flutter/material.dart';

import '../../model/manutencao_corretiva.dart';
import 'manutencoes_corretivas_list_item.dart';

class ManutencoesCorretivasList extends StatelessWidget {
  final List<ManutencaoCorretiva> items;

  const ManutencoesCorretivasList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ManutencoesCorretivasListItem(
          item: items[index],
        );
      },
    );
  }
}
