import 'package:flutter/material.dart';

import 'manutencoes_page_constants.dart';

class TabsCard extends StatelessWidget {
  const TabsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ManutencoesUiColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ManutencoesUiColors.border),
      ),
      child: const TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: ManutencoesUiColors.primary,
        unselectedLabelColor: ManutencoesUiColors.textMuted,
        indicatorColor: ManutencoesUiColors.primary,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: 'Diárias'),
          Tab(text: 'Periódicas'),
          Tab(text: 'Todas'),
        ],
      ),
    );
  }
}
