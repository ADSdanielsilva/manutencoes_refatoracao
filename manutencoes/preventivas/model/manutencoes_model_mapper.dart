part of 'page/manutencoes_model.dart';

Map<String, dynamic> _manutencaoToMap(Manutencao model) {
  final contatoLegado = model.contato.trim().isNotEmpty
      ? model.contato.trim()
      : _buildContatoLegado(
          telefone: model.telefoneContato,
          nome: model.nomeContato,
        );

  return {
    'id': model.id.trim(),
    'condominioId': model.condominioId.trim(),
    'sindicoId': model.sindicoId.trim(),
    'titulo': model.titulo.trim(),
    'categoria': model.categoria.trim(),
    'observacoes': model.observacoes.trim(),
    'empresa': model.empresa.trim(),
    'telefoneContato': model.telefoneContato.trim(),
    'nomeContato': model.nomeContato.trim(),
    'contato': contatoLegado,
    if ((model.prestadorId ?? '').trim().isNotEmpty)
      'prestadorId': model.prestadorId!.trim(),
    if ((model.prestadorCategoria ?? '').trim().isNotEmpty)
      'prestadorCategoria': model.prestadorCategoria!.trim(),
    if ((model.prestadorEmpresa ?? '').trim().isNotEmpty)
      'prestadorEmpresa': model.prestadorEmpresa!.trim(),
    if ((model.prestadorResponsavel ?? '').trim().isNotEmpty)
      'prestadorResponsavel': model.prestadorResponsavel!.trim(),
    if ((model.prestadorTelefone ?? '').trim().isNotEmpty)
      'prestadorTelefone': model.prestadorTelefone!.trim(),
    'periodicidade': model.periodicidade.trim(),
    'periodicidadeTipo': periodicidadeTipoToStr(model.periodicidadeTipo),
    'intervaloValor': model.intervaloValorNormalizado,
    'intervaloUnidade':
        intervaloUnidadeToStr(model.intervaloUnidadeNormalizada),
    'ultimaExecucao': model.ultimaExecucao == null
        ? null
        : Timestamp.fromDate(dateOnly(model.ultimaExecucao!)),
    'dataCriacao': Timestamp.fromDate(dateOnly(model.dataCriacao)),
    'proximaData': model.proximaData == null
        ? null
        : Timestamp.fromDate(dateOnly(model.proximaData!)),
    'status': normalizarStatus(model.status),
    if ((model.seriesId ?? '').trim().isNotEmpty)
      'seriesId': model.seriesId!.trim(),
    if ((model.seriesKey ?? '').trim().isNotEmpty)
      'seriesKey': model.seriesKey!.trim(),
    'descricao': model.observacoes.trim(),
    'responsavel': model.empresa.trim(),
  };
}

