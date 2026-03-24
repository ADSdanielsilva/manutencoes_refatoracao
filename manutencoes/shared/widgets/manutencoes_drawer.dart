import 'package:flutter/material.dart';

import '../navigation/manutencoes_nav_item.dart';
import 'manutencoes_sidebar.dart';

class ManutencoesDrawer extends StatelessWidget {
  final ManutencoesNavItem currentItem;
  final ValueChanged<ManutencoesNavItem> onNavigate;

  const ManutencoesDrawer({
    super.key,
    required this.currentItem,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ManutencoesSidebar(
          currentItem: currentItem,
          onNavigate: onNavigate,
        ),
      ),
    );
  }
}
