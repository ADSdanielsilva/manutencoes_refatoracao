enum ManutencaoCorretivaStatus {
  aberta,
  emAndamento,
  concluida,
  cancelada,
}

enum ManutencaoCorretivaPrioridade {
  baixa,
  media,
  alta,
  critica,
}

class ManutencaoCorretiva {
  final String id;
  final String titulo;
  final String? descricao;
  final ManutencaoCorretivaStatus status;
  final ManutencaoCorretivaPrioridade prioridade;
  final double? custo;
  final DateTime? dataAbertura;
  final DateTime? dataConclusao;

  const ManutencaoCorretiva({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.status,
    required this.prioridade,
    this.custo,
    this.dataAbertura,
    this.dataConclusao,
  });

  ManutencaoCorretiva copyWith({
    String? id,
    String? titulo,
    String? descricao,
    ManutencaoCorretivaStatus? status,
    ManutencaoCorretivaPrioridade? prioridade,
    double? custo,
    DateTime? dataAbertura,
    DateTime? dataConclusao,
  }) {
    return ManutencaoCorretiva(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      prioridade: prioridade ?? this.prioridade,
      custo: custo ?? this.custo,
      dataAbertura: dataAbertura ?? this.dataAbertura,
      dataConclusao: dataConclusao ?? this.dataConclusao,
    );
  }
}
