part of 'manutencoes_page_list.dart';

extension _ManutencaoListaHelpers on _ManutencaoListaState {
  List<int> _anosSugestao() {
    final now = DateTime.now();
    return List.generate(9, (i) => now.year - 2 + i);
  }

  String get _labelAba {
    switch (widget.tab) {
      case ManutencaoTabMain.diaria:
        return 'Diárias';
      case ManutencaoTabMain.periodica:
        return 'Periódicas';
      case ManutencaoTabMain.todas:
        return 'Todas';
    }
  }

  String _statusEfetivo(Manutencao m) => _statusOverrides[m.id] ?? m.status;

  bool _isConcluidaStatus(String status) {
    final s = status.trim().toLowerCase();
    return s.contains('conclu') || s == 'ok' || s == 'feito';
  }

  bool _isConcluida(Manutencao m) => _isConcluidaStatus(_statusEfetivo(m));

  String _normalizarPeriodicidade(String value) {
    final s = value.trim().toLowerCase();
    if (s.contains('diar')) return 'diaria';
    if (s.contains('mens')) return 'mensal';
    if (s.contains('trimes')) return 'trimestral';
    if (s.contains('semestr')) return 'semestral';
    if (s.contains('anual') || s.contains('anu')) return 'anual';
    return 'outras';
  }

  String _tituloGrupo(String key) {
    switch (key) {
      case 'diaria':
        return 'Diárias';
      case 'mensal':
        return 'Mensal';
      case 'trimestral':
        return 'Trimestral';
      case 'semestral':
        return 'Semestral';
      case 'anual':
        return 'Anual';
      default:
        return 'Outras';
    }
  }

  List<String> _ordemGruposParaAba() {
    switch (widget.tab) {
      case ManutencaoTabMain.diaria:
        return const ['diaria'];
      case ManutencaoTabMain.periodica:
        return const ['mensal', 'trimestral', 'semestral', 'anual'];
      case ManutencaoTabMain.todas:
        return const [
          'diaria',
          'mensal',
          'trimestral',
          'semestral',
          'anual',
          'outras',
        ];
    }
  }

  Map<String, List<Manutencao>> _agruparLista(List<Manutencao> lista) {
    final grupos = <String, List<Manutencao>>{};
    for (final key in _ordemGruposParaAba()) {
      grupos[key] = <Manutencao>[];
    }
    for (final m in lista) {
      final grupo = _normalizarPeriodicidade(m.periodicidade);
      grupos.putIfAbsent(grupo, () => <Manutencao>[]);
      grupos[grupo]!.add(m);
    }
    return grupos;
  }

  Color _statusColor(Manutencao m) {
    final s = _statusEfetivo(m).trim().toLowerCase();
    if (s.contains('conclu') || s == 'ok' || s == 'feito') {
      return ManutencoesUiColors.statusConcluida;
    }

    final d = m.proximaData;
    if (d == null) return ManutencoesUiColors.statusNeutra;

    final hoje = DateTime.now();
    final hojeZerado = DateTime(hoje.year, hoje.month, hoje.day);
    final dataZerada = DateTime(d.year, d.month, d.day);

    if (dataZerada.isBefore(hojeZerado)) {
      return ManutencoesUiColors.statusVencida;
    }

    final limite30 = hojeZerado.add(const Duration(days: 30));
    if (!dataZerada.isAfter(limite30)) {
      return ManutencoesUiColors.statusProxima;
    }

    return ManutencoesUiColors.statusPlanejada;
  }

  String _formatDMY(DateTime d) {
    final dia = d.day.toString().padLeft(2, '0');
    final mes = d.month.toString().padLeft(2, '0');
    return '$dia/$mes/${d.year}';
  }

  String _fmtPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    if (digits.length < 8) return raw.trim();

    final newValue = TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );

    final out =
        _brPhone.formatEditUpdate(const TextEditingValue(text: ''), newValue);

    return out.text.trim().isEmpty ? raw.trim() : out.text.trim();
  }

  String _contatoTexto(Manutencao m) {
    final telRaw = m.telefoneContato.trim();
    final nome = m.nomeContato.trim();
    final tel = telRaw.isNotEmpty ? _fmtPhone(telRaw) : '';

    if (tel.isNotEmpty && nome.isNotEmpty) return '$tel - $nome';
    if (tel.isNotEmpty) return tel;
    if (nome.isNotEmpty) return nome;

    final legado = m.contato.trim();
    if (legado.isEmpty) return '';

    final legDigits = legado.replaceAll(RegExp(r'\D'), '');
    if (legDigits.length >= 8) return _fmtPhone(legado);

    return legado;
  }

  String? _prestadorLinha(Manutencao m) {
    final emp = (m.prestadorEmpresa ?? '').trim();
    final resp = (m.prestadorResponsavel ?? '').trim();
    final telRaw = (m.prestadorTelefone ?? '').trim();
    final tel = telRaw.isNotEmpty ? _fmtPhone(telRaw) : '';

    if (emp.isEmpty && resp.isEmpty && tel.isEmpty) return null;

    final parts = <String>[];
    if (emp.isNotEmpty) parts.add(emp);
    if (resp.isNotEmpty) parts.add(resp);
    if (tel.isNotEmpty) parts.add(tel);
    return parts.join(' • ');
  }

  List<Manutencao> _buscarListaAba(ManutencoesProvider provider) {
    final condominioId = widget.condominio.id;
    switch (widget.tab) {
      case ManutencaoTabMain.diaria:
        return provider.diarias(condominioId);
      case ManutencaoTabMain.periodica:
        return provider.periodicas(condominioId);
      case ManutencaoTabMain.todas:
        return provider.porCondominio(condominioId);
    }
  }

  List<Manutencao> _filtrarLista(ManutencoesProvider provider) {
    var lista = _buscarListaAba(provider);

    if (_anoFiltro != null) {
      lista = lista.where((m) {
        if (_normalizarPeriodicidade(m.periodicidade) == 'diaria') return true;
        return m.proximaData != null && m.proximaData!.year == _anoFiltro;
      }).toList();
    }

    if (_mesFiltro != null) {
      lista = lista.where((m) {
        if (_normalizarPeriodicidade(m.periodicidade) == 'diaria') return true;
        return m.proximaData != null && m.proximaData!.month == _mesFiltro;
      }).toList();
    }

    final termo = _busca.trim().toLowerCase();
    if (termo.isNotEmpty) {
      lista = lista.where((m) {
        final titulo = m.titulo.toLowerCase();
        final status = _statusEfetivo(m).toLowerCase();
        final periodicidade = m.periodicidade.toLowerCase();
        final observacoes = m.observacoes.toLowerCase();
        return titulo.contains(termo) ||
            status.contains(termo) ||
            periodicidade.contains(termo) ||
            observacoes.contains(termo);
      }).toList();
    }

    if (widget.tab == ManutencaoTabMain.periodica) {
      lista = lista.where((m) {
        return _normalizarPeriodicidade(m.periodicidade) ==
            _periodicidadeFiltro;
      }).toList();
    }

    lista.sort((a, b) {
      final da = a.proximaData ?? DateTime(2100);
      final db = b.proximaData ?? DateTime(2100);
      return da.compareTo(db);
    });

    return lista;
  }
}
