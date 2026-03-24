part of '../../manutencoes_provider.dart';

extension ManutencoesProviderCrud on ManutencoesProvider {
  Future<void> adicionar(Manutencao manutencao) async {
    final condominioId = manutencao.condominioId.trim();
    if (condominioId.isEmpty) {
      throw ArgumentError('Manutencao.condominioId não pode ser vazio');
    }

    final base = _normalizePrestadorFields(manutencao);

    final proxima = base.proximaData != null
        ? _normalizeDate(base.proximaData!)
        : base.sugerirProximaData();

    _clearError();

    try {
      final seriesKey = _buildSeriesKey(base);
      late final String docId;
      late final DocumentReference<Map<String, dynamic>> ref;

      if (base.id.trim().isEmpty) {
        docId = _serieDocId(seriesKey, proxima);
        ref = _colManutencoes(condominioId).doc(docId);
      } else {
        docId = base.id.trim();
        ref = _colManutencoes(condominioId).doc(docId);
      }

      final m = base.copyWith(
        id: docId,
        condominioId: condominioId,
        sindicoId: base.sindicoId.isNotEmpty ? base.sindicoId : _uid,
        dataCriacao: _normalizeDate(base.dataCriacao),
        proximaData: proxima,
        seriesKey: seriesKey,
        status: base.status.trim().isEmpty
            ? 'Pendente'
            : _normalizeStatus(base.status),
      );

      _upsertLocal(m);

      final data = {
        ...m.toMap(),
        'id': docId,
        'condominioId': condominioId,
        'sindicoId': m.sindicoId,
        'seriesKey': seriesKey,
        if ((m.seriesId ?? '').trim().isNotEmpty)
          'seriesId': m.seriesId!.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await ref.set(data, SetOptions(merge: true));
    } catch (e) {
      _setError(e);
      rethrow;
    }
  }

  Future<void> atualizar(
    Manutencao manutencao, {
    EscopoAtualizacaoSerie escopo = EscopoAtualizacaoSerie.onlyThis,
  }) async {
    final condominioId = manutencao.condominioId.trim();
    final id = manutencao.id.trim();

    if (condominioId.isEmpty) {
      throw ArgumentError('Manutencao.condominioId não pode ser vazio');
    }
    if (id.isEmpty) {
      throw ArgumentError('Manutencao.id não pode ser vazio para atualizar');
    }

    _clearError();

    if (escopo != EscopoAtualizacaoSerie.onlyThis) {
      await atualizarComEscopo(
        manutencao: manutencao,
        escopo: escopo,
      );
      return;
    }

    try {
      final ref = _colManutencoes(condominioId).doc(id);
      final base = _normalizePrestadorFields(manutencao);

      final normalizedProxima =
          base.proximaData == null ? null : _normalizeDate(base.proximaData!);

      final normalizedUltima = base.ultimaExecucao == null
          ? null
          : _normalizeDate(base.ultimaExecucao!);

      final seriesKey = _buildSeriesKey(base);

      final atualizado = base.copyWith(
        proximaData: normalizedProxima,
        proximaDataToNull: normalizedProxima == null,
        ultimaExecucao: normalizedUltima,
        ultimaExecucaoToNull: normalizedUltima == null,
        seriesKey: seriesKey,
        seriesId: base.seriesId,
        sindicoId: base.sindicoId.isNotEmpty ? base.sindicoId : _uid,
        dataCriacao: _normalizeDate(base.dataCriacao),
        status: _normalizeStatus(base.status),
      );

      _upsertLocal(atualizado);

      final data = {
        ...atualizado.toMap(),
        'id': id,
        'condominioId': condominioId,
        'sindicoId': atualizado.sindicoId,
        'seriesKey': seriesKey,
        if ((base.seriesId ?? '').trim().isNotEmpty)
          'seriesId': base.seriesId!.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await ref.set(data, SetOptions(merge: true));
    } catch (e) {
      _setError(e);
      rethrow;
    }
  }

  Future<void> concluir(
    Manutencao manutencao, {
    DateTime? dataConclusao,
  }) async {
    final concluidaEm = _normalizeDate(dataConclusao ?? DateTime.now());
    final proxima = _normalizeDate(manutencao.calcularProximaData(concluidaEm));

    final atualizada = manutencao.copyWith(
      ultimaExecucao: concluidaEm,
      proximaData: proxima,
      status: 'Concluída',
    );

    await atualizar(atualizada);
  }

  Future<void> marcarEmAndamento(Manutencao manutencao) async {
    await atualizar(manutencao.copyWith(status: 'Em andamento'));
  }

  Future<void> reabrir(Manutencao manutencao) async {
    await atualizar(manutencao.copyWith(status: 'Pendente'));
  }

  Future<void> remover(String condominioId, String id) async {
    final c = condominioId.trim();
    final docId = id.trim();

    if (c.isEmpty) throw ArgumentError('condominioId não pode ser vazio');
    if (docId.isEmpty) throw ArgumentError('id não pode ser vazio');

    _clearError();

    try {
      _removeLocal(docId);
      await _colManutencoes(c).doc(docId).delete();
    } catch (e) {
      _setError(e);
      rethrow;
    }
  }
}
