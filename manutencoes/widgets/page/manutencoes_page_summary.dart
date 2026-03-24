import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../manutencoes_model.dart';
import 'resumo_card_data.dart';
import 'package:app_sindico/features/manutencoes/manutencoes_provider.dart';
import 'manutencoes_page_constants.dart';

class ResumoCards extends StatelessWidget {
  final String condominioId;

  const ResumoCards({
    super.key,
    required this.condominioId,
  });

  bool _isConcluida(Manutencao m) {
    final s = m.status.trim().toLowerCase();
    return s.contains('conclu') || s == 'ok' || s == 'feito';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManutencoesProvider>();

    final diarias = provider.diarias(condominioId).length;
    final periodicas = provider.periodicas(condominioId).length;
    final vencidas = provider.pendentesVencidas(condominioId).length;
    final prox30 = provider.pendentesProximosNDias(condominioId).length;

    final todas = provider.porCondominio(condominioId);
    final pendentes = todas.where((m) => !_isConcluida(m)).length;
    final concluidas = todas.where((m) => _isConcluida(m)).length;

    final cards = <ResumoCardData>[
      ResumoCardData(
        title: 'Diárias',
        icon: Icons.today_outlined,
        iconBg: const Color(0xFFDBEAFE),
        iconColor: const Color(0xFF2563EB),
        value: diarias.toString(),
      ),
      ResumoCardData(
        title: 'Periódicas',
        icon: Icons.autorenew_outlined,
        iconBg: const Color(0xFFEDE9FE),
        iconColor: const Color(0xFF7C3AED),
        value: periodicas.toString(),
      ),
      ResumoCardData(
        title: 'Vencidas',
        icon: Icons.warning_amber_outlined,
        iconBg: const Color(0xFFFEE2E2),
        iconColor: const Color(0xFFEF4444),
        value: vencidas.toString(),
      ),
      ResumoCardData(
        title: 'Próx. 30 dias',
        icon: Icons.calendar_today_outlined,
        iconBg: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFF59E0B),
        value: prox30.toString(),
      ),
      ResumoCardData(
        title: 'Pendentes',
        icon: Icons.list_alt_outlined,
        iconBg: const Color(0xFFE0F2FE),
        iconColor: const Color(0xFF0EA5E9),
        value: pendentes.toString(),
      ),
      ResumoCardData(
        title: 'Concluídas',
        icon: Icons.check_circle_outline,
        iconBg: const Color(0xFFDCFCE7),
        iconColor: const Color(0xFF22C55E),
        value: concluidas.toString(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = constraints.maxWidth;

        int columns = (width / 220).floor();
        if (columns < 2) columns = 2;
        if (columns > cards.length) columns = cards.length;

        final itemWidth = (width - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map(
                (card) => SizedBox(
                  width: itemWidth,
                  child: AspectRatio(
                    aspectRatio: 3.0,
                    child: ResumoCard(card: card),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class ResumoCard extends StatelessWidget {
  final ResumoCardData card;

  const ResumoCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ManutencoesUiColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ManutencoesUiColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: card.iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(card.icon, color: card.iconColor),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                card.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ManutencoesUiColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              card.value,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
