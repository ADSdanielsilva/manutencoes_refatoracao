import 'package:flutter/material.dart';
import 'package:app_sindico/shared/models/condominio.dart';

import 'manutencoes_page_constants.dart';

class HeaderPainel extends StatelessWidget {
  final Condominio condominio;
  final VoidCallback onNovaManutencao;
  final VoidCallback onImportarPlanilha;
  final VoidCallback onVoltar;
  final bool canPop;

  const HeaderPainel({
    super.key,
    required this.condominio,
    required this.onNovaManutencao,
    required this.onImportarPlanilha,
    required this.onVoltar,
    required this.canPop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < ManutencoesBreakpoints.mobile;
    final isTablet = width >= ManutencoesBreakpoints.mobile &&
        width < ManutencoesBreakpoints.desktop;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: ManutencoesUiColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ManutencoesUiColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: (isMobile || isTablet)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumb(condominio: condominio),
                const SizedBox(height: 14),
                HeaderTitleBlock(condominio: condominio),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (canPop)
                      OutlinedButton.icon(
                        onPressed: onVoltar,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: onImportarPlanilha,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Importar planilha'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onNovaManutencao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManutencoesUiColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Nova manutenção'),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Breadcrumb(condominio: condominio),
                      const SizedBox(height: 14),
                      HeaderTitleBlock(condominio: condominio),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (canPop)
                      OutlinedButton.icon(
                        onPressed: onVoltar,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: onImportarPlanilha,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Importar planilha'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onNovaManutencao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ManutencoesUiColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Nova manutenção'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class Breadcrumb extends StatelessWidget {
  final Condominio condominio;

  const Breadcrumb({
    super.key,
    required this.condominio,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Text(
          'Condomínios',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ManutencoesUiColors.textMuted,
              ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: ManutencoesUiColors.textMuted,
        ),
        Text(
          condominio.nome,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ManutencoesUiColors.textMuted,
              ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: ManutencoesUiColors.textMuted,
        ),
        Text(
          'Preventivas',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: ManutencoesUiColors.primary,
              ),
        ),
      ],
    );
  }
}

class HeaderTitleBlock extends StatelessWidget {
  final Condominio condominio;

  const HeaderTitleBlock({
    super.key,
    required this.condominio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile =
        MediaQuery.of(context).size.width < ManutencoesBreakpoints.mobile;
    final nome = condominio.nome.trim();
    final lower = nome.toLowerCase();

    final prefixo =
        lower.startsWith('condomínio') || lower.startsWith('condominio')
            ? 'do'
            : 'do condomínio';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isMobile ? 48 : 54,
          height: isMobile ? 48 : 54,
          decoration: BoxDecoration(
            color: ManutencoesUiColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.handyman_outlined,
            color: ManutencoesUiColors.primary,
            size: isMobile ? 24 : 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manutenções Preventivas',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                  fontSize: isMobile ? 22 : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Controle das manutenções preventivas diárias, periódicas, vencidas e próximas $prefixo $nome.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ManutencoesUiColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
