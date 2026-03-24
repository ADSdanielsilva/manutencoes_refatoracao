import 'package:flutter/material.dart';

import '../navigation/manutencoes_nav_helpers.dart';
import '../navigation/manutencoes_nav_item.dart';
import 'sidebar_expandable_group.dart';
import 'sidebar_submenu_item.dart';

class ManutencoesSidebar extends StatefulWidget {
  final ManutencoesNavItem currentItem;
  final ValueChanged<ManutencoesNavItem> onNavigate;

  const ManutencoesSidebar({
    super.key,
    required this.currentItem,
    required this.onNavigate,
  });

  @override
  State<ManutencoesSidebar> createState() => _ManutencoesSidebarState();
}

class _ManutencoesSidebarState extends State<ManutencoesSidebar> {
  late bool manutencoesExpanded;
  late bool relatoriosExpanded;

  @override
  void initState() {
    super.initState();
    manutencoesExpanded =
        ManutencoesNavHelpers.isManutencoesGroup(widget.currentItem);
    relatoriosExpanded =
        ManutencoesNavHelpers.isRelatoriosGroup(widget.currentItem);
  }

  @override
  void didUpdateWidget(covariant ManutencoesSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentItem != widget.currentItem) {
      manutencoesExpanded =
          ManutencoesNavHelpers.isManutencoesGroup(widget.currentItem);
      relatoriosExpanded =
          ManutencoesNavHelpers.isRelatoriosGroup(widget.currentItem);
    }
  }

  void _handleNavigate(ManutencoesNavItem item) {
    final scaffold = Scaffold.maybeOf(context);
    final drawerAberto = scaffold?.isDrawerOpen ?? false;

    if (drawerAberto) {
      Navigator.of(context).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onNavigate(item);
      });
      return;
    }

    widget.onNavigate(item);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.18),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SidebarExpandableGroup(
            title: 'Manutenções',
            icon: Icons.build_outlined,
            expanded: manutencoesExpanded,
            onToggle: () {
              setState(() => manutencoesExpanded = !manutencoesExpanded);
            },
            children: [
              SidebarSubmenuItem(
                title: 'Preventivas',
                icon: Icons.event_repeat_outlined,
                selected: widget.currentItem == ManutencoesNavItem.preventivas,
                onTap: () => _handleNavigate(ManutencoesNavItem.preventivas),
              ),
              SidebarSubmenuItem(
                title: 'Corretivas',
                icon: Icons.build_circle_outlined,
                selected: widget.currentItem == ManutencoesNavItem.corretivas,
                onTap: () => _handleNavigate(ManutencoesNavItem.corretivas),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SidebarExpandableGroup(
            title: 'Relatórios',
            icon: Icons.bar_chart_outlined,
            expanded: relatoriosExpanded,
            onToggle: () {
              setState(() => relatoriosExpanded = !relatoriosExpanded);
            },
            children: [
              SidebarSubmenuItem(
                title: 'Preventivos',
                icon: Icons.description_outlined,
                selected: widget.currentItem ==
                    ManutencoesNavItem.relatoriosPreventivos,
                onTap: () => _handleNavigate(
                  ManutencoesNavItem.relatoriosPreventivos,
                ),
              ),
              SidebarSubmenuItem(
                title: 'Corretivos',
                icon: Icons.assessment_outlined,
                selected: widget.currentItem ==
                    ManutencoesNavItem.relatoriosCorretivos,
                onTap: () => _handleNavigate(
                  ManutencoesNavItem.relatoriosCorretivos,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
