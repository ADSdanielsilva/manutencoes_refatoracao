part of '../../manutencoes_provider.dart';

extension ManutencoesProviderSeries on ManutencoesProvider {
  String buildSeriesKey(Manutencao m) => _buildSeriesKey(m);

  String buildDocIdBySeriesAndDate(String seriesKey, DateTime d) =>
      _serieDocId(seriesKey, d);

  Future<void> adicionarSerie(
    Manutencao base, {
    int mesesHorizonte = 24,
  }) async {
    final condominioId = base.condominioId.trim();
    if (condominioId.isEmpty) {
      throw ArgumentError('Manutencao.condominioId não pode ser vazio');
    }
    if (mesesHorizonte <= 0) {
      throw ArgumentError('mesesHorizonte deve ser maior que zero');
    }

    final baseNorm = _normalizePrestadorFields(base);
    final dt = baseNorm.proximaData ?? baseNorm.sugerirProximaData();

    _clearError();

    DateTime cursor = _normalizeDate(dt);
    final limite = _addMonthsSafe(cursor, mesesHorizonte);

    final seriesKey = _buildSeriesKey(baseNorm);
    final seriesId = (baseNorm.seriesId ?? '').trim().isNotEmpty
        ? baseNorm.seriesId!.trim()
        : _newSeriesId();

    final datas = <DateTime>[];
    int guard = 0;

    while (!cursor.isAfter(limite)) {
      guard++;
      if (guard > 1000) break;

      datas.add(cursor);
      cursor = _proximaPorPeriodicidadeFlex(baseNorm, cursor);

      if (datas.isNotEmpty && !cursor.isAfter(datas.last)) {
        throw StateError(
          'A próxima data da série não avançou. Verifique a periodicidade configurada.',
        );
      }
    }

    const int batchLimit = 400;

    try {
      int i = 0;
      while (i < datas.length) {
        final end =
            (i + batchLimit < datas.length) ? i + batchLimit : datas.length;
        final chunk = datas.sublist(i, end);

        final batch = _db.batch();

        for (final d in chunk) {
          final docId = _serieDocId(seriesKey, d);
          final ref = _colManutencoes(condominioId).doc(docId);

          final m = baseNorm.copyWith(
            id: docId,
            condominioId: condominioId,
            sindicoId:
                baseNorm.sindicoId.isNotEmpty ? baseNorm.sindicoId : _uid,
            dataCriacao: _normalizeDate(baseNorm.dataCriacao),
            proximaData: d,
            ultimaExecucaoToNull: true,
            status: 'Pendente',
            seriesKey: seriesKey,
            seriesId: seriesId,
          );

          batch.set(
            ref,
            {
              ...m.toMap(),
              'id': docId,
              'condominioId': condominioId,
              'sindicoId': m.sindicoId,
              'seriesKey': seriesKey,
              'seriesId': seriesId,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }

        await batch.commit();
        i = end;
      }
    } catch (e) {
      _setError(e);
      rethrow;
    }
  }

  Future<void> atualizarSerie({
    required String condominioId,
    String? seriesId,
    String? seriesKey,
    required Map<String, dynamic> patch,
    DateTime? futureFrom,
  }) async {
    final c = condominioId.trim();
    final sid = (seriesId ?? '').trim();
    final sk = (seriesKey ?? '').trim();

    if (c.isEmpty) throw ArgumentError('condominioId não pode ser vazio');
    if (sid.isEmpty && sk.isEmpty) {
      throw ArgumentError('Informe seriesId ou seriesKey');
    }
    if (patch.isEmpty) return;

    _clearError();

    final safePatch = Map<String, dynamic>.from(patch)
      ..remove('id')
      ..remove('condominioId')
      ..remove('sindicoId')
      ..remove('createdAt')
      ..remove('dataCriacao')
      ..remove('updatedAt')
      ..remove('proximaData')
      ..remove('ultimaExecucao')
      ..remove('seriesId')
      ..remove('seriesKey');

    safePatch.remove('status');

    if (safePatch.containsKey('periodicidadeTipo')) {
      final tipoRaw = (safePatch['periodicidadeTipo'] ?? '').toString();
      final tipo = periodicidadeTipoFromStr(tipoRaw);
      if (tipo == PeriodicidadeTipo.diaria) {
        safePatch['intervaloValor'] = 1;
        safePatch['intervaloUnidade'] = 'DIAS';
        safePatch['periodicidade'] = 'Diária';
      }
    }

    safePatch['updatedAt'] = FieldValue.serverTimestamp();

    if (safePatch.isEmpty) return;

    try {
      String effectiveSeriesId = sid;

      if (effectiveSeriesId.isEmpty && sk.isNotEmpty) {
        effectiveSeriesId = _newSeriesId();

        await _backfillSeriesIdBySeriesKey(
          condominioId: c,
          seriesKey: sk,
          newSeriesId: effectiveSeriesId,
          futureFrom: futureFrom,
        );
      }

      Query<Map<String, dynamic>> q =
          _colManutencoes(c).where('seriesId', isEqualTo: effectiveSeriesId);

      if (futureFrom != null) {
        final anchor = _normalizeDate(futureFrom);
        q = q.where(
          'proximaData',
          isGreaterThanOrEqualTo: Timestamp.fromDate(anchor),
        );
      }

      final snap = await q.get();

      const int chunkSize = 450;
      int i = 0;

      while (i < snap.docs.length) {
        final end = (i + chunkSize < snap.docs.length)
            ? i + chunkSize
            : snap.docs.length;

        final batch = _db.batch();
        for (final doc in snap.docs.sublist(i, end)) {
          batch.update(doc.reference, safePatch);
        }

        await batch.commit();
        i = end;
      }
    } catch (e) {
      _setError(e);
      rethrow;
    }
  }

  Future<void> atualizarComEscopo({
    required Manutencao manutencao,
    required EscopoAtualizacaoSerie escopo,
    Map<String, dynamic>? patch,
  }) async {
    final cId = manutencao.condominioId.trim();
    if (cId.isEmpty) {
      throw ArgumentError('Manutencao.condominioId não pode ser vazio');
    }

    final base = _normalizePrestadorFields(manutencao);
    final sid = (base.seriesId ?? '').trim();
    final sk = (base.seriesKey ?? '').trim();

    if (escopo == EscopoAtualizacaoSerie.onlyThis ||
        (sid.isEmpty && sk.isEmpty)) {
      await atualizar(base);
      return;
    }

    final map = patch ?? base.toMap();

    if (escopo == EscopoAtualizacaoSerie.allInSeries) {
      await atualizarSerie(
        condominioId: cId,
        seriesId: sid.isNotEmpty ? sid : null,
        seriesKey: sid.isEmpty ? sk : null,
        patch: map,
      );
      return;
    }

    await atualizarSerie(
      condominioId: cId,
      seriesId: sid.isNotEmpty ? sid : null,
      seriesKey: sid.isEmpty ? sk : null,
      patch: map,
      futureFrom: base.proximaData,
    );
  }

  String _buildSeriesKey(Manutencao m) {
    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s\-\+\(\)]', unicode: true), '');

    final pid = (m.prestadorId ?? '').trim();

    final empresaBase = (m.prestadorEmpresa ?? '').trim().isNotEmpty
        ? (m.prestadorEmpresa ?? '').trim()
        : m.empresa;

    final telefoneBase = (m.prestadorTelefone ?? '').trim().isNotEmpty
        ? (m.prestadorTelefone ?? '').trim()
        : m.telefoneContato;

    final responsavelBase = (m.prestadorResponsavel ?? '').trim().isNotEmpty
        ? (m.prestadorResponsavel ?? '').trim()
        : m.nomeContato;

    final contatoEstruturado = Manutencao.buildContatoLegado(
      telefone: telefoneBase,
      nome: responsavelBase,
    );

    final contatoBase =
        contatoEstruturado.trim().isNotEmpty ? contatoEstruturado : m.contato;

    final tipo = periodicidadeTipoToStr(m.periodicidadeTipo);
    final intervaloValor =
        m.periodicidadeTipo == PeriodicidadeTipo.diaria ? 1 : m.intervaloValor;
    final intervaloUnidade = intervaloUnidadeToStr(
      m.periodicidadeTipo == PeriodicidadeTipo.diaria
          ? IntervaloUnidade.dias
          : m.intervaloUnidade,
    );

    final raw = [
      'titulo:${norm(m.titulo)}',
      'tipo:$tipo',
      'intervalo:$intervaloValor',
      'unidade:$intervaloUnidade',
      pid.isNotEmpty ? 'pid:${norm(pid)}' : 'emp:${norm(empresaBase)}',
      'contato:${norm(contatoBase)}',
    ].join('|');

    return _simpleHash(raw);
  }

  String _simpleHash(String input) {
    int hash = 5381;
    for (final c in input.codeUnits) {
      hash = ((hash << 5) + hash) + c;
      hash &= 0x7fffffff;
    }
    return hash.toRadixString(16);
  }

  String _newSeriesId() => 'SER_${DateTime.now().millisecondsSinceEpoch}';

  Future<int> _backfillSeriesIdBySeriesKey({
    required String condominioId,
    required String seriesKey,
    required String newSeriesId,
    DateTime? futureFrom,
  }) async {
    final c = condominioId.trim();
    final sk = seriesKey.trim();
    final sid = newSeriesId.trim();

    if (c.isEmpty) throw ArgumentError('condominioId vazio');
    if (sk.isEmpty) throw ArgumentError('seriesKey vazio');
    if (sid.isEmpty) throw ArgumentError('newSeriesId vazio');

    Query<Map<String, dynamic>> q =
        _colManutencoes(c).where('seriesKey', isEqualTo: sk);

    if (futureFrom != null) {
      final anchor = _normalizeDate(futureFrom);
      q = q.where(
        'proximaData',
        isGreaterThanOrEqualTo: Timestamp.fromDate(anchor),
      );
    }

    final snap = await q.get();

    const int chunkSize = 450;
    int i = 0;
    int updated = 0;

    while (i < snap.docs.length) {
      final end =
          (i + chunkSize < snap.docs.length) ? i + chunkSize : snap.docs.length;
      final batch = _db.batch();

      for (final doc in snap.docs.sublist(i, end)) {
        batch.update(doc.reference, {
          'seriesId': sid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        updated++;
      }

      await batch.commit();
      i = end;
    }

    return updated;
  }

  String _serieDocId(String seriesKey, DateTime d) {
    final dd = _normalizeDate(d);
    final y = dd.year.toString().padLeft(4, '0');
    final m = dd.month.toString().padLeft(2, '0');
    final day = dd.day.toString().padLeft(2, '0');
    return '${seriesKey}_$y$m$day';
  }
}
