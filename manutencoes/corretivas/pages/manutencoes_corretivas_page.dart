import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../forms/manutencao_corretiva_form_page.dart';
import '../provider/manutencoes_corretivas_provider.dart';
import 'widgets/manutencoes_corretivas_empty_state.dart';
import 'widgets/manutencoes_corretivas_list.dart';
import 'widgets/manutencoes_corretivas_page_actions.dart';
import 'widgets/manutencoes_corretivas_page_header.dart';

class ManutencoesCorretivasPage extends StatelessWidget {
  const ManutencoesCorretivasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ManutencoesCorretivasView();
  }
}

class _ManutencoesCorretivasView extends StatelessWidget {
  const _ManutencoesCorretivasView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManutencoesCorretivasProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ManutencoesCorretivasPageHeader(),
          const SizedBox(height: 20),
          ManutencoesCorretivasPageActions(
            onNovaCorretiva: () {
              final provider = context.read<ManutencoesCorretivasProvider>();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: provider,
                    child: const ManutencaoCorretivaFormPage(),
                  ),
                ),
              );
            },
            onFiltros: () => _showNotReady(context, 'Filtros'),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.isEmpty) {
                  return const ManutencoesCorretivasEmptyState();
                }

                return ManutencoesCorretivasList(
                  items: provider.items,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showNotReady(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label será implementado na próxima etapa.'),
      ),
    );
  }
}
