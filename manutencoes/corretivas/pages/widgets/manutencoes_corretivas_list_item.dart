import 'package:flutter/material.dart';

import '../../forms/manutencao_corretiva_form_page.dart';
import '../../model/manutencao_corretiva.dart';
import 'manutencao_corretiva_custo_chip.dart';
import 'manutencao_corretiva_meta_row.dart';
import 'manutencao_corretiva_prioridade_chip.dart';
import 'manutencao_corretiva_status_chip.dart';
import 'package:provider/provider.dart';
import '../../provider/manutencoes_corretivas_provider.dart';

class ManutencoesCorretivasListItem extends StatelessWidget {
  final ManutencaoCorretiva item;

  const ManutencoesCorretivasListItem({
    super.key,
    required this.item,
  });

  void _abrirEdicao(BuildContext context) {
    final provider = context.read<ManutencoesCorretivasProvider>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: ManutencaoCorretivaFormPage(item: item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final descricao = item.descricao?.trim();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _abrirEdicao(context),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.18),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.titulo,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (descricao != null && descricao.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  descricao,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ManutencaoCorretivaStatusChip(status: item.status),
                  ManutencaoCorretivaPrioridadeChip(
                    prioridade: item.prioridade,
                  ),
                  if (item.custo != null)
                    ManutencaoCorretivaCustoChip(custo: item.custo!),
                ],
              ),
              const SizedBox(height: 12),
              ManutencaoCorretivaMetaRow(item: item),
            ],
          ),
        ),
      ),
    );
  }
}
