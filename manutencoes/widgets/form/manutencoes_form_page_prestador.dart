part of '../../manutencoes_form_page.dart';

extension _ManutencaoFormPagePrestadorExtension on _ManutencaoFormPageState {
  void _limparPrestadorSelecionado({bool limparCampos = false}) {
    _prestadorIdSelecionado = null;
    _prestadorCategoriaSelecionada = null;
    _prestadorEmpresaSelecionada = null;
    _prestadorResponsavelSelecionado = null;
    _prestadorTelefoneSelecionado = null;

    if (limparCampos) {
      _empresaController.clear();
      _nomeContatoController.clear();
      _telefoneMask.clear();
      _telefoneController.clear();
    }
  }

  void _aplicarPrestador(Prestador? prestador) {
    if (prestador == null) {
      _updateState(() {
        _limparPrestadorSelecionado();
      });
      return;
    }

    _updateState(() {
      _prestadorIdSelecionado = prestador.id;
      _prestadorCategoriaSelecionada =
          manutencaoFormNullIfEmpty(prestador.categoria);
      _prestadorEmpresaSelecionada =
          manutencaoFormNullIfEmpty(prestador.empresa);
      _prestadorResponsavelSelecionado =
          manutencaoFormNullIfEmpty(prestador.responsavel);
      _prestadorTelefoneSelecionado =
          manutencaoFormNullIfEmpty(prestador.telefone);

      _empresaController.text = prestador.empresa.trim();
      _nomeContatoController.text = prestador.responsavel.trim();
      _telefoneMask.formatEditUpdate(
        const TextEditingValue(),
        TextEditingValue(text: prestador.telefone.trim()),
      );
      _telefoneController.text = _telefoneMask.getMaskedText();
    });
  }

  bool _prestadorCompativelComCategoria(Prestador atual) {
    final categoriaPrestador = manutencaoFormNorm(atual.categoria);
    final categoriaManutencao = manutencaoFormNorm(_categoriaController.text);

    return categoriaManutencao.isEmpty ||
        categoriaPrestador == categoriaManutencao ||
        categoriaPrestador.contains(categoriaManutencao) ||
        categoriaManutencao.contains(categoriaPrestador);
  }

  void _onCategoriaChanged(PrestadoresProvider prestadoresProvider) {
    if ((_prestadorIdSelecionado ?? '').trim().isEmpty) return;

    final atual = prestadoresProvider.porId(_prestadorIdSelecionado);
    if (atual == null) return;

    if (!_prestadorCompativelComCategoria(atual)) {
      _updateState(() {
        _limparPrestadorSelecionado();
      });
    }
  }

  void _validarPrestadorSelecionado(PrestadoresProvider prestadoresProvider) {
    final prestadorSelecionadoAtual =
        prestadoresProvider.porId(_prestadorIdSelecionado);

    if (_prestadorIdSelecionado != null &&
        _prestadorIdSelecionado!.trim().isNotEmpty &&
        prestadorSelecionadoAtual == null &&
        !prestadoresProvider.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateState(() {
          _limparPrestadorSelecionado();
        });
      });
    }
  }
}
