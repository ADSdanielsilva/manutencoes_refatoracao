import 'manutencoes_nav_item.dart';

class ManutencoesNavHelpers {
  static bool isManutencoesGroup(ManutencoesNavItem item) {
    return item == ManutencoesNavItem.preventivas ||
        item == ManutencoesNavItem.corretivas;
  }

  static bool isRelatoriosGroup(ManutencoesNavItem item) {
    return item == ManutencoesNavItem.relatoriosPreventivos ||
        item == ManutencoesNavItem.relatoriosCorretivos;
  }

  static String sectionTitle(ManutencoesNavItem item) {
    switch (item) {
      case ManutencoesNavItem.preventivas:
        return 'Manutenções Preventivas';
      case ManutencoesNavItem.corretivas:
        return 'Manutenções Corretivas';
      case ManutencoesNavItem.relatoriosPreventivos:
        return 'Relatórios Preventivos';
      case ManutencoesNavItem.relatoriosCorretivos:
        return 'Relatórios Corretivos';
    }
  }
}
