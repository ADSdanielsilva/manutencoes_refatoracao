part of '../../manutencoes_provider.dart';

extension ManutencoesProviderQueries on ManutencoesProvider {
  List<Manutencao> porCondominio(String condominioId) {
    final cId = condominioId.trim();

    return _lista.where((m) => m.condominioId == cId).toList()
      ..sort(_sortByProximaData);
  }

  List<Manutencao> porCondominioETipo(
    String condominioId,
    String periodicidade,
  ) {
    final cId = condominioId.trim();
    final p = periodicidade.trim().toLowerCase();

    return _lista.where((m) {
      if (m.condominioId != cId) return false;
      return m.periodicidade.trim().toLowerCase() == p;
    }).toList()
      ..sort(_sortByProximaData);
  }

  List<Manutencao> porCondominioEPeriodicidade(
    String condominioId,
    String periodicidadeTipo,
  ) {
    final cId = condominioId.trim();
    final key = periodicidadeTipo.trim().toUpperCase();

    return _lista.where((m) {
      if (m.condominioId != cId) return false;

      if (key == 'DIARIA') return _isDiaria(m);
      if (key == 'PERIODICA') return _isPeriodica(m);

      return false;
    }).toList()
      ..sort(_sortByProximaData);
  }

  List<Manutencao> diarias(String condominioId) =>
      porCondominioEPeriodicidade(condominioId, 'DIARIA');

  List<Manutencao> periodicas(String condominioId) =>
      porCondominioEPeriodicidade(condominioId, 'PERIODICA');

  List<Manutencao> pendentesProximosNDias(
    String condominioId, {
    int dias = 30,
    bool incluirEmAndamento = true,
  }) {
    final cId = condominioId.trim();
    final hoje = _normalizeDate(DateTime.now());
    final limite = hoje.add(Duration(days: dias));

    bool statusOk(String s) {
      final v = _normalizeStatus(s).toLowerCase();
      if (v.contains('conclu')) return false;
      if (!incluirEmAndamento && v.contains('andamento')) return false;
      return true;
    }

    final items = _lista.where((m) {
      if (m.condominioId != cId) return false;
      if (!statusOk(m.status)) return false;

      final dt = m.proximaData;
      if (dt == null) return false;

      final d = _normalizeDate(dt);
      return !d.isBefore(hoje) && !d.isAfter(limite);
    }).toList()
      ..sort(_sortByProximaData);

    return items;
  }

  List<Manutencao> pendentesVencidas(
    String condominioId, {
    bool incluirEmAndamento = true,
  }) {
    final cId = condominioId.trim();
    final hoje = _normalizeDate(DateTime.now());

    bool statusOk(String s) {
      final v = _normalizeStatus(s).toLowerCase();
      if (v.contains('conclu')) return false;
      if (!incluirEmAndamento && v.contains('andamento')) return false;
      return true;
    }

    final items = _lista.where((m) {
      if (m.condominioId != cId) return false;
      if (!statusOk(m.status)) return false;

      final dt = m.proximaData;
      if (dt == null) return false;

      final d = _normalizeDate(dt);
      return d.isBefore(hoje);
    }).toList()
      ..sort(_sortByProximaData);

    return items;
  }

  RelatorioPendencias pendentesVencidasEAteNDias(
    String condominioId, {
    int dias = 30,
    bool incluirEmAndamento = true,
  }) {
    final vencidas = pendentesVencidas(
      condominioId,
      incluirEmAndamento: incluirEmAndamento,
    );

    final aVencer = pendentesProximosNDias(
      condominioId,
      dias: dias,
      incluirEmAndamento: incluirEmAndamento,
    );

    return RelatorioPendencias(vencidas: vencidas, aVencer: aVencer);
  }

  String exportXml30Dias({
    required String condominioId,
    required String condominioNome,
    int dias = 30,
    bool incluirEmAndamento = true,
  }) {
    final itens = pendentesProximosNDias(
      condominioId,
      dias: dias,
      incluirEmAndamento: incluirEmAndamento,
    );

    String esc(String s) => s
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');

    String fmt(DateTime? d) {
      if (d == null) return '-';
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      return '$dd/$mm/${d.year}';
    }

    final b = StringBuffer();
    b.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    b.writeln(
      '<manutencoes condominioId="${esc(condominioId)}" condominioNome="${esc(condominioNome)}" dias="$dias">',
    );

    for (final m in itens) {
      b.writeln('  <manutencao id="${esc(m.id)}">');
      b.writeln('    <data>${esc(fmt(m.proximaData))}</data>');
      b.writeln('    <periodicidade>${esc(m.periodicidade)}</periodicidade>');
      b.writeln('    <status>${esc(m.status)}</status>');
      b.writeln('    <servico>${esc(m.titulo)}</servico>');
      b.writeln('    <empresa>${esc(m.empresa)}</empresa>');
      b.writeln('    <contato>${esc(m.contato)}</contato>');
      b.writeln('    <observacoes>${esc(m.observacoes)}</observacoes>');
      b.writeln('  </manutencao>');
    }

    b.writeln('</manutencoes>');
    return b.toString();
  }
}
