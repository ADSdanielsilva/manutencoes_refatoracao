part of 'page/manutencoes_provider.dart';

extension _ManutencoesProviderHelpers on ManutencoesProvider {
  void _setLoading(bool v) {
    _loading = v;
    _notify();
  }

  void _setError(Object? e) {
    _erro = e?.toString();
    _notify();
  }

  void _clearError() {
    _erro = null;
  }

  DateTime _normalizeDate(DateTime d) => dateOnly(d);

  String _normalizeStatus(String raw) => normalizarStatus(raw);

  int _sortByProximaData(Manutencao a, Manutencao b) {
    final da = a.proximaData ?? DateTime(2100);
    final db = b.proximaData ?? DateTime(2100);
    final byDate = da.compareTo(db);
    if (byDate != 0) return byDate;
    return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
  }

  void _sortLocalList() {
    _lista.sort(_sortByProximaData);
  }

  void _upsertLocal(Manutencao item) {
    final index = _lista.indexWhere((m) => m.id == item.id);
    if (index >= 0) {
      _lista[index] = item;
    } else {
      _lista.add(item);
    }
    _sortLocalList();
    _notify();
  }

  void _removeLocal(String id) {
    _lista.removeWhere((m) => m.id == id);
    _notify();
  }

  String _capitalize(String s) {
    final t = s.trim();
    if (t.isEmpty) return t;
    return t[0].toUpperCase() + t.substring(1);
  }

  String _toTextoSeguro(dynamic v) {
    if (v == null) return '';
    return v.toString().trim();
  }

  DateTime? _parseAnyDate(dynamic v) {
    if (v == null) return null;

    if (v is Timestamp) {
      return v.toDate();
    }

    if (v is DateTime) {
      return v;
    }

    if (v is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(v);
      } catch (_) {
        return null;
      }
    }

