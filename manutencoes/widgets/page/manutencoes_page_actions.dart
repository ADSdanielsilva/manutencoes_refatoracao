import 'package:flutter/material.dart';
import 'package:app_sindico/shared/models/condominio.dart';

import 'manutencoes_page_constants.dart';

class ManutencoesSidebar extends StatelessWidget {
  final Condominio condominio;
  final VoidCallback onAbrirRelatorio;
  final VoidCallback onVoltar;
  final bool canPop;

  const ManutencoesSidebar({
    super.key,
    required this.condominio,
    required this.onAbrirRelatorio,
    required this.onVoltar,
    required this.canPop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 292,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: ManutencoesUiColors.border),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SidebarBrandHeader(condominio: condominio),
              const SizedBox(height: 22),
              if (canPop) ...[
                SidebarActionTile(
                  icon: Icons.arrow_back_rounded,
                  iconColor: ManutencoesUiColors.textMuted,
                  title: 'Voltar',
                  subtitle: 'Retornar para a tela anterior',
                  onTap: onVoltar,
                ),
                const SizedBox(height: 10),
              ],
              SidebarActionTile(
                icon: Icons.dashboard_outlined,
                iconColor: ManutencoesUiColors.primary,
                title: 'Painel de Manutenções',
                subtitle: 'Visão geral do condomínio',
                selected: true,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              SidebarActionTile(
                icon: Icons.description_outlined,
                iconColor: ManutencoesUiColors.prox30,
                title: 'Relatório 30 dias',
                subtitle: 'Pendências e próximos vencimentos',
                onTap: onAbrirRelatorio,
              ),
              const SizedBox(height: 18),
              Text(
                'Resumo do módulo',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const SidebarInfoBox(
                icon: Icons.public,
                color: ManutencoesUiColors.diaria,
                text: 'Desktop com menu lateral fixo e conteúdo à direita.',
              ),
              const SizedBox(height: 10),
              const SidebarInfoBox(
                icon: Icons.phone_android,
                color: ManutencoesUiColors.pendente,
                text: 'Celular, tablet e web mobile usam comportamento de app.',
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ManutencoesUiColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: ManutencoesUiColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: ManutencoesUiColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'As periódicas agora aparecem separadas por Mensal, Trimestral, Semestral e Anual.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ManutencoesUiColors.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SidebarBrandHeader extends StatelessWidget {
  final Condominio condominio;

  const SidebarBrandHeader({
    super.key,
    required this.condominio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ManutencoesUiColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ManutencoesUiColors.primary.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: ManutencoesUiColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.handyman_outlined,
              color: ManutencoesUiColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manutenções',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  condominio.nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ManutencoesUiColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarInfoBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const SidebarInfoBox({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ManutencoesUiColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ManutencoesUiColors.textMuted,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ManutencoesDrawer extends StatelessWidget {
  final Condominio condominio;
  final VoidCallback onAbrirRelatorio;

  const ManutencoesDrawer({
    super.key,
    required this.condominio,
    required this.onAbrirRelatorio,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SidebarBrandHeader(condominio: condominio),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.dashboard_outlined,
                color: ManutencoesUiColors.primary,
              ),
              title: const Text('Painel de Manutenções'),
              subtitle: const Text('Visão geral'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.description_outlined,
                color: ManutencoesUiColors.prox30,
              ),
              title: const Text('Relatório 30 dias'),
              subtitle: const Text('Pendências e próximos vencimentos'),
              onTap: () {
                Navigator.pop(context);
                onAbrirRelatorio();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const SidebarActionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? ManutencoesUiColors.primary.withValues(alpha: 0.08)
        : Colors.white;

    final border = selected
        ? ManutencoesUiColors.primary.withValues(alpha: 0.18)
        : ManutencoesUiColors.border;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ManutencoesUiColors.textMuted,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
