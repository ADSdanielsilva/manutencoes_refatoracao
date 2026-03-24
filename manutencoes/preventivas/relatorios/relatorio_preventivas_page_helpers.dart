part of 'page/relatorio_preventivas_page.dart';

mixin _Relatorio30DiasPageHelpersMixin on _Relatorio30DiasPageBaseMixin {
  _RelatorioCompleto _buildRelatorioCompleto(
    ManutencoesProvider prov,
    RelatorioPendencias relPendencias,
  ) {
    final concluidas = _obterConcluidasDoProvider(prov, widget.condominioId);

    return _RelatorioCompleto(
      vencidas: _sortByDate(relPendencias.vencidas),
      aVencer: _sortByDate(relPendencias.aVencer),
      concluidas: _sortByDate(concluidas, asc: false),
    );
  }

  List<Manutencao> _obterConcluidasDoProvider(
    ManutencoesProvider prov,
    String condominioId,
  ) {
    final dynamic p = prov;

    final candidatos = <dynamic>[];

    void tentar(void Function() action) {
      try {
        action();
      } catch (_) {
        // ignora tentativa inválida
      }
    }

    tentar(() => candidatos.add(p.listarPorCondominio(condominioId)));
    tentar(() => candidatos.add(p.obterPorCondominio(condominioId)));
    tentar(() => candidatos.add(p.getManutencoesPorCondominio(condominioId)));
    tentar(() => candidatos.add(p.manutencoesDoCondominio(condominioId)));
    tentar(() => candidatos.add(p.listarManutencoesDoCondominio(condominioId)));
    tentar(() => candidatos.add(p.itensDoCondominio(condominioId)));
    tentar(() => candidatos.add(p.manutencoes));
    tentar(() => candidatos.add(p.itens));
    tentar(() => candidatos.add(p.lista));
    tentar(() => candidatos.add(p.todas));

    for (final candidato in candidatos) {
      final lista = _normalizarListaDeManutencao(candidato);
      if (lista.isEmpty) continue;

      final filtradas = lista.where((m) {
        final mesmoCondominio = _matchesCondominioId(m, condominioId);
        final concluida = _isConcluida(m);
        return mesmoCondominio && concluida;
      }).toList();

      if (filtradas.isNotEmpty) {
        return filtradas;
      }
    }

    return <Manutencao>[];
  }

  List<Manutencao> _normalizarListaDeManutencao(dynamic value) {
    if (value == null) return <Manutencao>[];

    if (value is List<Manutencao>) {
      return value;
    }

    if (value is Iterable) {
      return value.whereType<Manutencao>().toList();
    }

    return <Manutencao>[];
  }

  bool _matchesCondominioId(Manutencao m, String condominioId) {
    final value = _safeString(
      _readField(
        m,
        const [
          'condominioId',
          'idCondominio',
          'condominioID',
        ],
      ),
    );

    return value == condominioId;
  }

  bool _isConcluida(Manutencao m) {
    final status = _normalize(_statusManutencao(m));

    if (status.contains('conclu')) return true;
    if (status == 'finalizada') return true;
    if (status == 'finalizado') return true;
    if (status == 'realizada') return true;
    if (status == 'realizado') return true;
    if (status == 'encerrada') return true;
    if (status == 'encerrado') return true;

    final concluido = _readField(
      m,
      const [
        'concluida',
        'concluido',
        'isConcluida',
        'isConcluido',
      ],
    );

    if (concluido is bool && concluido) return true;

    return false;
  }

  String _tituloManutencao(Manutencao m) {
    final titulo = _safeString(
      _readField(
        m,
        const ['titulo', 'servico', 'nome'],
      ),
    );
    return titulo.isEmpty ? 'Manutenção' : titulo;
  }

  String _periodicidadeManutencao(Manutencao m) {
    return _safeString(
      _readField(
        m,
        const ['periodicidade', 'frequencia'],
      ),
    );
  }

  String _statusManutencao(Manutencao m) {
    return _safeString(
      _readField(
        m,
        const ['status', 'situacao'],
      ),
    );
  }

  dynamic _readField(Manutencao m, List<String> candidates) {
    final dynamic d = m;
    for (final field in candidates) {
      try {
        final value = _readNamedField(d, field);
        if (value != null) return value;
      } catch (_) {
        // tenta próximo
      }
    }
    return null;
  }

  dynamic _readNamedField(dynamic target, String field) {
    switch (field) {
      case 'titulo':
        return target.titulo;
      case 'servico':
        return target.servico;
      case 'nome':
        return target.nome;
      case 'status':
        return target.status;
      case 'situacao':
        return target.situacao;
      case 'periodicidade':
        return target.periodicidade;
      case 'frequencia':
        return target.frequencia;
      case 'empresa':
        return target.empresa;
      case 'contato':
        return target.contato;
      case 'condominioId':
        return target.condominioId;
      case 'idCondominio':
        return target.idCondominio;
      case 'condominioID':
        return target.condominioID;
      case 'concluida':
        return target.concluida;
      case 'concluido':
        return target.concluido;
      case 'isConcluida':
        return target.isConcluida;
      case 'isConcluido':
        return target.isConcluido;
      default:
        return null;
    }
  }

  List<Manutencao> _sortByDate(
    List<Manutencao> items, {
    bool asc = true,
  }) {
    final list = [...items];
    list.sort((a, b) {
      final da = a.proximaData ?? DateTime(2100);
      final db = b.proximaData ?? DateTime(2100);
      return asc ? da.compareTo(db) : db.compareTo(da);
    });
    return list;
  }

  String _statusDisplay(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return '-';
    return s;
  }

  String _safeString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  bool _looksLikeEmail(String s) {
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(s);
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  String _fmtDateTime(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final nn = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$nn';
  }

  String _fmtDateFile(DateTime dt) {
    final d = dt.toLocal();
    final yyyy = d.year.toString();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final nn = d.minute.toString().padLeft(2, '0');
    return '$yyyy$mm$dd' '_$hh$nn';
  }

  String _sanitize(String s) {
    return s.replaceAll(RegExp(r'[^a-zA-Z0-9_\\-]+'), '_');
  }

  String _escapeHtml(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}
