part of '../../manutencoes_form_page.dart';

extension _ManutencaoFormPageActionsExtension on _ManutencaoFormPageState {
  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: manutencaoFormAjustarDataParaDatePicker(_proximaData),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      _updateState(() {
        _proximaData = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<EscopoAtualizacaoSerie?> _perguntarEscopoAtualizacao() async {
    if (!_editando) return EscopoAtualizacaoSerie.onlyThis;

    return showDialog<EscopoAtualizacaoSerie>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Salvar alterações'),
        content: const Text(
          'Deseja aplicar as alterações somente nesta manutenção ou em todas que foram geradas juntas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () =>
                Navigator.pop(context, EscopoAtualizacaoSerie.onlyThis),
            child: const Text('Somente esta'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, EscopoAtualizacaoSerie.allInSeries),
            child: const Text('Todas da série'),
          ),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    if (_salvando) return;

    final provider = context.read<ManutencoesProvider>();

    final formValido = _formKey.currentState?.validate() ?? false;
    if (!formValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revise os campos obrigatórios antes de salvar.'),
        ),
      );
      return;
    }

    if (_proximaData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a próxima data')),
      );
      return;
    }

    EscopoAtualizacaoSerie escopo = EscopoAtualizacaoSerie.onlyThis;

    if (_editando) {
      final escopoSelecionado = await _perguntarEscopoAtualizacao();
      if (escopoSelecionado == null) return;
      escopo = escopoSelecionado;
    }

    _updateState(() => _salvando = true);

    try {
      final atual = widget.manutencao;

      final manutencao = Manutencao(
        id: atual?.id ?? '',
        condominioId: widget.condominio.id,
        sindicoId: atual?.sindicoId ?? '',
        titulo: _tituloController.text.trim(),
        categoria: _categoriaController.text.trim(),
        observacoes: _observacoesController.text.trim(),
        empresa: _empresaController.text.trim(),
        telefoneContato: _telefoneController.text.trim(),
        nomeContato: _nomeContatoController.text.trim(),
        contato: Manutencao.buildContatoLegado(
          telefone: _telefoneController.text.trim(),
          nome: _nomeContatoController.text.trim(),
        ),
        periodicidade: _periodicidadeLabel,
        periodicidadeTipo: _periodicidadeTipo,
        intervaloValor: _periodicidadeTipo == PeriodicidadeTipo.diaria
            ? 1
            : _intervaloValor,
        intervaloUnidade: _periodicidadeTipo == PeriodicidadeTipo.diaria
            ? IntervaloUnidade.dias
            : _intervaloUnidade,
        dataCriacao: atual?.dataCriacao ?? DateTime.now(),
        proximaData: _proximaData,
        status: atual == null ? 'Pendente' : _status,
        ultimaExecucao: atual?.ultimaExecucao,
        seriesId: atual?.seriesId,
        seriesKey: atual?.seriesKey,
        prestadorId: manutencaoFormNullIfEmpty(_prestadorIdSelecionado),
        prestadorCategoria: manutencaoFormNullIfEmpty(
          _prestadorCategoriaSelecionada ?? _categoriaController.text,
        ),
        prestadorEmpresa:
            manutencaoFormNullIfEmpty(_prestadorEmpresaSelecionada),
        prestadorResponsavel:
            manutencaoFormNullIfEmpty(_prestadorResponsavelSelecionado),
        prestadorTelefone:
            manutencaoFormNullIfEmpty(_prestadorTelefoneSelecionado),
      );

      if (_editando) {
        await provider.atualizar(manutencao, escopo: escopo);
      } else {
        if (_gerarSerie && _periodicidadeTipo == PeriodicidadeTipo.periodica) {
          await provider.adicionarSerie(manutencao);
        } else {
          await provider.adicionar(manutencao);
        }
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar manutenção: $e')),
      );
    } finally {
      _updateState(() => _salvando = false);
    }
  }
}