Manutencao _manutencaoFromMap(Map<String, dynamic> map) {
  String s(dynamic v) => (v ?? '').toString().trim();
  String? n1(String v) => v.trim().isEmpty ? null : v.trim();

  final id = s(map['id']);
  final legacyDescricao = s(map['descricao']);
  final legacyResponsavel = s(map['responsavel']);

  final obs = s(map['observacoes']);
  final emp = s(map['empresa']);
  final titulo = s(map['titulo']);

  final servico = s(map['servico']);
  final categoria = s(map['categoria']).isNotEmpty
      ? s(map['categoria'])
      : (s(map['categoriaManutencao']).isNotEmpty
          ? s(map['categoriaManutencao'])
          : (s(map['tipoServico']).isNotEmpty
              ? s(map['tipoServico'])
              : servico));

  final prestadorId = s(map['prestadorId']);
  final prestadorCategoria = s(map['prestadorCategoria']);
  final prestadorEmpresa = s(map['prestadorEmpresa']);
  final prestadorResponsavel = s(map['prestadorResponsavel']);
  final prestadorTelefone = s(map['prestadorTelefone']);

  final periodicidadeRaw = s(map['periodicidade']);
  final periodicidadeLegacy =
      periodicidadeRaw.isEmpty ? 'Mensal' : periodicidadeRaw;

  final status = normalizarStatus(s(map['status']));

  final condominioId = s(map['condominioId']);
  final sindicoId = s(map['sindicoId']);

  final dataCriacao = dateOnly(
    parseManutencaoDate(map['dataCriacao']) ??
        parseManutencaoDate(map['createdAt']) ??
        parseManutencaoDate(map['importadoEm']) ??
        DateTime.now(),
  );

  final proximaDataParsed = parseManutencaoDate(map['proximaData']);
  final ultimaExecucaoParsed = parseManutencaoDate(map['ultimaExecucao']);

  final proximaData =
      proximaDataParsed == null ? null : dateOnly(proximaDataParsed);
  final ultimaExecucao =
      ultimaExecucaoParsed == null ? null : dateOnly(ultimaExecucaoParsed);

  final tipoRaw = s(map['periodicidadeTipo']);
  late final PeriodicidadeTipo tipo;

  if (tipoRaw.isNotEmpty) {
    tipo = periodicidadeTipoFromStr(tipoRaw);
  } else {
    final lp = periodicidadeLegacy.toLowerCase();
    tipo = (lp == 'diaria' || lp == 'diária')
        ? PeriodicidadeTipo.diaria
        : PeriodicidadeTipo.periodica;
  }

  int intervaloValor = 0;
  final iv = map['intervaloValor'];
  if (iv is int) intervaloValor = iv;
  if (iv is num) intervaloValor = iv.toInt();
  if (iv is String) intervaloValor = int.tryParse(iv) ?? 0;

  final iuRaw = s(map['intervaloUnidade']);
  IntervaloUnidade intervaloUnidade = iuRaw.isNotEmpty
      ? intervaloUnidadeFromStr(iuRaw)
      : IntervaloUnidade.meses;

  if (intervaloValor <= 0) {
    final legacy = legacyPeriodicidadeToInterval(periodicidadeLegacy);
    intervaloValor = legacy.valor;
    intervaloUnidade = legacy.unidade;
  }

  if (tipo == PeriodicidadeTipo.diaria) {
    intervaloValor = 1;
    intervaloUnidade = IntervaloUnidade.dias;
  }

  final seriesIdStr = s(map['seriesId']);
  final seriesIdNullable = seriesIdStr.isEmpty ? null : seriesIdStr;

  final seriesKeyStr = s(map['seriesKey']);
  final seriesKeyNullable = seriesKeyStr.isEmpty ? null : seriesKeyStr;

  var telefoneContato = s(map['telefoneContato']);
  var nomeContato = s(map['nomeContato']);
  final contatoLegado = s(map['contato']);

  if (telefoneContato.isEmpty && prestadorTelefone.isNotEmpty) {
    telefoneContato = prestadorTelefone;
  }
  if (nomeContato.isEmpty && prestadorResponsavel.isNotEmpty) {
    nomeContato = prestadorResponsavel;
  }

  if (telefoneContato.isEmpty &&
      nomeContato.isEmpty &&
      contatoLegado.isNotEmpty) {
    final parts = contatoLegado.split(RegExp(r'\s*-\s*'));

    if (parts.length >= 2) {
      final first = parts.first.trim();
      final rest = parts.sublist(1).join(' - ').trim();

      final firstDigits = first.replaceAll(RegExp(r'\D'), '');
      final firstLooksPhone = firstDigits.length >= 8;

      if (firstLooksPhone) {
        telefoneContato = first;
        nomeContato = rest;
      } else {
        nomeContato = first;
        telefoneContato = rest;
      }
    } else {
      final v = contatoLegado.trim();
      final looksLikePhone = RegExp(r'[\d\(\)\+\-\s]').hasMatch(v) &&
          v.replaceAll(RegExp(r'\D'), '').length >= 8;

      if (looksLikePhone) {
        telefoneContato = v;
      } else {
        nomeContato = v;
      }
    }
  }

  final empresaFinal = emp.isNotEmpty
      ? emp
      : (prestadorEmpresa.isNotEmpty
          ? prestadorEmpresa
          : (legacyResponsavel.isNotEmpty ? legacyResponsavel : '—'));

  final observacoesFinal = obs.isNotEmpty ? obs : legacyDescricao;

  final contatoFinal = contatoLegado.isNotEmpty
      ? contatoLegado
      : _buildContatoLegado(
          telefone: telefoneContato,
          nome: nomeContato,
        );

  final periodicidadeFinal = intervalToLegacyLabel(
    tipo,
    intervaloValor,
    intervaloUnidade,
    periodicidadeLegacy,
  );

  return Manutencao(
    id: id,
    condominioId: condominioId,
    sindicoId: sindicoId,
    titulo: titulo,
    categoria: categoria,
    observacoes: observacoesFinal,
    empresa: empresaFinal,
    telefoneContato: telefoneContato,
    nomeContato: nomeContato,
    contato: contatoFinal,
    periodicidade: periodicidadeFinal,
    periodicidadeTipo: tipo,
    intervaloValor: intervaloValor,
    intervaloUnidade: intervaloUnidade,
    ultimaExecucao: ultimaExecucao,
    dataCriacao: dataCriacao,
    proximaData: proximaData,
    status: status,
    seriesId: seriesIdNullable,
    seriesKey: seriesKeyNullable,
    prestadorId: n1(prestadorId),
    prestadorCategoria: n1(prestadorCategoria),
    prestadorEmpresa: n1(prestadorEmpresa),
    prestadorResponsavel: n1(prestadorResponsavel),
    prestadorTelefone: n1(prestadorTelefone),
  );
}
