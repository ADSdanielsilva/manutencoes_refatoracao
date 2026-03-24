part of '../../manutencoes_model.dart';

int _manutencaoIntervaloValorNormalizado(Manutencao model) {
  if (model.isDiaria) return 1;
  return model.intervaloValor <= 0 ? 1 : model.intervaloValor;
}

IntervaloUnidade _manutencaoIntervaloUnidadeNormalizada(Manutencao model) {
  if (model.isDiaria) return IntervaloUnidade.dias;
  return model.intervaloUnidade;
}

DateTime _manutencaoCalcularProximaData(Manutencao model, DateTime base) {
  final b = dateOnly(base);

  if (model.periodicidadeTipo == PeriodicidadeTipo.diaria) {
    return addDays(b, 1);
  }

  final v = model.intervaloValor <= 0 ? 1 : model.intervaloValor;

  switch (model.intervaloUnidade) {
    case IntervaloUnidade.dias:
      return addDays(b, v);
    case IntervaloUnidade.meses:
      return addMonthsClamped(b, v);
    case IntervaloUnidade.anos:
      return addYearsClamped(b, v);
  }
}

DateTime _manutencaoSugerirProximaData(Manutencao model) {
  if (model.proximaData != null) return dateOnly(model.proximaData!);
  if (model.ultimaExecucao != null) {
    return model.calcularProximaData(model.ultimaExecucao!);
  }
  return model.calcularProximaData(DateTime.now());
}

String _buildContatoLegado({
  required String telefone,
  required String nome,
}) {
  final t = telefone.trim();
  final n = nome.trim();

  if (t.isEmpty && n.isEmpty) return '';
  if (t.isEmpty) return n;
  if (n.isEmpty) return t;
  return '$t - $n';
}

Manutencao _manutencaoCopyWith(
  Manutencao model, {
  String? id,
  String? condominioId,
  String? sindicoId,
  String? titulo,
  String? categoria,
  String? observacoes,
  String? empresa,
  String? telefoneContato,
  String? nomeContato,
  String? contato,
  String? prestadorId,
  String? prestadorCategoria,
  String? prestadorEmpresa,
  String? prestadorResponsavel,
  String? prestadorTelefone,
  String? periodicidade,
  PeriodicidadeTipo? periodicidadeTipo,
  int? intervaloValor,
  IntervaloUnidade? intervaloUnidade,
  DateTime? ultimaExecucao,
  bool ultimaExecucaoToNull = false,
  DateTime? dataCriacao,
  DateTime? proximaData,
  bool proximaDataToNull = false,
  String? status,
  String? seriesId,
  bool seriesIdToNull = false,
  String? seriesKey,
  bool seriesKeyToNull = false,
}) {
  final novoTelefone = telefoneContato ?? model.telefoneContato;
  final novoNome = nomeContato ?? model.nomeContato;
  final novoContato = contato ?? model.contato;

  final tipo = periodicidadeTipo ?? model.periodicidadeTipo;
  final ivRaw = intervaloValor ?? model.intervaloValor;
  final iuRaw = intervaloUnidade ?? model.intervaloUnidade;

  final iv = tipo == PeriodicidadeTipo.diaria ? 1 : (ivRaw <= 0 ? 1 : ivRaw);
  final iu = tipo == PeriodicidadeTipo.diaria ? IntervaloUnidade.dias : iuRaw;

  final periodicidadeFinal =
      periodicidade ?? intervalToLegacyLabel(tipo, iv, iu, model.periodicidade);

  final empresaBase = empresa ?? model.empresa;
  final empresaValue = empresaBase.trim().isNotEmpty
      ? empresaBase.trim()
      : ((prestadorEmpresa ?? model.prestadorEmpresa) ?? '—').trim();

  return Manutencao(
    id: id ?? model.id,
    condominioId: condominioId ?? model.condominioId,
    sindicoId: sindicoId ?? model.sindicoId,
    titulo: titulo ?? model.titulo,
    categoria: categoria ?? model.categoria,
    observacoes: observacoes ?? model.observacoes,
    empresa: empresaValue,
    telefoneContato: novoTelefone,
    nomeContato: novoNome,
    contato: novoContato.trim().isNotEmpty
        ? novoContato.trim()
        : _buildContatoLegado(
            telefone: novoTelefone,
            nome: novoNome,
          ),
    prestadorId: prestadorId ?? model.prestadorId,
    prestadorCategoria: prestadorCategoria ?? model.prestadorCategoria,
    prestadorEmpresa: prestadorEmpresa ?? model.prestadorEmpresa,
    prestadorResponsavel: prestadorResponsavel ?? model.prestadorResponsavel,
    prestadorTelefone: prestadorTelefone ?? model.prestadorTelefone,
    periodicidade: periodicidadeFinal,
    periodicidadeTipo: tipo,
    intervaloValor: iv,
    intervaloUnidade: iu,
    ultimaExecucao:
        ultimaExecucaoToNull ? null : (ultimaExecucao ?? model.ultimaExecucao),
    dataCriacao: dateOnly(dataCriacao ?? model.dataCriacao),
    proximaData: proximaDataToNull
        ? null
        : ((proximaData ?? model.proximaData) == null
            ? null
            : dateOnly(proximaData ?? model.proximaData!)),
    status: normalizarStatus(status ?? model.status),
    seriesId: seriesIdToNull ? null : (seriesId ?? model.seriesId),
    seriesKey: seriesKeyToNull ? null : (seriesKey ?? model.seriesKey),
  );
}
