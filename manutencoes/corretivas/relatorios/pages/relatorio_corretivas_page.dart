import 'package:flutter/material.dart';

import '../widgets/relatorio_corretivas_empty_state.dart';
import '../widgets/relatorio_corretivas_page_header.dart';

class RelatorioCorretivasPage extends StatelessWidget {
  const RelatorioCorretivasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          RelatorioCorretivasPageHeader(),
          SizedBox(height: 24),
          Expanded(
            child: RelatorioCorretivasEmptyState(),
          ),
        ],
      ),
    );
  }
}
