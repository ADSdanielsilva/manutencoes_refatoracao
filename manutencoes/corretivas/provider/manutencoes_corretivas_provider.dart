import 'package:flutter/foundation.dart';

import '../model/manutencao_corretiva.dart';

class ManutencoesCorretivasProvider extends ChangeNotifier {
  final List<ManutencaoCorretiva> _items = [
    ManutencaoCorretiva(
      id: 'corr-1',
      titulo: 'Vazamento no hall de entrada',
      descricao: 'Infiltração identificada próxima ao quadro de energia.',
      status: ManutencaoCorretivaStatus.aberta,
      prioridade: ManutencaoCorretivaPrioridade.alta,
      custo: 0,
      dataAbertura: DateTime(2026, 3, 20),
    ),
    ManutencaoCorretiva(
      id: 'corr-2',
      titulo: 'Portão eletrônico com falha',
      descricao: 'Motor apresenta travamento intermitente na abertura.',
      status: ManutencaoCorretivaStatus.emAndamento,
      prioridade: ManutencaoCorretivaPrioridade.critica,
      custo: 450,
      dataAbertura: DateTime(2026, 3, 18),
    ),
    ManutencaoCorretiva(
      id: 'corr-3',
      titulo: 'Troca de luminária da garagem',
      descricao: 'Luminária substituída após queima do reator.',
      status: ManutencaoCorretivaStatus.concluida,
      prioridade: ManutencaoCorretivaPrioridade.media,
      custo: 180,
      dataAbertura: DateTime(2026, 3, 12),
      dataConclusao: DateTime(2026, 3, 13),
    ),
  ];

  bool _loading = false;

  List<ManutencaoCorretiva> get items => List.unmodifiable(_items);

  bool get loading => _loading;

  bool get isEmpty => _items.isEmpty;

  int get total => _items.length;

  void adicionar(ManutencaoCorretiva item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void atualizar(ManutencaoCorretiva item) {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    _items[index] = item;
    notifyListeners();
  }

  void setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }

  void setItems(List<ManutencaoCorretiva> value) {
    _items
      ..clear()
      ..addAll(value);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
