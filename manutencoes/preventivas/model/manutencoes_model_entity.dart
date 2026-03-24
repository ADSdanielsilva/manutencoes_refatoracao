part of 'page/manutencoes_model.dart';

class Manutencao {
  final String id;
  final String condominioId;
  final String sindicoId;

  final String titulo;
  final String categoria;
  final String observacoes;
  final String empresa;

  final String telefoneContato;
  final String nomeContato;
  final String contato;

  final String? prestadorId;
  final String? prestadorCategoria;
  final String? prestadorEmpresa;
  final String? prestadorResponsavel;
  final String? prestadorTelefone;

  final String periodicidade;
  final PeriodicidadeTipo periodicidadeTipo;
  final int intervaloValor;
  final IntervaloUnidade intervaloUnidade;

  final DateTime? ultimaExecucao;
  final DateTime dataCriacao;
  final DateTime? proximaData;

  final String status;

  final String? seriesId;
  final String? seriesKey;

  const Manutencao({
    required this.id,
    required this.condominioId,
    required this.sindicoId,
    required this.titulo,
    required this.categoria,
    required this.observacoes,
    required this.empresa,
    required this.telefoneContato,
    required this.nomeContato,
    required this.contato,
    required this.periodicidade,
    required this.periodicidadeTipo,
    required this.intervaloValor,
    required this.intervaloUnidade,
    required this.dataCriacao,
    required this.proximaData,
    required this.status,
    this.ultimaExecucao,
    this.seriesId,
    this.seriesKey,
    this.prestadorId,
    this.prestadorCategoria,
    this.prestadorEmpresa,
    this.prestadorResponsavel,
    this.prestadorTelefone,
  });

  bool get isDiaria => periodicidadeTipo == PeriodicidadeTipo.diaria;

  int get intervaloValorNormalizado =>
      _manutencaoIntervaloValorNormalizado(this);

  IntervaloUnidade get intervaloUnidadeNormalizada =>
      _manutencaoIntervaloUnidadeNormalizada(this);

  DateTime calcularProximaData(DateTime base) =>
      _manutencaoCalcularProximaData(this, base);

  DateTime sugerirProximaData() => _manutencaoSugerirProximaData(this);

  static String buildContatoLegado({
    required String telefone,
    required String nome,
  }) {
    return _buildContatoLegado(
      telefone: telefone,
      nome: nome,
    );
  }

  Map<String, dynamic> toMap() => _manutencaoToMap(this);

  factory Manutencao.fromMap(Map<String, dynamic> map) =>
      _manutencaoFromMap(map);

  Manutencao copyWith({
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
    return _manutencaoCopyWith(
      this,
      id: id,
      condominioId: condominioId,
      sindicoId: sindicoId,
      titulo: titulo,
      categoria: categoria,
      observacoes: observacoes,
      empresa: empresa,
      telefoneContato: telefoneContato,
      nomeContato: nomeContato,
      contato: contato,
      prestadorId: prestadorId,
      prestadorCategoria: prestadorCategoria,
      prestadorEmpresa: prestadorEmpresa,
      prestadorResponsavel: prestadorResponsavel,
      prestadorTelefone: prestadorTelefone,
      periodicidade: periodicidade,
      periodicidadeTipo: periodicidadeTipo,
      intervaloValor: intervaloValor,
      intervaloUnidade: intervaloUnidade,
      ultimaExecucao: ultimaExecucao,
      ultimaExecucaoToNull: ultimaExecucaoToNull,
      dataCriacao: dataCriacao,
      proximaData: proximaData,
      proximaDataToNull: proximaDataToNull,
      status: status,
      seriesId: seriesId,
      seriesIdToNull: seriesIdToNull,
      seriesKey: seriesKey,
      seriesKeyToNull: seriesKeyToNull,
    );
  }
}
