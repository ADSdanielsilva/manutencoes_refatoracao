import 'package:flutter/material.dart';

import 'package:app_sindico/features/manutencoes/preventivas/model/page/manutencoes_model.dart';

import 'manutencoes_page_card_actions.dart';
import 'manutencoes_page_constants.dart';

class ManutencaoCard extends StatelessWidget {
  final Manutencao manutencao;
  final String statusLabel;
  final String dataFormatada;
  final Color statusColor;
  final String? prestadorLinha;
  final String contatoTexto;
  final bool showLegacyEmpresaContato;
  final bool isSerie;
  final VoidCallback onTap;
  final VoidCallback onEditar;
  final VoidCallback? onConcluir;
  final VoidCallback onExcluir;

  const ManutencaoCard({
    super.key,
    required this.manutencao,
    required this.statusLabel,
    required this.dataFormatada,
    required this.statusColor,
    required this.prestadorLinha,
    required this.contatoTexto,
    required this.showLegacyEmpresaContato,
    required this.isSerie,
    required this.onTap,
    required this.onEditar,
    required this.onConcluir,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 760;
    final concluida = onConcluir == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ManutencoesUiColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(width < 480 ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ManutencaoCardHeader(
                manutencao: manutencao,
                statusLabel: statusLabel,
                statusColor: statusColor,
                isSerie: isSerie,
                isCompact: isCompact,
              ),
              const SizedBox(height: 14),
              _ManutencaoCardInfoSection(
                manutencao: manutencao,
                dataFormatada: dataFormatada,
                prestadorLinha: prestadorLinha,
              ),
              if (showLegacyEmpresaContato) ...[
                const SizedBox(height: 12),
                _ManutencaoCardLegacyInfoSection(
                  manutencao: manutencao,
                  contatoTexto: contatoTexto,
                ),
              ],
              if (manutencao.observacoes.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                _ManutencaoCardObservacoes(
                  observacoes: manutencao.observacoes,
                ),
              ],
              const SizedBox(height: 14),
              ManutencaoCardActions(
                isCompact: isCompact,
                concluida: concluida,
                onEditar: onEditar,
                onConcluir: onConcluir,
                onExcluir: onExcluir,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManutencaoCardHeader extends StatelessWidget {
  final Manutencao manutencao;
  final String statusLabel;
  final Color statusColor;
  final bool isSerie;
  final bool isCompact;

  const _ManutencaoCardHeader({
    required this.manutencao,
    required this.statusLabel,
    required this.statusColor,
    required this.isSerie,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            manutencao.titulo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (isSerie)
                const MiniInfoTag(
                  icon: Icons.repeat,
                  color: ManutencoesUiColors.primary,
                  label: 'Série',
                ),
              StatusChip(label: statusLabel, color: statusColor),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            manutencao.titulo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        const SizedBox(width: 12),
        if (isSerie) ...[
          const MiniInfoTag(
            icon: Icons.repeat,
            color: ManutencoesUiColors.primary,
            label: 'Série',
          ),
          const SizedBox(width: 8),
        ],
        StatusChip(label: statusLabel, color: statusColor),
      ],
    );
  }
}

class _ManutencaoCardInfoSection extends StatelessWidget {
  final Manutencao manutencao;
  final String dataFormatada;
  final String? prestadorLinha;

  const _ManutencaoCardInfoSection({
    required this.manutencao,
    required this.dataFormatada,
    required this.prestadorLinha,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        InfoPill(
          icon: Icons.event_outlined,
          iconColor: ManutencoesUiColors.diaria,
          text: 'Próxima: $dataFormatada',
        ),
        InfoPill(
          icon: Icons.schedule_outlined,
          iconColor: ManutencoesUiColors.periodica,
          text: manutencao.periodicidade,
        ),
        if (prestadorLinha != null)
          InfoPill(
            icon: Icons.handyman_outlined,
            iconColor: ManutencoesUiColors.pendente,
            text: prestadorLinha!,
          ),
      ],
    );
  }
}

class _ManutencaoCardLegacyInfoSection extends StatelessWidget {
  final Manutencao manutencao;
  final String contatoTexto;

  const _ManutencaoCardLegacyInfoSection({
    required this.manutencao,
    required this.contatoTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        if (manutencao.empresa.trim().isNotEmpty)
          InfoPill(
            icon: Icons.business_outlined,
            iconColor: ManutencoesUiColors.primary,
            text: manutencao.empresa,
          ),
        if (contatoTexto.isNotEmpty)
          InfoPill(
            icon: Icons.phone_outlined,
            iconColor: ManutencoesUiColors.statusConcluida,
            text: contatoTexto,
          ),
      ],
    );
  }
}

class _ManutencaoCardObservacoes extends StatelessWidget {
  final String observacoes;

  const _ManutencaoCardObservacoes({
    required this.observacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ManutencoesUiColors.border),
      ),
      child: Text(
        observacoes,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ManutencoesUiColors.textMuted,
              height: 1.35,
            ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.22)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class MiniInfoTag extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const MiniInfoTag({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const InfoPill({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isVerySmall = MediaQuery.of(context).size.width < 420;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isVerySmall ? 320 : 420),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ManutencoesUiColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