    if (v is num) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(v.toInt());
      } catch (_) {
        return null;
      }
    }

    if (v is String) {
      final raw = v.trim();
      if (raw.isEmpty) return null;

      try {
        return DateTime.parse(raw);
      } catch (_) {}

      final br = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(raw);
      if (br != null) {
        final dia = int.tryParse(br.group(1)!);
        final mes = int.tryParse(br.group(2)!);
        final ano = int.tryParse(br.group(3)!);
        if (dia != null && mes != null && ano != null) {
          return DateTime(ano, mes, dia);
        }
      }
    }

    return null;
  }

  Map<String, String> _splitContatoLegado(dynamic contatoRaw) {
    final contato = _toTextoSeguro(contatoRaw);
    if (contato.isEmpty) {
      return const {
        'nomeContato': '',
        'telefoneContato': '',
      };
    }

    final phoneMatch = RegExp(
      r'(\(?\d{2}\)?\s?\d{4,5}-?\d{4})',
    ).firstMatch(contato);

    final telefone = phoneMatch?.group(1)?.trim() ?? '';

    String nome = contato;
    if (telefone.isNotEmpty) {
      nome = nome.replaceFirst(telefone, '');
    }

    nome = nome
        .replaceAll(RegExp(r'^\s*[-–—:|]+\s*'), '')
        .replaceAll(RegExp(r'\s*[-–—:|]+\s*$'), '')
        .trim();

    return {
      'nomeContato': nome,
      'telefoneContato': telefone,
    };
  }

  Map<String, dynamic> _normalizeImportedMap(
    Map<String, dynamic> source, {
    required String docId,
    required String condominioId,
  }) {
    final map = Map<String, dynamic>.from(source);

    final titulo = _toTextoSeguro(map['titulo']);
    final servico = _toTextoSeguro(map['servico']);
    final categoria = _toTextoSeguro(map['categoria']);
    final periodicidade = _toTextoSeguro(map['periodicidade']);
    final status = _toTextoSeguro(map['status']);
    final empresa = _toTextoSeguro(map['empresa']);
    final contato = _toTextoSeguro(map['contato']);
    final observacoes = _toTextoSeguro(map['observacoes']);

    final dadosContato = _splitContatoLegado(contato);

    final proximaDataRaw = map['proximaData'];
    final dataCriacaoRaw =
        map['dataCriacao'] ?? map['createdAt'] ?? map['importadoEm'];

    final proximaData = _parseAnyDate(proximaDataRaw);
    final dataCriacao = _parseAnyDate(dataCriacaoRaw) ?? DateTime.now();

    final periodicidadeNorm = periodicidade.trim().toLowerCase();

    final bool isDiaria =
        periodicidadeNorm == 'diária' || periodicidadeNorm == 'diaria';

    int intervaloValor = 1;
    IntervaloUnidade intervaloUnidade = IntervaloUnidade.meses;
    PeriodicidadeTipo periodicidadeTipo = PeriodicidadeTipo.periodica;

    if (isDiaria) {
      periodicidadeTipo = PeriodicidadeTipo.diaria;
      intervaloValor = 1;
      intervaloUnidade = IntervaloUnidade.dias;
    } else {
      periodicidadeTipo = PeriodicidadeTipo.periodica;

      switch (periodicidadeNorm) {
        case 'mensal':
          intervaloValor = 1;
          intervaloUnidade = IntervaloUnidade.meses;
          break;
        case 'bimestral':
          intervaloValor = 2;
          intervaloUnidade = IntervaloUnidade.meses;
          break;
        case 'trimestral':
          intervaloValor = 3;
          intervaloUnidade = IntervaloUnidade.meses;
          break;
        case 'semestral':
          intervaloValor = 6;
          intervaloUnidade = IntervaloUnidade.meses;
          break;
        case 'anual':
          intervaloValor = 1;
          intervaloUnidade = IntervaloUnidade.anos;
          break;
        default:
          intervaloValor = 1;
          intervaloUnidade = IntervaloUnidade.meses;
      }
    }

    final condominioIdFinal = _toTextoSeguro(map['condominioId']).isNotEmpty
        ? _toTextoSeguro(map['condominioId'])
        : condominioId;

    final nomeContatoFinal = _toTextoSeguro(map['nomeContato']).isNotEmpty
        ? _toTextoSeguro(map['nomeContato'])
        : (dadosContato['nomeContato'] ?? '');

    final telefoneContatoFinal =
        _toTextoSeguro(map['telefoneContato']).isNotEmpty
            ? _toTextoSeguro(map['telefoneContato'])
            : (dadosContato['telefoneContato'] ?? '');

    return {
      ...map,
      'id': docId,
      'condominioId': condominioIdFinal,
      'titulo': titulo,
      'categoria': categoria.isNotEmpty ? categoria : servico,
      'servico': servico.isNotEmpty ? servico : categoria,
      'empresa': empresa,
      'contato': contato,
      'nomeContato': nomeContatoFinal,
      'telefoneContato': telefoneContatoFinal,
      'observacoes': observacoes,
      'status': status.isNotEmpty
          ? _capitalize(_normalizeStatus(status))
          : 'Pendente',
      'periodicidade': periodicidade.isNotEmpty ? periodicidade : 'Mensal',
      'periodicidadeTipo': periodicidadeTipoToStr(periodicidadeTipo),
      'intervaloValor': intervaloValor,
      'intervaloUnidade': intervaloUnidadeToStr(intervaloUnidade),
      'dataCriacao': dataCriacao,
      'proximaData': proximaData,
      'origem': _toTextoSeguro(map['origem']).isNotEmpty
          ? _toTextoSeguro(map['origem'])
          : 'importacao_planilha',
    };
  }

  void _applySnapshot(QuerySnapshot<Map<String, dynamic>> snap) {
    final condominioId = _condominioAtualId ?? '';

    final items = snap.docs.map((doc) {
      final data = doc.data();

      final normalizedMap = _normalizeImportedMap(
        data,
        docId: doc.id,
        condominioId: condominioId,
      );

      return Manutencao.fromMap(normalizedMap);
    }).toList();

    items.sort(_sortByProximaData);

    _lista
      ..clear()
      ..addAll(items);
  }

  bool _isDiaria(Manutencao m) {
    if (m.periodicidadeTipo == PeriodicidadeTipo.diaria) return true;

    final p = m.periodicidade.trim().toLowerCase();
    return p == 'diária' || p == 'diaria';
  }

  bool _isPeriodica(Manutencao m) => !_isDiaria(m);

  Manutencao _normalizePrestadorFields(Manutencao m) {
    final hasPrestador = (m.prestadorId ?? '').trim().isNotEmpty ||
        (m.prestadorEmpresa ?? '').trim().isNotEmpty ||
        (m.prestadorTelefone ?? '').trim().isNotEmpty ||
        (m.prestadorResponsavel ?? '').trim().isNotEmpty;

    if (!hasPrestador) {
      return m.copyWith(
        status: _normalizeStatus(m.status),
        proximaData:
            m.proximaData == null ? null : _normalizeDate(m.proximaData!),
        dataCriacao: _normalizeDate(m.dataCriacao),
        ultimaExecucao:
            m.ultimaExecucao == null ? null : _normalizeDate(m.ultimaExecucao!),
      );
    }

    final empresa = m.empresa.trim().isNotEmpty
        ? m.empresa.trim()
        : (m.prestadorEmpresa ?? '').trim();

    final tel = m.telefoneContato.trim().isNotEmpty
        ? m.telefoneContato.trim()
        : (m.prestadorTelefone ?? '').trim();

    final nome = m.nomeContato.trim().isNotEmpty
        ? m.nomeContato.trim()
        : (m.prestadorResponsavel ?? '').trim();

    final contatoLegado =
        Manutencao.buildContatoLegado(telefone: tel, nome: nome);

    return m.copyWith(
      empresa: empresa.isNotEmpty ? empresa : m.empresa,
      telefoneContato: tel,
      nomeContato: nome,
      contato: m.contato.trim().isNotEmpty ? m.contato : contatoLegado,
      status: _normalizeStatus(m.status),
      proximaData:
          m.proximaData == null ? null : _normalizeDate(m.proximaData!),
      dataCriacao: _normalizeDate(m.dataCriacao),
      ultimaExecucao:
          m.ultimaExecucao == null ? null : _normalizeDate(m.ultimaExecucao!),
    );
  }

  DateTime _proximaPorPeriodicidade(String periodicidade, DateTime base) {
    switch (periodicidade.trim()) {
      case 'Diária':
      case 'Diaria':
        return _addDaysSafe(base, 1);
      case 'Periódica':
      case 'Periodica':
        return _addMonthsSafe(base, 12);
      case 'Anual':
        return _addMonthsSafe(base, 12);
      case 'Semestral':
        return _addMonthsSafe(base, 6);
      case 'Trimestral':
        return _addMonthsSafe(base, 3);
      case 'Bimestral':
        return _addMonthsSafe(base, 2);
      case 'Mensal':
      default:
        return _addMonthsSafe(base, 1);
    }
  }

  DateTime _proximaPorPeriodicidadeFlex(Manutencao m, DateTime base) {
    try {
      final next = _normalizeDate(m.calcularProximaData(base));
      if (!next.isAfter(_normalizeDate(base))) {
        throw StateError('Próxima data inválida');
      }
      return next;
    } catch (_) {
      return _proximaPorPeriodicidade(m.periodicidade, base);
    }
  }

  DateTime _addDaysSafe(DateTime date, int daysToAdd) {
    final d = DateTime(date.year, date.month, date.day);
    return d.add(Duration(days: daysToAdd));
  }

  DateTime _addMonthsSafe(DateTime date, int monthsToAdd) {
    final d = DateTime(date.year, date.month, date.day);

    final totalMonths = (d.year * 12) + (d.month - 1) + monthsToAdd;
    final newYear = totalMonths ~/ 12;
    final newMonth = (totalMonths % 12) + 1;

    final lastDay = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = d.day > lastDay ? lastDay : d.day;

    return DateTime(newYear, newMonth, newDay);
  }
}
